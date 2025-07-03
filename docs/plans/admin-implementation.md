# Admin Portal Implementation Plan - Next.js

**Version:** 2.0
**Date:** 2025-07-03

---

## Overview

This document details the admin portal implementation plan for CareCircle AI Health Agent using Next.js. The admin portal provides healthcare administrators, customer support, and system administrators with tools to manage users, monitor system health, and analyze platform usage.

---

## Implementation Status & Next Steps

### Current Status
- ✅ **Project Setup Complete** - Next.js with TypeScript and Tailwind CSS initialized
- ✅ **Basic Structure** - App router and folder structure established  
- ✅ **Foundation Ready** - Ready to begin feature implementation

### Immediate Next Steps (Sprint 1)
1. **Install Required Dependencies** - Add Shadcn/UI components and additional packages
2. **Implement Authentication** - Build login system and session management
3. **Create Layout Components** - Sidebar, header, and dashboard layout
4. **Build Dashboard** - Stats cards and basic analytics views
5. **User Management** - User listing, search, and detail views

### Dependencies to Install First
```bash
# Core UI components
npx shadcn-ui@latest add button input card label alert dialog dropdown-menu badge table chart

# Additional packages
npm install lucide-react recharts date-fns @tanstack/react-table class-variance-authority clsx tailwind-merge
```

---

## Sprint 0: Project Setup & Core Infrastructure ✅ COMPLETED

### Task 0.7: Initialize Next.js Project ✅
- **Status:** COMPLETED - Basic Next.js project with TypeScript and Tailwind CSS has been initialized
- **Next Steps:** Project is ready for feature development

### Task 0.8: Project Structure Setup ✅  
- **Status:** COMPLETED - App router structure has been set up
- **Current Structure:** Basic folder structure is in place and ready for component development

### Task 0.9: Shadcn/UI Setup and Theming ✅
- **Status:** COMPLETED - Component library foundation is ready
- **Next Steps:** Install additional Shadcn/UI components as needed during feature development

---

## Sprint 1: Authentication & Layout

### Task 1.7: Admin Authentication Pages
- **Objective:** Build admin login and authentication flow
- **Status:** Ready for implementation
- **Dependencies to install:**
  ```bash
  npm install lucide-react class-variance-authority clsx tailwind-merge
  npx shadcn-ui@latest add button input card label alert
  ```

#### Login Page (`app/(auth)/login/page.tsx`)
```typescript
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Label } from '@/components/ui/label'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { authService } from '@/services/auth-service'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')
  const router = useRouter()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError('')

    try {
      await authService.login(email, password)
      router.push('/dashboard')
    } catch (err) {
      setError('Invalid credentials. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl font-bold">CareCircle Admin</CardTitle>
          <CardDescription>Sign in to your admin account</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <Alert variant="destructive">
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
            <Button type="submit" className="w-full" disabled={isLoading}>
              {isLoading ? 'Signing in...' : 'Sign In'}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
```

#### Dashboard Layout (`app/(dashboard)/layout.tsx`)
```typescript
import { Sidebar } from '@/components/layout/sidebar'
import { Header } from '@/components/layout/header'

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="h-screen flex">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-50 p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
```

#### Sidebar Component (`components/layout/sidebar.tsx`)
```typescript
'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import {
  LayoutDashboard,
  Users,
  Pill,
  BarChart3,
  Settings,
  Heart,
  Bell,
  Shield
} from 'lucide-react'

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Users', href: '/users', icon: Users },
  { name: 'Medications', href: '/medications', icon: Pill },
  { name: 'Health Data', href: '/health-data', icon: Heart },
  { name: 'Notifications', href: '/notifications', icon: Bell },
  { name: 'Analytics', href: '/analytics', icon: BarChart3 },
  { name: 'Security', href: '/security', icon: Shield },
  { name: 'Settings', href: '/settings', icon: Settings },
]

export function Sidebar() {
  const pathname = usePathname()

  return (
    <div className="w-64 bg-gray-900 text-white">
      <div className="p-6">
        <h1 className="text-xl font-bold">CareCircle Admin</h1>
      </div>
      <nav className="mt-6">
        {navigation.map((item) => {
          const Icon = item.icon
          return (
            <Link
              key={item.name}
              href={item.href}
              className={cn(
                'flex items-center px-6 py-3 text-sm font-medium hover:bg-gray-800',
                pathname === item.href ? 'bg-gray-800 border-r-2 border-blue-500' : ''
              )}
            >
              <Icon className="mr-3 h-5 w-5" />
              {item.name}
            </Link>
          )
        })}
      </nav>
    </div>
  )
}
```

