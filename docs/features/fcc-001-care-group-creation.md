# Feature Specification: Care Group Creation (FCC-001)

## Overview

**Feature ID:** FCC-001  
**Feature Name:** Care Group Creation  
**User Story:** As a family caregiver, I want to create care groups for different family members so I can manage their health needs separately.

## Detailed Description

The Care Group Creation feature allows users to establish dedicated care coordination groups for managing the health needs of family members. A care group serves as a central hub where designated caregivers can collaborate, share relevant health information, coordinate tasks, and receive notifications about a care recipient's health status. This feature is fundamental to the family-centric approach of CareCircle.

## Business Requirements

1. **Group Creation:** Users should be able to create multiple care groups for different family members.
2. **Role Assignment:** Users should be able to designate roles within the care group (primary caregiver, secondary caregiver, care recipient).
3. **Customizable Permissions:** Granular permission settings to control what health data is shared with which caregivers.
4. **Multi-generational Support:** Support for managing care across generations (children, parents, grandparents).
5. **Invitation System:** Secure method to invite family members to join a care group.
6. **Privacy Controls:** Clear consent mechanisms for data sharing within groups.
7. **Cultural Sensitivity:** Support for traditional family structures common in Southeast Asian cultures.
8. **Group Customization:** Ability to customize group settings, notifications, and appearance.

## User Experience

### Primary User Flow

1. User navigates to "Care Groups" tab in the app
2. User taps "Create New Care Group" button
3. User enters care group name and optional description
4. User selects the care recipient (self or family member)
5. If care recipient is not in the system, user enters basic information
6. User configures initial sharing permissions and notification preferences
7. User is prompted to invite additional caregivers
8. System creates the care group and generates invitation links/codes
9. User is taken to the new care group dashboard

### Mock UI

#### Care Group Creation Screen

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  Create Care Group                               │
│                                                  │
│  Group Name:                                     │
│  ┌────────────────────────────────────────────┐  │
│  │ Mom's Care Team                            │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  Description (Optional):                         │
│  ┌────────────────────────────────────────────┐  │
│  │ Group for coordinating mom's diabetes and  │  │
│  │ hypertension care                          │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  Care Recipient:                                 │
│  ◯ Myself                                        │
│  ● Family Member                                 │
│                                                  │
│  Select Existing Family Member:                  │
│  ┌────────────────────────────────────┐          │
│  │ + Add New Family Member            │ ▼        │
│  └────────────────────────────────────┘          │
│                                                  │
│                                                  │
│       ┌─────┐                    ┌──────┐        │
│       │ Cancel │                    │ Next  │        │
│       └─────┘                    └──────┘        │
└──────────────────────────────────────────────────┘
```

#### Add New Family Member Screen

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  Add Family Member                               │
│                                                  │
│  Full Name:                                      │
│  ┌────────────────────────────────────────────┐  │
│  │ Tran Thi Mai                               │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  Relationship:                                   │
│  ┌────────────────────────────────────┐          │
│  │ Mother                             │ ▼        │
│  └────────────────────────────────────┘          │
│                                                  │
│  Age:                                            │
│  ┌────────────────────────────────────────────┐  │
│  │ 68                                         │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  Does this person have their own account?        │
│  ◯ Yes, they have an account                     │
│  ● No, I'll manage for them                      │
│                                                  │
│  Health Conditions (Optional):                   │
│  ┌────────────────────────────────────────────┐  │
│  │ Type 2 Diabetes, Hypertension              │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│                                                  │
│       ┌─────┐                    ┌──────┐        │
│       │ Back  │                    │ Next  │        │
│       └─────┘                    └──────┘        │
└──────────────────────────────────────────────────┘
```

