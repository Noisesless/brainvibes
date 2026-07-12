# Auth Patterns — Snippet Library

*Pattern autentikasi siap pakai per stack.*

---

### [CS-030] PHP Native Auth Handler (Session + CSRF + Captcha)
Stack: PHP Native
Kompleksitas: Medium
Referensi: vibes-stack-patterns/php-native-patterns.md Pattern 1

> Lihat Knowledge Item `vibes-stack-patterns/artifacts/php-native-patterns.md` Pattern 1 untuk implementasi lengkap (Login Handler + Auth Middleware).

Ringkasan quick-ref:
```php
// Login: session_regenerate_id(true) + password_verify() + CSRF check + captcha case-insensitive
// Guard: requireAuth($role) di awal setiap halaman protected
// Logout: session_destroy() + redirect ke login
```

---

### [CS-031] Next.js App Router Auth (Middleware + Server Action)
Stack: Next.js 14+ App Router
Kompleksitas: Medium
Referensi: vibes-stack-patterns/nextjs-patterns.md Pattern 2 & 7

> Lihat Knowledge Item `vibes-stack-patterns/artifacts/nextjs-patterns.md` Pattern 2 (Middleware) dan Pattern 7 (Server Action) untuk implementasi lengkap.

Ringkasan quick-ref:
```typescript
// Middleware: cek cookie auth_token di setiap request → redirect ke /login jika tidak ada
// Server Action: loginAction(formData) → set httpOnly cookie → return redirect path
// Role guard: cek user_role cookie di middleware untuk /admin/* paths
```

---

### [CS-032] Role-Based Access Control (RBAC) Matrix
Stack: Universal (Concept)
Kompleksitas: Simple

```
Zona Akses (sesuai gemini.md §4B):
┌─────────────────────────────────────────────────┐
│ ZONA 1 (Public)  : Landing, Login, Register     │
│ ZONA 2 (Member)  : Dashboard, Profil, Settings  │
│ ZONA 3 (Admin)   : User Management, CMS, Logs   │
└─────────────────────────────────────────────────┘

Credential Seeder Default:
Admin  : admin@[domain].com / Adm![AppSlug]@[4digit]
Member : member@[domain].com / Mem![AppSlug]@[4digit]
```
