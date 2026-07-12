# Vibes Stack Patterns — Next.js (App Router)

*Pattern kode yang terbukti bekerja di Next.js 14+ App Router dengan Vibes Coding Workflow.*

---

## Pattern 1: Layout Root dengan Metadata + Theme

```typescript
// app/layout.tsx
import type { Metadata, Viewport } from 'next';
import './globals.css';

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3100'),
  title: { default: 'Nama App', template: '%s — Nama App' },
  description: 'Deskripsi app 150-160 karakter dengan keyword utama.',
  openGraph: {
    type: 'website',
    siteName: 'Nama App',
    locale: 'id_ID',
    images: [{ url: '/og-image.webp', width: 1200, height: 630, alt: 'Nama App' }],
  },
  twitter: { card: 'summary_large_image' },
  robots: { index: true, follow: true },
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  viewportFit: 'cover', // REQUIRED untuk safe-area-inset
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="id" data-theme="light" suppressHydrationWarning>
      <head>
        {/* Anti-flash: set theme sebelum render */}
        <script dangerouslySetInnerHTML={{ __html: `
          (function(){
            const t=localStorage.getItem('theme')||'light';
            document.documentElement.setAttribute('data-theme',t);
            const p=localStorage.getItem('app-palette')||'primary';
            document.documentElement.setAttribute('data-palette',p);
          })()
        ` }} />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body>{children}</body>
    </html>
  );
}
```

---

## Pattern 2: Auth Middleware (Route Protection)

```typescript
// middleware.ts — Root level
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const PUBLIC_PATHS = ['/', '/login', '/register', '/forgot-password', '/reset-password'];
const ADMIN_PATHS = ['/admin'];

export function middleware(request: NextRequest) {
  const token = request.cookies.get('auth_token')?.value;
  const userRole = request.cookies.get('user_role')?.value;
  const { pathname } = request.nextUrl;

  // Public routes — bebas akses
  if (PUBLIC_PATHS.some(p => pathname === p || pathname.startsWith('/api/auth'))) {
    return NextResponse.next();
  }

  // Protected routes — ZONA 2
  if (!token) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('redirect', pathname);
    return NextResponse.redirect(loginUrl);
  }

  // Admin routes — ZONA 3
  if (ADMIN_PATHS.some(p => pathname.startsWith(p)) && userRole !== 'admin') {
    return NextResponse.rewrite(new URL('/403', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|assets|api/public).*)'],
};
```

---

## Pattern 3: API Route Handler (Standard Response)

```typescript
// app/api/users/route.ts
import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

// Standard response helper
function apiResponse(data: any, status = 200) {
  return NextResponse.json({ success: true, data }, { status });
}

function apiError(message: string, status = 400) {
  return NextResponse.json({ success: false, error: message }, { status });
}

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '10');
    const skip = (page - 1) * limit;

    const [users, total] = await Promise.all([
      prisma.user.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' } }),
      prisma.user.count(),
    ]);

    return apiResponse({ users, pagination: { page, limit, total, pages: Math.ceil(total / limit) } });
  } catch (error) {
    console.error('[API /users GET]', error);
    return apiError('Gagal memuat data pengguna.', 500);
  }
}

export async function POST(request: Request) {
  try {
    const body = await request.json();

    // Validasi (Zod recommended)
    if (!body.email || !body.name) return apiError('Email dan nama wajib diisi.');

    const user = await prisma.user.create({ data: { ...body } });
    return apiResponse(user, 201);
  } catch (error: any) {
    if (error.code === 'P2002') return apiError('Email sudah terdaftar.', 409);
    return apiError('Gagal membuat pengguna.', 500);
  }
}
```

---

## Pattern 4: Client Component dengan Hydration Safety

```typescript
'use client';

import { useState, useEffect } from 'react';

export default function ThemeToggle() {
  const [mounted, setMounted] = useState(false);
  const [theme, setTheme] = useState('light');

  useEffect(() => {
    setMounted(true);
    setTheme(localStorage.getItem('theme') || 'light');
  }, []);

  const toggle = () => {
    const next = theme === 'light' ? 'dark' : 'light';
    setTheme(next);
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('theme', next);
  };

  // REQUIRED: Skeleton sampai mounted (anti-hydration mismatch)
  if (!mounted) return <div className="skeleton-toggle" aria-hidden="true" />;

  return (
    <button onClick={toggle} aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}>
      {theme === 'dark' ? '☀️' : '🌙'}
    </button>
  );
}
```

