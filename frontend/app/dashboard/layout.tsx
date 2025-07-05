import { Metadata } from 'next';
import Link from 'next/link';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Button } from '@/components/ui/button';

export const metadata: Metadata = {
  title: 'Dashboard - CareCircle',
  description: 'Manage care for your loved ones',
};

interface DashboardLayoutProps {
  children: React.ReactNode;
}

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  return (
    <div className="flex min-h-screen flex-col">
      <header className="sticky top-0 z-40 border-b bg-background">
        <div className="container flex h-16 items-center justify-between py-4">
          <div className="flex items-center gap-2">
            <Link
              href="/dashboard"
              className="font-bold text-xl flex items-center text-care"
            >
              CareCircle
            </Link>
          </div>
          <nav className="hidden md:flex items-center gap-6 text-sm font-medium">
            <Link
              href="/dashboard"
              className="transition-colors hover:text-foreground/80 text-foreground/60"
            >
              Dashboard
            </Link>
            <Link
              href="/dashboard/care-groups"
              className="transition-colors hover:text-foreground/80 text-foreground/60"
            >
              Care Groups
            </Link>
            <Link
              href="/dashboard/daily-check-ins"
              className="transition-colors hover:text-foreground/80 text-foreground/60"
            >
              Check-ins
            </Link>
            <Link
              href="/dashboard/medications"
              className="transition-colors hover:text-foreground/80 text-foreground/60"
            >
              Medications
            </Link>
            <Link
              href="/dashboard/health-records"
              className="transition-colors hover:text-foreground/80 text-foreground/60"
            >
              Health Records
            </Link>
          </nav>
          <div className="flex items-center gap-2">
            <Avatar className="h-8 w-8">
              <AvatarImage src="/avatar-placeholder.png" alt="User" />
              <AvatarFallback>U</AvatarFallback>
            </Avatar>
          </div>
        </div>
      </header>
      <div className="container flex-1 items-start md:grid md:grid-cols-[220px_1fr] md:gap-6 lg:grid-cols-[240px_1fr] lg:gap-10">
        <aside className="fixed top-14 z-30 -ml-2 hidden h-[calc(100vh-3.5rem)] w-full shrink-0 md:sticky md:block">
          <div className="h-full py-6 pl-8 pr-6 lg:py-8">
            <nav className="flex flex-col gap-2">
              <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                Overview
              </div>
              <Link
                href="/dashboard"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Dashboard
              </Link>
              <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mt-6">
                Care Management
              </div>
              <Link
                href="/dashboard/care-groups"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Care Groups
              </Link>
              <Link
                href="/dashboard/daily-check-ins"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Daily Check-ins
              </Link>
              <Link
                href="/dashboard/medications"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Medications
              </Link>
              <Link
                href="/dashboard/health-records"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Health Records
              </Link>
              <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mt-6">
                Settings
              </div>
              <Link
                href="/dashboard/settings"
                className="font-medium hover:bg-accent hover:text-accent-foreground rounded-md p-2 transition-colors"
              >
                Account Settings
              </Link>
              <Button variant="care" className="mt-6">
                <Link href="/dashboard/care-groups/new">Create Care Group</Link>
              </Button>
            </nav>
          </div>
        </aside>
        <main className="flex w-full flex-col overflow-hidden">
          <div className="py-6 lg:py-8">{children}</div>
        </main>
      </div>
    </div>
  );
}