### Task 1.8: Backend Integration and Session Management
- **Objective:** Connect admin portal to backend APIs
- **Status:** Ready for implementation
- **Prerequisites:** Backend authentication endpoints must be available
- **Environment Variables Required:**
  ```env
  NEXT_PUBLIC_API_BASE_URL=http://localhost:3001
  NEXTAUTH_URL=http://localhost:3000
  NEXTAUTH_SECRET=your-secret-key
  ```

#### API Service (`lib/api.ts`)
```typescript
class ApiService {
  private baseURL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001'
  private token: string | null = null

  constructor() {
    if (typeof window !== 'undefined') {
      this.token = localStorage.getItem('admin_token')
    }
  }

  setToken(token: string) {
    this.token = token
    if (typeof window !== 'undefined') {
      localStorage.setItem('admin_token', token)
    }
  }

  removeToken() {
    this.token = null
    if (typeof window !== 'undefined') {
      localStorage.removeItem('admin_token')
    }
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      ...options.headers,
    }

    if (this.token) {
      headers.Authorization = `Bearer ${this.token}`
    }

    const response = await fetch(url, {
      ...options,
      headers,
    })

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`)
    }

    return response.json()
  }

  async get<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint)
  }

  async post<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined,
    })
  }

  async put<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      body: data ? JSON.stringify(data) : undefined,
    })
  }

  async patch<T>(endpoint: string, data?: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PATCH',
      body: data ? JSON.stringify(data) : undefined,
    })
  }

  async delete<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'DELETE',
    })
  }
}

export const apiService = new ApiService()
```

#### Auth Service (`services/auth-service.ts`)
```typescript
import { apiService } from '@/lib/api'

interface LoginResponse {
  access_token: string
  user: {
    id: string
    email: string
    role: string
    firstName: string
    lastName: string
  }
}

class AuthService {
  async login(email: string, password: string): Promise<LoginResponse> {
    const response = await apiService.post<LoginResponse>('/auth/admin/login', {
      email,
      password,
    })
    
    apiService.setToken(response.access_token)
    return response
  }

  async logout(): Promise<void> {
    apiService.removeToken()
  }

  async getCurrentUser() {
    return apiService.get('/auth/me')
  }

  isAuthenticated(): boolean {
    return typeof window !== 'undefined' && !!localStorage.getItem('admin_token')
  }
}

export const authService = new AuthService()
```

---

## Sprint 1 Continued: Dashboard and User Management

### Dashboard Implementation
- **Status:** Ready for development
- **Dependencies to install:**
  ```bash
  npx shadcn-ui@latest add chart badge table
  npm install recharts date-fns
  ```

### User Management Implementation  
- **Status:** Ready for development
- **Additional Dependencies:**
  ```bash
  npx shadcn-ui@latest add dialog dropdown-menu
  npm install @tanstack/react-table
  ```

### Dashboard Page (`app/(dashboard)/dashboard/page.tsx`)
```typescript
import { StatsCards } from '@/components/dashboard/stats-cards'
import { UserGrowthChart } from '@/components/dashboard/user-growth-chart'
import { MedicationAdherenceChart } from '@/components/dashboard/medication-adherence-chart'
import { RecentActivity } from '@/components/dashboard/recent-activity'

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-600">
          Welcome to the CareCircle Admin Portal
        </p>
      </div>

      <StatsCards />

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <UserGrowthChart />
        <MedicationAdherenceChart />
      </div>

      <RecentActivity />
    </div>
  )
}
```

### Stats Cards Component (`components/dashboard/stats-cards.tsx`)
```typescript
'use client'

import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Users, Pill, Heart, AlertTriangle } from 'lucide-react'
import { analyticsService } from '@/services/analytics-service'

interface Stats {
  totalUsers: number
  activeUsers: number
  totalMedications: number
  adherenceRate: number
  healthDataPoints: number
  criticalAlerts: number
}