#### Permissions Setup Screen

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  Care Group Permissions                          │
│                                                  │
│  What health information do you want to share?   │
│                                                  │
│  ☑ Medications and adherence                     │
│  ☑ Blood pressure readings                       │
│  ☑ Blood glucose readings                        │
│  ☑ Daily health check-ins                        │
│  ☐ Weight and BMI                                │
│  ☐ Activity and steps                            │
│  ☑ Doctor appointments                           │
│  ☐ Detailed medical history                      │
│                                                  │
│  Share your contact information?                 │
│  ● Yes, with all caregivers                      │
│  ◯ Only with primary caregivers                  │
│  ◯ Don't share contact information               │
│                                                  │
│  Emergency alert settings:                       │
│  ☑ Send emergency alerts to all caregivers       │
│  ☑ Allow caregivers to access location in        │
│    emergency situations                          │
│                                                  │
│                                                  │
│       ┌─────┐                    ┌──────┐        │
│       │ Back  │                    │ Next  │        │
│       └─────┘                    └──────┘        │
└──────────────────────────────────────────────────┘
```

#### Invite Caregivers Screen

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  Invite Caregivers                               │
│                                                  │
│  Invite family members to join this care group:  │
│                                                  │
│  Email or Phone:                                 │
│  ┌────────────────────────────────────────────┐  │
│  │ nguyen.van.b@email.com                     │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  Role:                                           │
│  ┌────────────────────────────────────┐          │
│  │ Primary Caregiver                  │ ▼        │
│  └────────────────────────────────────┘          │
│                                                  │
│  Personal Message (Optional):                    │
│  ┌────────────────────────────────────────────┐  │
│  │ Hi brother, please join Mom's care group   │  │
│  │ so we can coordinate her health care.      │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  [+ Add Another Caregiver]                       │
│                                                  │
│  You can also invite caregivers after            │
│  creating the group.                             │
│                                                  │
│                                                  │
│       ┌─────┐                    ┌──────────┐    │
│       │ Back  │                    │ Create Group │    │
│       └─────┘                    └──────────┘    │
└──────────────────────────────────────────────────┘
```

### Alternative Flows

1. **Self as Care Recipient:**
   - User selects themselves as care recipient
   - System skips family member information steps
   - User proceeds directly to permissions setup

2. **Invite from Contacts:**
   - User chooses to select caregivers from contacts
   - App requests contact permission if not already granted
   - User selects contacts to invite as caregivers

3. **Create Multiple Care Recipients:**
   - User creates a care group for first family member
   - After completion, system asks if user wants to create another care group
   - User can create additional care groups with streamlined process

4. **Join Existing Care Group:**
   - User receives invitation link/code
   - User enters code or clicks link
   - System validates invitation and shows group details
   - User accepts invitation and is added to care group

## Technical Specifications

### Data Models

#### Care Group Entity

```typescript
interface CareGroup {
  id: string; // Unique identifier
  name: string; // Group name
  description?: string; // Optional description
  createdAt: Date; // Creation timestamp
  createdBy: string; // User ID of creator
  careRecipient: CareRecipient; // Person receiving care
  members: CareGroupMember[]; // Group members
  permissions: Permission[]; // Sharing permissions
  notificationSettings: NotificationSetting[]; // Alert preferences
  invitations: Invitation[]; // Pending invitations
}

interface CareRecipient {
  id: string; // Unique identifier
  userId?: string; // Optional if recipient has account
  name: string; // Full name
  dateOfBirth?: Date; // Birth date if available
  relationship: string; // Relationship to group creator
  healthConditions?: string[]; // Optional health conditions
  hasAccount: boolean; // Whether recipient has own account
}

interface CareGroupMember {
  id: string; // Unique identifier
  userId: string; // User ID
  role: "primary" | "secondary" | "observer" | "recipient"; // Role in group
  joinedAt: Date; // When user joined
  permissions: Permission[]; // Individual permissions
  notificationPreferences: NotificationPreference[]; // Personal alert settings
}
```

### API Endpoints

#### Care Group API

```
POST /api/care-groups
GET /api/care-groups
GET /api/care-groups/:id
PUT /api/care-groups/:id
DELETE /api/care-groups/:id
POST /api/care-groups/:id/members
GET /api/care-groups/:id/members
DELETE /api/care-groups/:id/members/:memberId
POST /api/care-groups/:id/invitations
GET /api/care-groups/:id/invitations
DELETE /api/care-groups/:id/invitations/:invitationId
```

### Permission System

The permission system is based on a role-based access control (RBAC) model with additional fine-grained permissions:

1. **Roles:**
   - **Primary Caregiver:** Full access to all health data and administrative control
   - **Secondary Caregiver:** Access to specified health data and can receive alerts
   - **Observer:** Limited view access to specified health data
   - **Recipient:** The person receiving care, with control over data sharing

2. **Permission Types:**
   - **View:** Can see the specific health data
   - **Edit:** Can update the specific health data
   - **Alert:** Can receive notifications about the specific health data
   - **Share:** Can share the specific health data with healthcare providers

