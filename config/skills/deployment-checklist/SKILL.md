---
name: deployment-checklist
description: |
  Checklist deployment per platform hosting (XAMPP→cPanel, Vercel, VPS Nginx, Netlify).
  Aktif saat user minta "deploy", "hosting", "production", "upload ke server", "go live".
  Mencegah lupa konfigurasi kritis saat migrasi dari development ke production.
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Mulai Dari |
|---|---|---|
| Mau deploy | "Deploy ke hosting", "Go live" | Checklist sesuai platform |
| Setup hosting | "Setup VPS", "Konfigurasi cPanel" | Platform-specific guide |
| Pre-deploy audit | "Cek sebelum deploy", "Production ready?" | Universal checklist |

## Universal Pre-Deploy Checklist (REQUIRED — Semua Platform)

### 1. Environment & Secrets
- [ ] `.env` production sudah diisi dengan credential asli (DB, API keys, SMTP)
- [ ] `.env.example` tersedia sebagai referensi tanpa value sensitif
- [ ] `APP_DEBUG=false` / `NODE_ENV=production` sudah diset
- [ ] `APP_URL` / `NEXT_PUBLIC_BASE_URL` sudah mengarah ke domain production
- [ ] Secret keys (JWT_SECRET, APP_KEY) sudah di-regenerate — FORBIDDEN pakai key development

### 2. Database
- [ ] Migration sudah dijalankan di production DB
- [ ] Seeder default admin sudah berjalan (format password: `Adm![AppSlug]@[4digit]`)
- [ ] Backup database development tersimpan lokal sebagai rollback point
- [ ] Indeks database sudah ada untuk kolom yang sering di-query

### 3. Security
- [ ] HTTPS aktif — redirect HTTP → HTTPS
- [ ] CORS policy production sudah di-restrict (FORBIDDEN `Allow-Origin: *` di production)
- [ ] Rate limiting aktif di API endpoints (rujuk `secure-patterns.md §SP-014/015`)
- [ ] File sensitif (`prd.md`, `handover.md`, `todo.md`, `.env`) TIDAK bisa diakses via URL
- [ ] Upload directory FORBIDDEN eksekusi PHP/JS (`.htaccess` / Nginx `location` block)
- [ ] Security headers terpasang: CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy (rujuk `gemini-execution.md §3C L6`)
- [ ] HSTS max-age minimal 31536000 (1 tahun) dengan includeSubDomains

### 4. SEO (sesuai gemini.md §4L)
- [ ] 20-item Pre-Deploy SEO Checklist sudah PASSED semua
- [ ] `robots.txt` ada di root — path admin/api di-Disallow
- [ ] `sitemap.xml` ada — semua halaman public terdaftar
- [ ] OG Image 1200×630px sudah di-upload

### 5. Performance
- [ ] Build production berhasil tanpa error (`npm run build` / `composer install --no-dev`)
- [ ] Assets CSS/JS sudah minified
- [ ] Gambar sudah dalam format WebP
- [ ] Lazy loading aktif untuk gambar di bawah fold
- [ ] Fonts di-preconnect dan `font-display: swap`

---

## Platform-Specific Checklists

### A. XAMPP → cPanel (Shared Hosting)

```
1. Export database MySQL via phpMyAdmin → file .sql
2. Upload ke cPanel via File Manager atau FTP
3. Buat database baru di cPanel → import .sql
4. Edit .env / config.php — sesuaikan DB_HOST, DB_USER, DB_PASS, DB_NAME
5. Upload .htaccess ke root (jika Laravel/PHP framework)
6. Pastikan PHP version di cPanel sesuai (php.ini selector)
7. Set file permission: folder 755, file 644
8. Test: akses domain → cek halaman utama, login, upload
```

### B. Vercel (Next.js / React)

```
1. Push ke GitHub repository
2. Connect repo di Vercel dashboard
3. Set Environment Variables di Vercel project settings
4. Build command: `npm run build` (otomatis)
5. Pastikan `next.config.js` → `output: 'standalone'` jika perlu
6. Custom domain: tambah di Vercel → update DNS A/CNAME record
7. Vercel otomatis handle HTTPS via Let's Encrypt
8. Test: akses preview URL → cek SSR, API routes, redirects
```

### C. VPS Nginx (Ubuntu/Debian)

```
1. SSH ke server → clone repo / upload via rsync
2. Install dependencies: Node.js (nvm) / PHP (apt) / MySQL/PostgreSQL
3. Setup Nginx virtual host: proxy_pass ke localhost:PORT atau root ke /var/www/
4. SSL: certbot --nginx -d domain.com
5. PM2 (Node.js): pm2 start npm --name "app" -- start
6. Supervisor (PHP): setup queue worker jika ada
7. Firewall: ufw allow 80,443 → deny semua port lain
8. Monitoring: setup pm2 logs / Laravel Log Viewer
```

### D. Netlify (Static Site / Astro)

```
1. Push ke GitHub → connect di Netlify dashboard
2. Build command: `npm run build`
3. Publish directory: `dist/` (Astro) atau `out/` (Next.js static export)
4. Environment Variables di Netlify UI
5. Custom domain + HTTPS otomatis
6. _redirects file untuk SPA routing (jika applicable)
```

## Post-Deploy Verification (REQUIRED)

Setelah deploy, AI REQUIRED minta user melakukan 4 verifikasi:
1. **Akses halaman utama** — load tanpa error
2. **Login test** — gunakan credential seeder default
3. **Upload test** — upload gambar, pastikan tersimpan dan tampil
4. **Mobile test** — buka di HP, pastikan responsive dan bottom nav bekerja
