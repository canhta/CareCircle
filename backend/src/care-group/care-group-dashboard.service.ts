import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CareRole } from '@prisma/client';

export interface DashboardStats {
  totalMembers: number;
  activeMembers: number;
  recentActivity: number;
  healthDataPoints: number;
  upcomingReminders: number;
}

export interface RecentActivity {
  id: string;
  type: 'member_joined' | 'health_data' | 'check_in' | 'prescription';
  description: string;
  timestamp: Date;
  userId?: string;
  userName?: string;
}

export interface CareGroupDashboard {
  stats: DashboardStats;
  recentActivities: RecentActivity[];
  members: Array<{
    id: string;
    name: string;
    role: CareRole;
    lastActive: Date | null;
    avatar?: string | null;
    healthStatus?: 'good' | 'attention' | 'critical';
  }>;
  alerts: Array<{
    id: string;
    type: 'medication' | 'health' | 'appointment';
    message: string;
    severity: 'low' | 'medium' | 'high';
    timestamp: Date;
    userId: string;
    userName: string;
  }>;
}

@Injectable()
export class CareGroupDashboardService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get dashboard data for a care group
   */
  async getDashboard(
    careGroupId: string,
    userId: string,
  ): Promise<CareGroupDashboard> {
    // Verify user is a member
    const membership = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId,
        },
      },
    });

    if (!membership || !membership.isActive) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    // Get basic stats
    const stats = await this.getDashboardStats(careGroupId, membership);

    // Get recent activities
    const recentActivities = await this.getRecentActivities(
      careGroupId,
      membership,
    );

    // Get member information
    const members = await this.getMembers(careGroupId);

    // Get alerts
    const alerts = this.getAlerts(careGroupId, membership);

    return {
      stats,
      recentActivities,
      members,
      alerts,
    };
  }

  private async getDashboardStats(
    careGroupId: string,
    membership: {
      canViewHealth?: boolean;
      role: CareRole;
    },
  ): Promise<DashboardStats> {
    const [totalMembers, activeMembers, healthDataCount, recentActivities] =
      await Promise.all([
        this.prisma.careGroupMember.count({
          where: { careGroupId },
        }),
        this.prisma.careGroupMember.count({
          where: {
            careGroupId,
            isActive: true,
          },
        }),
        // Health data count (if user can view health data)
        membership.canViewHealth || this.isAdminOrOwner(membership)
          ? this.prisma.healthRecord.count({
              where: {
                user: {
                  careGroupMembers: {
                    some: {
                      careGroupId,
                      isActive: true,
                    },
                  },
                },
                createdAt: {
                  gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
                },
              },
            })
          : 0,
        // Get count of recent activities
        this.getRecentActivitiesCount(careGroupId),
      ]);

    return {
      totalMembers,
      activeMembers,
      recentActivity: recentActivities,
      healthDataPoints: healthDataCount,
      upcomingReminders: 0, // TODO: Implement reminders
    };
  }

  private async getRecentActivities(
    careGroupId: string,
    membership: {
      canViewHealth?: boolean;
      role: CareRole;
    },
  ): Promise<RecentActivity[]> {
    const activities: RecentActivity[] = [];

    // Get recent member joins
    const recentJoins = await this.prisma.careGroupMember.findMany({
      where: {
        careGroupId,
        joinedAt: {
          gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
        },
      },
      include: {
        user: {
          select: {
            firstName: true,
            lastName: true,
          },
        },
      },
      take: 5,
      orderBy: {
        joinedAt: 'desc',
      },
    });

    for (const join of recentJoins) {
      activities.push({
        id: `join_${join.id}`,
        type: 'member_joined',
        description: `${join.user.firstName} ${join.user.lastName} joined the care group`,
        timestamp: join.joinedAt,
        userId: join.userId,
        userName: `${join.user.firstName} ${join.user.lastName}`,
      });
    }

    // Get recent check-ins (if user can view them)
    if (membership.canViewHealth || this.isAdminOrOwner(membership)) {
      const recentCheckIns = await this.prisma.dailyCheckIn.findMany({
        where: {
          user: {
            careGroupMembers: {
              some: {
                careGroupId,
                isActive: true,
              },
            },
          },
          createdAt: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
        include: {
          user: {
            select: {
              firstName: true,
              lastName: true,
            },
          },
        },
        take: 5,
        orderBy: {
          createdAt: 'desc',
        },
      });

      for (const checkIn of recentCheckIns) {
        activities.push({
          id: `checkin_${checkIn.id}`,
          type: 'check_in',
          description: `${checkIn.user.firstName} ${checkIn.user.lastName} completed daily check-in`,
          timestamp: checkIn.createdAt,
          userId: checkIn.userId,
          userName: `${checkIn.user.firstName} ${checkIn.user.lastName}`,
        });
      }
    }

    // Sort by timestamp and return latest
    return activities
      .sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
      .slice(0, 10);
  }

  private async getRecentActivitiesCount(careGroupId: string): Promise<number> {
    // Count recent member joins and check-ins
    const recentJoinsCount = await this.prisma.careGroupMember.count({
      where: {
        careGroupId,
        joinedAt: {
          gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
        },
      },
    });

    const recentCheckInsCount = await this.prisma.dailyCheckIn.count({
      where: {
        user: {
          careGroupMembers: {
            some: {
              careGroupId,
              isActive: true,
            },
          },
        },
        createdAt: {
          gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
        },
      },
    });

    return recentJoinsCount + recentCheckInsCount;
  }

  private async getMembers(careGroupId: string) {
    const members = await this.prisma.careGroupMember.findMany({
      where: {
        careGroupId,
        isActive: true,
      },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            avatar: true,
            lastLoginAt: true,
          },
        },
      },
      orderBy: {
        joinedAt: 'asc',
      },
    });

    return members.map((member) => ({
      id: member.id,
      name: `${member.user.firstName} ${member.user.lastName}`,
      role: member.role,
      lastActive: member.user.lastLoginAt,
      avatar: member.user.avatar,
      healthStatus: 'good' as const, // TODO: Calculate based on recent health data
    }));
  }

  private getAlerts(
    careGroupId: string,
    membership: {
      canReceiveAlerts?: boolean;
      role: CareRole;
    },
  ) {
    const alerts = [];

    // Get medication alerts (if user can receive alerts)
    if (membership.canReceiveAlerts || this.isAdminOrOwner(membership)) {
      // TODO: Implement medication reminder alerts
      // This would check for missed medications, low stock, etc.
    }

    return alerts;
  }

  private isAdminOrOwner(membership: { role: CareRole }): boolean {
    return (
      membership.role === CareRole.OWNER || membership.role === CareRole.ADMIN
    );
  }

  /**
   * Get health summary for dashboard (aggregated data)
   */
  async getHealthSummary(careGroupId: string, userId: string) {
    const membership = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId,
        },
      },
    });

    if (!membership || !membership.isActive) {
      throw new ForbiddenException('User is not a member of this care group');
    }

    if (!membership.canViewHealth && !this.isAdminOrOwner(membership)) {
      throw new ForbiddenException(
        'User does not have permission to view health data',
      );
    }

    // Get aggregated health data for all members
    const healthSummary = await this.prisma.healthRecord.groupBy({
      by: ['dataType'],
      where: {
        user: {
          careGroupMembers: {
            some: {
              careGroupId,
              isActive: true,
            },
          },
        },
        recordedAt: {
          gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // Last 30 days
        },
      },
      _avg: {
        value: true,
      },
      _count: {
        value: true,
      },
    });

    return healthSummary;
  }
}
