import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
import GoogleProvider from 'next-auth/providers/google';
import { cookies } from 'next/headers';
import config from '@/lib/config';
import { NextAuthOptions } from 'next-auth';
import type { JWT } from 'next-auth/jwt';
import type { Session } from 'next-auth';

// Extend the types
interface ExtendedJWT extends JWT {
  role?: string;
  userId?: string;
  accessToken?: string;
}

interface ExtendedSession extends Session {
  accessToken?: string;
  user: {
    id?: string;
    name?: string | null;
    email?: string | null;
    image?: string | null;
    role?: string;
  };
}

export const authOptions: NextAuthOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID || '',
      clientSecret: process.env.GOOGLE_CLIENT_SECRET || '',
    }),
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null;
        }

        // Here you would call your backend API to validate credentials
        try {
          const response = await fetch(`${config.api.baseUrl}/auth/login`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              email: credentials.email,
              password: credentials.password,
            }),
            cache: 'no-store',
          });

          if (!response.ok) {
            return null;
          }

          const user = await response.json();

          // Store the access token in an HTTP-only cookie
          if (user.accessToken) {
            // Using synchronous cookies() API
            const cookieStore = cookies();
            cookieStore.set('access_token', user.accessToken, {
              httpOnly: true,
              secure: process.env.NODE_ENV === 'production',
              sameSite: 'strict',
              path: '/',
              maxAge: 60 * 60 * 24, // 1 day
            });
          }

          return {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            image: user.image,
          };
        } catch (error) {
          console.error('Authentication error:', error);
          return null;
        }
      },
    }),
  ],
  session: {
    strategy: 'jwt' as const,
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  pages: {
    signIn: '/auth/login',
    signOut: '/auth/logout',
    error: '/auth/error',
  },
  callbacks: {
    async jwt({ token, user, account }): Promise<ExtendedJWT> {
      // Add user role to JWT token if available
      if (user) {
        token.role = user.role;
        token.userId = user.id;

        if (account && account.provider === 'credentials') {
          // Using synchronous cookies() API
          const cookieStore = cookies();
          const accessToken = cookieStore.get('access_token');
          token.accessToken = accessToken?.value;
        }
      }
      return token as ExtendedJWT;
    },
    async session({ session, token }): Promise<ExtendedSession> {
      if (token) {
        session.user.role = token.role;
        session.user.id = token.userId;
        session.accessToken = token.accessToken;
      }
      return session as ExtendedSession;
    },
  },
};

const handler = NextAuth(authOptions);
export { handler as GET, handler as POST };
