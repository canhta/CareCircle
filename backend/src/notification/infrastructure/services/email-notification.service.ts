import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';
import { Transporter } from 'nodemailer';

export interface EmailPayload {
  to: string | string[];
  subject: string;
  text?: string;
  html?: string;
  attachments?: EmailAttachment[];
  priority?: 'high' | 'normal' | 'low';
  replyTo?: string;
  cc?: string | string[];
  bcc?: string | string[];
}

export interface EmailAttachment {
  filename: string;
  content?: Buffer | string;
  path?: string;
  contentType?: string;
  cid?: string; // Content-ID for inline images
}

export interface EmailDeliveryResult {
  success: boolean;
  messageId?: string;
  error?: string;
  recipients: string[];
  deliveredAt: Date;
}

export interface HealthcareEmailTemplate {
  type:
    | 'medication_reminder'
    | 'appointment_reminder'
    | 'health_alert'
    | 'emergency_alert'
    | 'care_group_update';
  subject: string;
  htmlTemplate: string;
  textTemplate: string;
  variables: Record<string, any>;
}

@Injectable()
export class EmailNotificationService {
  private readonly logger = new Logger(EmailNotificationService.name);
  private readonly transporter: Transporter;

  constructor(private readonly configService: ConfigService) {
    this.transporter = this.createTransporter();
  }

  private createTransporter(): Transporter {
    const nodeEnv = this.configService.get<string>('NODE_ENV');

    if (nodeEnv === 'production') {
      // Production SMTP configuration (e.g., SendGrid, AWS SES)
      return nodemailer.createTransport({
        host: this.configService.get<string>('SMTP_HOST'),
        port: this.configService.get<number>('SMTP_PORT', 587),
        secure: this.configService.get<boolean>('SMTP_SECURE', false),
        auth: {
          user: this.configService.get<string>('SMTP_USER'),
          pass: this.configService.get<string>('SMTP_PASS'),
        },
        pool: true,
        maxConnections: 5,
        maxMessages: 100,
        logger: false,
        debug: false,
      });
    } else {
      // Development/Test configuration (Ethereal Email)
      return nodemailer.createTransport({
        host: 'smtp.ethereal.email',
        port: 587,
        secure: false,
        auth: {
          user: this.configService.get<string>('ETHEREAL_USER'),
          pass: this.configService.get<string>('ETHEREAL_PASS'),
        },
      });
    }
  }