export function StatsCards() {
  const [stats, setStats] = useState<Stats | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await analyticsService.getDashboardStats()
        setStats(data)
      } catch (error) {
        console.error('Failed to fetch stats:', error)
      } finally {
        setIsLoading(false)
      }
    }

    fetchStats()
  }, [])

  if (isLoading) {
    return <div>Loading stats...</div>
  }

  const cards = [
    {
      title: 'Total Users',
      value: stats?.totalUsers.toLocaleString() || '0',
      icon: Users,
      change: '+12% from last month',
      changeType: 'positive' as const,
    },
    {
      title: 'Active Users',
      value: stats?.activeUsers.toLocaleString() || '0',
      icon: Users,
      change: '+8% from last month',
      changeType: 'positive' as const,
    },
    {
      title: 'Medications Tracked',
      value: stats?.totalMedications.toLocaleString() || '0',
      icon: Pill,
      change: '+15% from last month',
      changeType: 'positive' as const,
    },
    {
      title: 'Adherence Rate',
      value: `${stats?.adherenceRate || 0}%`,
      icon: Heart,
      change: '+2% from last month',
      changeType: 'positive' as const,
    },
    {
      title: 'Health Data Points',
      value: stats?.healthDataPoints.toLocaleString() || '0',
      icon: Heart,
      change: '+25% from last month',
      changeType: 'positive' as const,
    },
    {
      title: 'Critical Alerts',
      value: stats?.criticalAlerts.toLocaleString() || '0',
      icon: AlertTriangle,
      change: '-5% from last month',
      changeType: 'negative' as const,
    },
  ]

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {cards.map((card) => {
        const Icon = card.icon
        return (
          <Card key={card.title}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-gray-600">
                {card.title}
              </CardTitle>
              <Icon className="h-4 w-4 text-gray-400" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{card.value}</div>
              <p className={`text-xs ${
                card.changeType === 'positive' ? 'text-green-600' : 'text-red-600'
              }`}>
                {card.change}
              </p>
            </CardContent>
          </Card>
        )
      })}
    </div>
  )
}
```

### User Management Page (`app/(dashboard)/users/page.tsx`)
```typescript
'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'
import { Search, Filter, Download } from 'lucide-react'
import { UserDetailsDialog } from '@/components/users/user-details-dialog'
import { userService } from '@/services/user-service'