3. **Granular Controls:**
   - Permissions can be set for specific health data types
   - Temporary access can be granted for limited periods
   - Emergency override capabilities for critical situations

### Invitation System

1. **Invitation Methods:**
   - Email invitation with secure link
   - SMS invitation with one-time code
   - In-app invitation for existing users
   - QR code for in-person invitation

2. **Security Measures:**
   - Time-limited invitation tokens (24 hours)
   - Validation of email/phone ownership
   - Rate limiting to prevent abuse
   - Clear display of permissions being granted

### Data Flow

```
┌──────────────┐     ┌────────────────┐     ┌─────────────────┐
│ Mobile Client │────▶│ Auth Service   │────▶│ Care Group API  │
└──────────────┘     └────────────────┘     └─────────────────┘
                                                      │
                                                      ▼
┌──────────────┐     ┌────────────────┐     ┌─────────────────┐
│ Notification │◀────│ Permission     │◀────│ Care Group DB   │
│ Service      │     │ Service        │     │                 │
└──────────────┘     └────────────────┘     └─────────────────┘
        │                    │
        ▼                    ▼
┌──────────────┐     ┌────────────────┐
│ Push         │     │ Health Data    │
│ Notifications│     │ Service        │
└──────────────┘     └────────────────┘
```

## Privacy and Security Considerations

1. **Consent Management:**
   - Clear visualization of what data is being shared
   - Explicit consent required for sharing each data type
   - Ability to revoke consent at any time
   - Audit trail of consent changes

2. **Data Protection:**
   - End-to-end encryption for shared health data
   - Data minimization principles applied
   - Strict access controls based on permissions
   - Audit logging for all data access

3. **Regulatory Compliance:**
   - Compliance with Vietnam Decree 13/2022/ND-CP
   - GDPR-inspired data protection measures
   - HIPAA-inspired security controls
   - Clear terms and conditions for data sharing

## Testing Requirements

1. **Functional Testing:**
   - Verify creation of care groups with various configurations
   - Test invitation flow for all invitation methods
   - Validate permission enforcement across different roles
   - Test notification delivery based on settings

2. **Security Testing:**
   - Verify proper consent management
   - Test permission boundaries and access controls
   - Validate encryption of sensitive data
   - Test for potential privacy leaks

3. **Usability Testing:**
   - Test with elderly users to verify ease of use
   - Verify clear understanding of permission settings
   - Test invitation acceptance flow with non-technical users
   - Verify accessibility compliance

## Acceptance Criteria

1. Users can successfully create care groups and specify care recipients
2. System correctly handles both recipients with and without their own accounts
3. Permissions are properly enforced based on role and specific settings
4. Invitations can be sent through all supported methods and successfully accepted
5. Users receive notifications according to their role and notification preferences
6. Care group dashboards correctly display shared health information
7. Changes to permissions are immediately enforced across the system
8. All data sharing respects user consent and privacy requirements

## Dependencies

1. **Systems:**
   - User Management Context for user profiles and authentication
   - Health Data Context for health information access
   - Notification Context for alerts and reminders
   - Permission Context for access control

2. **External Services:**
   - Email delivery service for email invitations
   - SMS gateway for text message invitations
   - Push notification services for alerts

## Implementation Phases

### Phase 1: Basic Care Group Functionality

- Implement care group creation and management
- Create basic permission system with roles
- Implement email-based invitation system
- Build care group dashboard with shared information

### Phase 2: Enhanced Permission and Sharing

- Implement granular permission controls
- Add additional invitation methods
- Create detailed audit logging
- Build enhanced visualization of shared data

### Phase 3: Advanced Features

- Implement emergency protocols and overrides
- Add temporary access capabilities
- Create analytics for care group activity
- Build care task assignment and tracking

## Open Questions / Decisions

1. Should we implement a verification process for primary caregivers to prevent abuse?
2. How should we handle care transfer if the primary caregiver becomes unavailable?
3. What level of data anonymization should be applied for observers?
4. Should we implement a "care circle" concept where one person can be in multiple overlapping care groups?

## Related Documents

- [Care Group Context](../planning_and_todolist_ddd.md#5-care-group-context)
- [Family Care Coordination Features](../features_list.md#family-care-coordination-fcc)
- [Feature FCC-002: Caregiver Invitation](./feature_FCC-002.md)