  /**
   * Send email notification
   */
  async sendEmail(payload: EmailPayload): Promise<EmailDeliveryResult> {
    try {
      const fromAddress = this.configService.get<string>(
        'EMAIL_FROM',
        'CareCircle <noreply@carecircle.com>',
      );

      const mailOptions = {
        from: fromAddress,
        to: Array.isArray(payload.to) ? payload.to.join(', ') : payload.to,
        cc: payload.cc
          ? Array.isArray(payload.cc)
            ? payload.cc.join(', ')
            : payload.cc
          : undefined,
        bcc: payload.bcc
          ? Array.isArray(payload.bcc)
            ? payload.bcc.join(', ')
            : payload.bcc
          : undefined,
        subject: payload.subject,
        text: payload.text,
        html: payload.html,
        attachments: payload.attachments,
        replyTo: payload.replyTo,
        priority: payload.priority || 'normal',
        headers: {
          'X-Mailer': 'CareCircle Healthcare Platform',
          'X-Priority': this.getPriorityHeader(payload.priority),
          'X-Healthcare-Notification': 'true',
        },
      };

      const info = (await this.transporter.sendMail(mailOptions)) as {
        messageId: string;
        [key: string]: unknown;
      };

      this.logger.log(`Email sent successfully: ${info.messageId}`);

      // Log preview URL for development
      if (this.configService.get<string>('NODE_ENV') !== 'production') {
        const previewUrl = nodemailer.getTestMessageUrl(
          info as unknown as Parameters<typeof nodemailer.getTestMessageUrl>[0],
        );
        if (previewUrl) {
          this.logger.log(`Preview URL: ${previewUrl}`);
        }
      }

      const recipients = Array.isArray(payload.to) ? payload.to : [payload.to];

      return {
        success: true,
        messageId: info.messageId,
        recipients,
        deliveredAt: new Date(),
      };
    } catch (error) {
      this.logger.error('Failed to send email:', error);

      const recipients = Array.isArray(payload.to) ? payload.to : [payload.to];

      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        recipients,
        deliveredAt: new Date(),
      };
    }
  }

  /**
   * Send healthcare-specific email notification
   */
  async sendHealthcareEmail(
    template: HealthcareEmailTemplate,
    to: string | string[],
  ): Promise<EmailDeliveryResult> {
    const htmlContent = this.processTemplate(
      template.htmlTemplate,
      template.variables,
    );
    const textContent = this.processTemplate(
      template.textTemplate,
      template.variables,
    );

    const payload: EmailPayload = {
      to,
      subject: this.processTemplate(template.subject, template.variables),
      html: this.wrapInHealthcareLayout(htmlContent, template.type),
      text: textContent,
      priority: template.type === 'emergency_alert' ? 'high' : 'normal',
    };

    return this.sendEmail(payload);
  }

  /**
   * Send medication reminder email
   */
  async sendMedicationReminder(
    to: string,
    medicationName: string,
    dosage: string,
    scheduledTime: Date,
    patientName: string,
  ): Promise<EmailDeliveryResult> {
    const template: HealthcareEmailTemplate = {
      type: 'medication_reminder',
      subject: 'Medication Reminder: {{medicationName}}',
      htmlTemplate: `
        <h2>Medication Reminder</h2>
        <p>Hello {{patientName}},</p>
        <p>This is a reminder to take your medication:</p>
        <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;">
          <strong>Medication:</strong> {{medicationName}}<br>
          <strong>Dosage:</strong> {{dosage}}<br>
          <strong>Scheduled Time:</strong> {{scheduledTime}}
        </div>
        <p>Please take your medication as prescribed by your healthcare provider.</p>
        <p>If you have any questions or concerns, please contact your healthcare team.</p>
      `,
      textTemplate: `
        Medication Reminder
        
        Hello {{patientName}},
        
        This is a reminder to take your medication:
        
        Medication: {{medicationName}}
        Dosage: {{dosage}}
        Scheduled Time: {{scheduledTime}}
        
        Please take your medication as prescribed by your healthcare provider.
        
        If you have any questions or concerns, please contact your healthcare team.
      `,
      variables: {
        medicationName,
        dosage,
        scheduledTime: scheduledTime.toLocaleString(),
        patientName,
      },
    };

    return this.sendHealthcareEmail(template, to);
  }

  /**
   * Send appointment reminder email
   */
  async sendAppointmentReminder(
    to: string,
    appointmentType: string,
    appointmentDate: Date,
    providerName: string,
    location: string,
    patientName: string,
  ): Promise<EmailDeliveryResult> {
    const template: HealthcareEmailTemplate = {
      type: 'appointment_reminder',
      subject:
        'Appointment Reminder: {{appointmentType}} with {{providerName}}',
      htmlTemplate: `
        <h2>Appointment Reminder</h2>
        <p>Hello {{patientName}},</p>
        <p>This is a reminder about your upcoming appointment:</p>
        <div style="background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin: 15px 0;">
          <strong>Appointment Type:</strong> {{appointmentType}}<br>
          <strong>Provider:</strong> {{providerName}}<br>
          <strong>Date & Time:</strong> {{appointmentDate}}<br>
          <strong>Location:</strong> {{location}}
        </div>
        <p>Please arrive 15 minutes early for check-in.</p>
        <p>If you need to reschedule or cancel, please contact us at least 24 hours in advance.</p>
      `,
      textTemplate: `
        Appointment Reminder
        
        Hello {{patientName}},
        
        This is a reminder about your upcoming appointment:
        
        Appointment Type: {{appointmentType}}
        Provider: {{providerName}}
        Date & Time: {{appointmentDate}}
        Location: {{location}}
        
        Please arrive 15 minutes early for check-in.
        
        If you need to reschedule or cancel, please contact us at least 24 hours in advance.
      `,
      variables: {
        appointmentType,
        appointmentDate: appointmentDate.toLocaleString(),
        providerName,
        location,
        patientName,
      },
    };

    return this.sendHealthcareEmail(template, to);
  }

  /**
   * Send emergency alert email
   */
  async sendEmergencyAlert(
    to: string | string[],
    alertType: string,
    message: string,
    patientName: string,
    emergencyContacts?: string[],
  ): Promise<EmailDeliveryResult> {
    const template: HealthcareEmailTemplate = {
      type: 'emergency_alert',
      subject: '🚨 EMERGENCY ALERT: {{alertType}}',
      htmlTemplate: `
        <div style="background-color: #ffebee; border: 2px solid #f44336; padding: 20px; border-radius: 5px;">
          <h2 style="color: #d32f2f; margin-top: 0;">🚨 EMERGENCY ALERT</h2>
          <p><strong>Alert Type:</strong> {{alertType}}</p>
          <p><strong>Patient:</strong> {{patientName}}</p>
          <p><strong>Message:</strong> {{message}}</p>
          <p><strong>Time:</strong> {{timestamp}}</p>
          
          <div style="background-color: #fff; padding: 15px; margin: 15px 0; border-radius: 3px;">
            <p style="margin: 0;"><strong>IMMEDIATE ACTION REQUIRED</strong></p>
            <p style="margin: 5px 0 0 0;">Please respond to this emergency alert immediately.</p>
          </div>
        </div>
      `,
      textTemplate: `
        🚨 EMERGENCY ALERT 🚨
        
        Alert Type: {{alertType}}
        Patient: {{patientName}}
        Message: {{message}}
        Time: {{timestamp}}
        
        IMMEDIATE ACTION REQUIRED
        Please respond to this emergency alert immediately.
      `,
      variables: {
        alertType,
        message,
        patientName,
        timestamp: new Date().toLocaleString(),
      },
    };

    // Send to emergency contacts as well if provided
    const allRecipients = Array.isArray(to) ? to : [to];
    if (emergencyContacts) {
      allRecipients.push(...emergencyContacts);
    }

    return this.sendHealthcareEmail(template, allRecipients);
  }

  /**
   * Verify email configuration
   */
  async verifyConnection(): Promise<boolean> {
    try {
      await this.transporter.verify();
      this.logger.log('Email service connection verified successfully');
      return true;
    } catch (error) {
      this.logger.error('Email service connection verification failed:', error);
      return false;
    }
  }

  /**
   * Process template variables
   */
  private processTemplate(
    template: string,
    variables: Record<string, any>,
  ): string {
    let processed = template;

    Object.entries(variables).forEach(([key, value]) => {
      const regex = new RegExp(`{{${key}}}`, 'g');
      processed = processed.replace(regex, String(value));
    });

    return processed;
  }

  /**
   * Wrap content in healthcare-branded email layout
   */
  private wrapInHealthcareLayout(content: string, type: string): string {
    const brandColor = this.getBrandColorForType(type);

    return `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CareCircle Notification</title>
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: ${brandColor}; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0;">
          <h1 style="margin: 0; font-size: 24px;">CareCircle</h1>
          <p style="margin: 5px 0 0 0; font-size: 14px;">Healthcare Notification Platform</p>
        </div>
        
        <div style="background-color: #ffffff; padding: 30px; border: 1px solid #ddd; border-top: none; border-radius: 0 0 5px 5px;">
          ${content}
          
          <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
          
          <div style="font-size: 12px; color: #666; text-align: center;">
            <p>This is an automated message from CareCircle Healthcare Platform.</p>
            <p>For support, contact us at <a href="mailto:support@carecircle.com">support@carecircle.com</a></p>
            <p>&copy; ${new Date().getFullYear()} CareCircle. All rights reserved.</p>
          </div>
        </div>
      </body>
      </html>
    `;
  }

  /**
   * Get brand color based on notification type
   */
  private getBrandColorForType(type: string): string {
    switch (type) {
      case 'emergency_alert':
        return '#d32f2f'; // Red
      case 'medication_reminder':
        return '#1976d2'; // Blue
      case 'appointment_reminder':
        return '#388e3c'; // Green
      case 'health_alert':
        return '#f57c00'; // Orange
      case 'care_group_update':
        return '#7b1fa2'; // Purple
      default:
        return '#1976d2'; // Default blue
    }
  }

  /**
   * Get priority header value
   */
  private getPriorityHeader(priority?: string): string {
    switch (priority) {
      case 'high':
        return '1 (Highest)';
      case 'low':
        return '5 (Lowest)';
      default:
        return '3 (Normal)';
    }
  }
}