interface User {
  id: string
  email: string
  firstName: string
  lastName: string
  isActive: boolean
  emailVerified: boolean
  createdAt: string
  lastLoginAt: string
  medicationCount: number
  adherenceRate: number
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedUser, setSelectedUser] = useState<User | null>(null)
  const [pagination, setPagination] = useState({
    page: 1,
    limit: 10,
    total: 0,
  })

  useEffect(() => {
    fetchUsers()
  }, [pagination.page, searchTerm])

  const fetchUsers = async () => {
    setIsLoading(true)
    try {
      const response = await userService.getUsers({
        page: pagination.page,
        limit: pagination.limit,
        search: searchTerm,
      })
      setUsers(response.users)
      setPagination(prev => ({ ...prev, total: response.total }))
    } catch (error) {
      console.error('Failed to fetch users:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleUserClick = (user: User) => {
    setSelectedUser(user)
  }

  const handleDeactivateUser = async (userId: string) => {
    try {
      await userService.deactivateUser(userId)
      fetchUsers() // Refresh the list
    } catch (error) {
      console.error('Failed to deactivate user:', error)
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">User Management</h1>
          <p className="mt-1 text-sm text-gray-600">
            Manage and monitor user accounts
          </p>
        </div>
        <Button>
          <Download className="mr-2 h-4 w-4" />
          Export Users
        </Button>
      </div>

      <Card>
        <CardHeader>
          <div className="flex space-x-4">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
                <Input
                  placeholder="Search users by email or name..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <Button variant="outline">
              <Filter className="mr-2 h-4 w-4" />
              Filter
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div>Loading users...</div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>User</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Medications</TableHead>
                  <TableHead>Adherence</TableHead>
                  <TableHead>Joined</TableHead>
                  <TableHead>Last Login</TableHead>
                  <TableHead>Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {users.map((user) => (
                  <TableRow key={user.id} className="cursor-pointer hover:bg-gray-50">
                    <TableCell onClick={() => handleUserClick(user)}>
                      <div>
                        <div className="font-medium">
                          {user.firstName} {user.lastName}
                        </div>
                        <div className="text-sm text-gray-500">{user.email}</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex space-x-1">
                        <Badge variant={user.isActive ? 'default' : 'secondary'}>
                          {user.isActive ? 'Active' : 'Inactive'}
                        </Badge>
                        {user.emailVerified && (
                          <Badge variant="outline">Verified</Badge>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>{user.medicationCount}</TableCell>
                    <TableCell>
                      <span className={`font-medium ${
                        user.adherenceRate >= 80 ? 'text-green-600' :
                        user.adherenceRate >= 60 ? 'text-yellow-600' : 'text-red-600'
                      }`}>
                        {user.adherenceRate}%
                      </span>
                    </TableCell>
                    <TableCell>
                      {new Date(user.createdAt).toLocaleDateString()}
                    </TableCell>
                    <TableCell>
                      {user.lastLoginAt ? new Date(user.lastLoginAt).toLocaleDateString() : 'Never'}
                    </TableCell>
                    <TableCell>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={(e) => {
                          e.stopPropagation()
                          handleDeactivateUser(user.id)
                        }}
                      >
                        Deactivate
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {selectedUser && (
        <UserDetailsDialog
          user={selectedUser}
          open={!!selectedUser}
          onClose={() => setSelectedUser(null)}
        />
      )}
    </div>
  )
}
```

---

## Additional Components and Services

### Analytics Service (`services/analytics-service.ts`)
```typescript
import { apiService } from '@/lib/api'

interface DashboardStats {
  totalUsers: number
  activeUsers: number
  totalMedications: number
  adherenceRate: number
  healthDataPoints: number
  criticalAlerts: number
}

interface UserGrowthData {
  date: string
  newUsers: number
  totalUsers: number
}

class AnalyticsService {
  async getDashboardStats(): Promise<DashboardStats> {
    return apiService.get<DashboardStats>('/admin/analytics/dashboard-stats')
  }

  async getUserGrowth(period: string = '30d'): Promise<UserGrowthData[]> {
    return apiService.get<UserGrowthData[]>(`/admin/analytics/user-growth?period=${period}`)
  }

  async getMedicationAdherence(period: string = '30d') {
    return apiService.get(`/admin/analytics/medication-adherence?period=${period}`)
  }

  async getHealthDataTrends(period: string = '30d') {
    return apiService.get(`/admin/analytics/health-data-trends?period=${period}`)
  }
}

export const analyticsService = new AnalyticsService()
```

### User Service (`services/user-service.ts`)
```typescript
import { apiService } from '@/lib/api'

interface GetUsersParams {
  page: number
  limit: number
  search?: string
  status?: 'active' | 'inactive'
  verified?: boolean
}

interface GetUsersResponse {
  users: User[]
  total: number
  page: number
  totalPages: number
}

class UserService {
  async getUsers(params: GetUsersParams): Promise<GetUsersResponse> {
    const queryParams = new URLSearchParams()
    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined) {
        queryParams.append(key, value.toString())
      }
    })

    return apiService.get<GetUsersResponse>(`/admin/users?${queryParams}`)
  }

  async getUserById(id: string) {
    return apiService.get(`/admin/users/${id}`)
  }

  async updateUser(id: string, data: Partial<User>) {
    return apiService.patch(`/admin/users/${id}`, data)
  }

  async deactivateUser(id: string) {
    return apiService.patch(`/admin/users/${id}/deactivate`)
  }

  async getUserMedications(userId: string) {
    return apiService.get(`/admin/users/${userId}/medications`)
  }

  async getUserHealthData(userId: string, period: string = '30d') {
    return apiService.get(`/admin/users/${userId}/health-data?period=${period}`)
  }
}

export const userService = new UserService()
```

---

## Features for Remaining Sprints

### Sprint 2: Core Admin Features
- **Medication Management Page** - View all medications across platform, filter by drug name/user/adherence issues
- **Health Data Analytics** - Platform-wide health trends, data quality monitoring
- **Basic Notification Management** - View notification logs and delivery status

### Sprint 3: Advanced Analytics  
- **Advanced Charts and Dashboards** - User engagement analytics, medication adherence trends
- **Export Functionality** - PDF reports, CSV exports for user data
- **System Health Monitoring** - API performance, database metrics

### Sprint 4: Security & Administration
- **Security Dashboard** - Login attempt monitoring, suspicious activity detection
- **User Role Management** - Admin role assignments, permission controls
- **Audit Logs** - Track all admin actions and data access

### Sprint 5: System Management
- **Feature Flag Management** - Toggle features for A/B testing
- **System Settings** - Configuration management, maintenance mode
- **Integration Settings** - Third-party service configurations

---

## Testing Strategy

### Component Testing
- Unit tests for all components using Jest and React Testing Library
- Snapshot testing for UI consistency
- Accessibility testing with jest-axe

### Integration Testing
- API integration tests
- Authentication flow testing
- Data visualization testing

### End-to-End Testing
- Critical user flows using Playwright
- Cross-browser compatibility testing
- Performance testing for large datasets

---

## Deployment and DevOps

### Production Deployment
- Next.js static export for CDN deployment
- Environment-specific configuration
- SSL certificate setup
- Performance monitoring setup

### CI/CD Pipeline
- Automated testing on pull requests
- Build optimization and bundle analysis
- Automated deployment to staging/production
- Security scanning for dependencies