---

## Pattern 5: CSS Global Token Setup (@layer + oklch)

```css
/* app/globals.css — sesuai design-system.md §2 */
@layer reset, tokens, base, components, utilities, overrides;

@layer tokens {
  :root {
    --raw-palette-bg:       oklch(15% 0.03 250);
    --raw-palette-surface:  oklch(20% 0.03 250);
    --raw-palette-text:     oklch(92% 0.01 250);
    --raw-palette-accent-1: oklch(55% 0.25 275);
    --raw-palette-accent-2: oklch(68% 0.15 175);

    --vibe-transition: all 0.2s ease-in-out;
    --vibe-error:   oklch(60% 0.22 25);
    --vibe-success: oklch(72% 0.20 152);
    --vibe-warning: oklch(82% 0.18 85);

    --vibe-border:   rgba(128,128,128,0.2);
    --vibe-divider:  rgba(128,128,128,0.12);
    --vibe-input-bg: rgba(128,128,128,0.06);
    --vibe-hover:    rgba(128,128,128,0.08);
    --vibe-overlay:  rgba(0,0,0,0.5);

    --font-sans: 'Inter', 'Segoe UI', system-ui, sans-serif;
  }

  [data-theme="light"] {
    --vibe-background: var(--raw-palette-bg);
    --vibe-surface:    var(--raw-palette-surface);
    --vibe-text-main:  var(--raw-palette-text);
    --vibe-primary:    var(--raw-palette-accent-1);
    --vibe-secondary:  var(--raw-palette-accent-2);
  }

  [data-theme="dark"] {
    --vibe-background: oklch(8% 0.02 250);
    --vibe-surface:    oklch(12% 0.02 250);
    --vibe-text-main:  oklch(90% 0.01 250);
    --vibe-primary:    var(--raw-palette-accent-1);
    --vibe-secondary:  var(--raw-palette-accent-2);
  }
}

@layer base {
  body {
    font-family: var(--font-sans);
    background: var(--vibe-background);
    color: var(--vibe-text-main);
    transition: var(--vibe-transition);
  }
  h1 { font-size: clamp(1.75rem, 4vw, 2.5rem); font-weight: 700; text-wrap: balance; }
  h2 { font-size: 1.5rem; font-weight: 600; text-wrap: balance; }
  p  { text-wrap: pretty; }
}
```

---

## Pattern 6: Prisma Singleton + Schema Base

```typescript
// lib/prisma.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };
export const prisma = globalForPrisma.prisma || new PrismaClient();
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
```

```prisma
// prisma/schema.prisma — Base schema template
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql" // atau "sqlite", "mysql"
  url      = env("DATABASE_URL")
}

model User {
  id         String   @id @default(cuid())
  name       String
  email      String   @unique
  username   String?  @unique
  password   String
  role       String   @default("member") // admin | member
  status     String   @default("active") // active | suspended | banned
  avatarUrls Json?    // Multi-size avatar: { thumb, medium }
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model Setting {
  id    String @id @default(cuid())
  key   String @unique
  value String
}
```

---

## Pattern 7: Server Action (Form Submit tanpa API Route)

```typescript
// app/actions/auth.ts
'use server';

import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';
import bcrypt from 'bcryptjs';

export async function loginAction(formData: FormData) {
  const identity = formData.get('identity') as string;
  const password = formData.get('password') as string;

  const user = await prisma.user.findFirst({
    where: {
      OR: [{ email: identity }, { username: identity }],
      status: 'active',
    },
  });

  if (!user || !bcrypt.compareSync(password, user.password)) {
    return { error: 'Email/username atau password salah.' };
  }

  const cookieStore = await cookies();
  cookieStore.set('auth_token', user.id, { httpOnly: true, secure: process.env.NODE_ENV === 'production', maxAge: 86400 });
  cookieStore.set('user_role', user.role, { httpOnly: true, maxAge: 86400 });

  return { success: true, redirect: user.role === 'admin' ? '/admin' : '/dashboard' };
}
```
