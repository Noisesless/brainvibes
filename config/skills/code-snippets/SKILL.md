---
name: code-snippets
description: |
  Library snippet kode siap pakai untuk komponen UI dan pattern backend umum.
  Aktif saat user minta "buat form", "buat navbar", "buat modal", "buat toast",
  "buat tabel", "buat sidebar", "buat dropdown", "buat card", "buat auth".
  Setiap snippet sudah sesuai design-system.md token dan gemini.md standards.
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis saat AI perlu membuat komponen UI atau pattern backend yang sudah ada di library:

| Skenario | Trigger | Aksi |
|---|---|---|
| Buat komponen UI | "Buat modal", "Tambah toast" | Cari di `data/ui-components.md` |
| Buat form | "Buat login form", "Form kontak" | Cari di `data/form-patterns.md` |
| Buat layout | "Buat navbar", "Buat sidebar" | Cari di `data/layout-patterns.md` |
| Auth pattern | "Buat login", "Session guard" | Cari di `data/auth-patterns.md` |

## Aturan Penggunaan

1. Snippet WAJIB menggunakan CSS variables `var(--vibe-*)` dari design-system.md — FORBIDDEN hardcode warna/spacing.
2. Snippet WAJIB menggunakan class dari @layer components — FORBIDDEN inline styles.
3. Snippet yang ditemukan WAJIB diadaptasi ke stack proyek aktif (PHP/Next.js/etc) — FORBIDDEN copy-paste lintas stack tanpa konversi.
4. Jika snippet tidak ada di library, AI membuat dari nol menggunakan design-system.md tokens, LALU menawarkan untuk menambahkan ke library via `/learn`.

## Struktur Data

Snippet disimpan di `data/` dengan format per-kategori:

```
data/
├── ui-components.md    ← Modal, Toast, Card, Badge, Skeleton, Dropdown
├── form-patterns.md    ← Login form, Search bar, Filter panel, Input groups
├── layout-patterns.md  ← Navbar, Sidebar, Footer, Grid layouts, Bottom nav
└── auth-patterns.md    ← Login handler, Session guard, Role middleware, JWT
```

Setiap snippet punya format:
```
### [CS-NNN] [Nama Snippet]
Stack: [PHP Native / Next.js / Vanilla CSS / Universal]
Kompleksitas: [Simple / Medium / Complex]
Dependensi: [Tidak ada / Sharp / Prisma / dll]

[kode lengkap]

Catatan implementasi: [tips penting]
```
