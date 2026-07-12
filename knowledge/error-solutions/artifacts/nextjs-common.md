# Error Solutions — Next.js (App Router)

*Solusi untuk error umum di Next.js 14+ App Router. Tervalidasi dari proyek nyata.*

---

## [ES-NX-001] "You're importing a component that needs `useState`" — Client vs Server

**Gejala:** Error: `You're importing a component that needs useState. It only works in a Client Component`
**Penyebab:** Komponen menggunakan hooks React (useState, useEffect, onClick) tanpa directive `'use client'`.
**Solusi:**
```typescript
// REQUIRED di baris pertama file komponen yang pakai hooks:
'use client';

import { useState } from 'react';
// Sekarang hooks bisa dipakai
```
**Aturan:** Server Components = default. Client Components = hanya jika perlu interaktivitas/hooks.

---

## [ES-NX-002] "Hydration Mismatch" — Server vs Client HTML Berbeda

**Gejala:** `Error: Hydration failed because the initial UI does not match what was rendered on the server`
**Penyebab:** Rendering berbeda antara server dan client (misal: `Date.now()`, `window.innerWidth`, conditional render berdasarkan localStorage).
**Solusi:**
```typescript
'use client';
import { useState, useEffect } from 'react';

export default function ThemeToggle() {
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  
  // REQUIRED: Render placeholder sampai client-side mount
  if (!mounted) return <div className="skeleton-theme-toggle" />;
  
  // Sekarang aman akses localStorage/window
  const theme = localStorage.getItem('theme') || 'light';
  return <button>{theme === 'dark' ? '🌙' : '☀️'}</button>;
}
```

---

## [ES-NX-003] "Module not found: Can't resolve 'fs'" di Client Component

**Gejala:** Build error: `Module not found: Can't resolve 'fs'` atau `'path'`
**Penyebab:** Import Node.js module (`fs`, `path`, `crypto`) di file yang di-bundle untuk browser.
**Solusi:**
- Pindahkan kode yang pakai `fs`/`path` ke **Server Component** atau **Route Handler** (`app/api/`)
- Jika perlu di library: gunakan dynamic import dengan pengecekan `typeof window`

---

## [ES-NX-004] API Route Handler Return Format Salah

**Gejala:** API mengembalikan `undefined` atau error 500.
**Penyebab:** Format return di App Router berbeda dari Pages Router.
**Solusi:**
```typescript
// ❌ SALAH (Pages Router style):
export default function handler(req, res) {
  res.status(200).json({ data: 'hello' });
}

// ✅ BENAR (App Router — app/api/users/route.ts):
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({ data: 'hello' }, { status: 200 });
}

export async function POST(request: Request) {
  const body = await request.json();
  return NextResponse.json({ success: true, data: body });
}
```

---

## [ES-NX-005] Image Optimization — `next/image` Hostname Tidak Terdaftar

**Gejala:** `Error: Invalid src prop on next/image, hostname "images.unsplash.com" is not configured`
**Penyebab:** Domain gambar eksternal belum di-whitelist di `next.config.js`.
**Solusi:**
```javascript
// next.config.js (Next.js 14+):
const nextConfig = {
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: 'images.unsplash.com' },
      { protocol: 'https', hostname: 'picsum.photos' },
      { protocol: 'https', hostname: '*.googleusercontent.com' },
    ],
  },
};
module.exports = nextConfig;
```

---

## [ES-NX-006] Metadata / SEO Tidak Muncul di Social Share Preview

**Gejala:** Share link di WhatsApp/Facebook → preview kosong, tidak ada judul/gambar.
**Penyebab:** Metadata belum di-set atau OG image URL tidak absolute.
**Solusi:**
```typescript
// app/layout.tsx — Global metadata (REQUIRED):
export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_BASE_URL!), // REQUIRED!
  title: { default: 'Nama App', template: '%s — Nama App' },
  openGraph: {
    type: 'website',
    images: [{ url: '/og-image.webp', width: 1200, height: 630 }], // REQUIRED absolute via metadataBase
  },
};
```
**Kunci:** `metadataBase` WAJIB ada agar OG image URL menjadi absolute.

---

## [ES-NX-007] "NEXT_REDIRECT" Error di Server Action / API Route

**Gejala:** `Error: NEXT_REDIRECT` thrown saat `redirect()` di dalam try-catch.
**Penyebab:** `redirect()` di Next.js melempar error internal yang harus di-propagate, bukan di-catch.
**Solusi:**
```typescript
import { redirect } from 'next/navigation';

// ❌ SALAH:
try {
  await saveData();
  redirect('/dashboard'); // Ini throw error yang ter-catch!
} catch (error) {
  console.error(error); // Catch redirect error → gagal redirect
}

// ✅ BENAR — redirect DILUAR try-catch:
let success = false;
try {
  await saveData();
  success = true;
} catch (error) {
  console.error(error);
}
if (success) redirect('/dashboard');
```

---

## [ES-NX-008] Port 3000 Sudah Dipakai — Dev Server Gagal Start

**Gejala:** `Error: listen EADDRINUSE: address already in use :::3000`
**Penyebab:** Proses Node.js lama atau service lain di port 3000.
**Solusi:**
```powershell
# Windows — cari dan kill:
netstat -ano | findstr :3000
taskkill /PID [nomor] /F
# Atau LEBIH BAIK — pakai port lain (gemini.md FORBIDDEN port 3000):
# package.json: "dev": "next dev --port 3100"
```
**Aturan Vibes:** FORBIDDEN port 3000 dan 8000. Default Next.js dev = **3100**.

---

## [ES-NX-009] CSS Module / Tailwind Class Tidak Muncul di Production Build

**Gejala:** Styling benar di dev, tapi hilang setelah `npm run build`.
**Penyebab:** Dynamic class names tidak ter-detect oleh Tailwind purge/JIT.
**Solusi:**
```typescript
// ❌ FORBIDDEN — dynamic class concatenation:
const color = isActive ? 'green' : 'red';
<div className={`bg-${color}-500`}> // Tailwind tidak bisa detect ini!

// ✅ REQUIRED — full class strings:
<div className={isActive ? 'bg-green-500' : 'bg-red-500'}>
```

---

## [ES-NX-010] Prisma Client — "PrismaClient is not initialized"

**Gejala:** Error saat query database: `PrismaClient is unable to be run in the browser`
**Penyebab:** Prisma Client ter-import di Client Component, atau tidak di-singleton di dev mode.
**Solusi:**
```typescript
// lib/prisma.ts — REQUIRED singleton pattern:
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };

export const prisma = globalForPrisma.prisma || new PrismaClient();

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
```
**Aturan:** Prisma Client HANYA boleh dipakai di Server Components, Server Actions, atau API Routes.
