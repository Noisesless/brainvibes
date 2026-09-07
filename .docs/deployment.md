# Brainvibes — Deployment Guide

## Overview

Panduan deployment untuk proyek yang dibuat dengan Brainvibes workflow. Mencakup konfigurasi per platform, checklist pre-deploy, dan environment mapping.

## Deployment Targets

| Target | Tipe | Default Port | Stack Support |
|---|---|---|---|
| Local XAMPP Apache | Development | 8080 | PHP Native, Laravel |
| Vite Dev Server | Development | 5173 | React, Vue, Astro |
| Next.js Dev Server | Development | 3100 | Next.js |
| cPanel Shared Hosting | Production | 443 | PHP Native, Laravel |
| Vercel | Production | 443 | Next.js, Vite |
| VPS Nginx | Production | 443 | Semua stack |
| Netlify | Production | 443 | Static, Vite, Next.js |

## Environment Mapping

| Variable | Development | Production | Notes |
|---|---|---|---|
| `APP_ENV` | `development` | `production` | Wajib berbeda |
| `APP_DEBUG` | `true` | `false` | FORBIDDEN debug di production |
| `DB_HOST` | `localhost` | `[host_prod]` | Sesuai hosting |
| `DB_NAME` | `[slug]_dev` | `[slug]_prod` | Pisahkan database |
| `APP_URL` | `http://localhost:[port]` | `https://[domain]` | HTTPS wajib di production |

## Pre-Deploy Checklist

### 🔴 Critical (Harus sebelum deploy)
- [ ] `.env.example` ada dan lengkap (tanpa secret values)
- [ ] `.env` tidak masuk Git (cek `.gitignore`)
- [ ] `.gitattributes` ada dan memastikan normalisasi line-endings (LF untuk Unix, CRLF untuk Windows)
- [ ] `APP_DEBUG = false` di production
- [ ] API keys/secrets tidak hardcode di source code
- [ ] Database migration sudah dijalankan
- [ ] HTTPS aktif (SSL certificate)

### 🟡 Important (Sangat disarankan)
- [ ] Error logging & exception handling (SP-019, bukan stack trace ke browser)
- [ ] Rate limiting aktif untuk auth endpoints (SP-014/015)
- [ ] CSRF protection aktif (SP-010)
- [ ] File upload validation aktif (type + size, SP-003)
- [ ] SSRF prevention & IDOR ownership validation (SP-020, SP-021)
- [ ] Open Redirect validation (SP-022)
- [ ] Dependency audit clean (`npm audit` / `composer audit`)
- [ ] Compliance Score minimal GOOD (≥7/10) via saklar `cek komponen`
- [ ] Build production berhasil tanpa error
- [ ] Favicon dan meta tags lengkap
- [ ] Security headers terpasang (6 header wajib: CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy — rujuk gemini-execution.md §3C L6)

### 🟢 Nice-to-have
- [ ] Gzip/Brotli compression aktif
- [ ] Cache headers dikonfigurasi
- [ ] CDN untuk assets statis
- [ ] Monitoring/uptime check aktif
- [ ] Backup database terjadwal

## Deploy Scripts (Copy-Paste Ready)

> ⚠️ Ganti placeholder `[SLUG]`, `[DOMAIN]`, `[PORT]`, `[DB_NAME]`, `[DB_USER]`, `[DB_PASS]` dengan nilai proyek aktual.
> AI WAJIB membaca section ini sebelum memberikan instruksi deploy — FORBIDDEN mengarang command sendiri.

---

### VPS Nginx — First Deploy (dari nol)

```bash
# 1. SSH ke server
ssh root@[SERVER_IP]

# 2. Install prerequisites (Ubuntu/Debian)
sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx certbot python3-certbot-nginx git curl

# 3. Install Node.js (via nvm — recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

# 4. Install PM2 (process manager)
npm install -g pm2

# 5. Clone repo
cd /var/www
git clone [REPO_URL] [SLUG]
cd [SLUG]

# 6. Install dependencies & build
npm install --production
npm run build

# 7. Setup environment
cp .env.example .env
nano .env
# → Set APP_ENV=production, APP_DEBUG=false, DB credentials, APP_URL=https://[DOMAIN]

# 8. Setup database (jika MySQL)
sudo mysql -u root -p
# → CREATE DATABASE [DB_NAME]; CREATE USER '[DB_USER]'@'localhost' IDENTIFIED BY '[DB_PASS]'; GRANT ALL ON [DB_NAME].* TO '[DB_USER]'@'localhost'; FLUSH PRIVILEGES; EXIT;

# 9. Run migrations (jika Laravel/Next.js dengan Prisma)
# Laravel:  php artisan migrate --force
# Prisma:   npx prisma migrate deploy

# 10. Configure Nginx
sudo nano /etc/nginx/sites-available/[SLUG]
```

```nginx
# === Nginx config: /etc/nginx/sites-available/[SLUG] ===
server {
    listen 80;
    server_name [DOMAIN] www.[DOMAIN];

    # === Security Headers (REQUIRED — rujuk gemini-execution.md §3C L6) ===
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()" always;
    # Note: Content-Security-Policy & Strict-Transport-Security dikonfigurasi setelah SSL (Certbot)

    # Next.js / Node.js (reverse proxy)
    location / {
        proxy_pass http://127.0.0.1:[PORT];
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Static files (Vite/Astro — jika static hosting)
    # root /var/www/[SLUG]/dist;
    # index index.html;
    # location / { try_files $uri $uri/ /index.html; }
}
```

```bash
# 11. Enable site & restart Nginx
sudo ln -s /etc/nginx/sites-available/[SLUG] /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# 12. SSL via Certbot
sudo certbot --nginx -d [DOMAIN] -d www.[DOMAIN]

# 12a. Verifikasi & Tambahkan Security Headers tambahan ke Nginx SSL block (server block port 443):
#   add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
#   add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com; connect-src 'self';" always;

# 13. Start app via PM2
cd /var/www/[SLUG]
pm2 start npm --name "[SLUG]" -- start
pm2 save
pm2 startup
```

---

### VPS Nginx — Update Deploy (git pull)

```bash
# SSH ke server
ssh root@[SERVER_IP]

# Navigate ke project
cd /var/www/[SLUG]

# Pull latest code
git pull origin main

# Install new dependencies (jika ada)
npm install --production

# Rebuild
npm run build

# Run new migrations (jika ada)
# Laravel:  php artisan migrate --force
# Prisma:   npx prisma migrate deploy

# Restart app
pm2 restart [SLUG]

# Verify
pm2 status
curl -I https://[DOMAIN]
```

---

### VPS — Laravel (PHP-FPM + Nginx)

```bash
# SSH ke server
ssh root@[SERVER_IP]
cd /var/www/[SLUG]

# Pull & update
git pull origin main
composer install --no-dev --optimize-autoloader

# Laravel optimization
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force

# Restart PHP-FPM
sudo systemctl restart php8.3-fpm
# (ganti 8.3 dengan versi PHP yang terinstall)
```

---

### XAMPP → cPanel (Shared Hosting)

```bash
# === Di mesin lokal ===

# 1. Build production (jika ada build step)
npm run build
# atau: composer install --no-dev --optimize-autoloader

# 2. Zip file untuk upload
# Zip isi folder: dist/ atau public/ + backend files
# JANGAN include: node_modules/, .git/, .env

# === Di cPanel ===
# 3. File Manager → public_html/[SLUG]/ → Upload zip → Extract
# 4. phpMyAdmin → Import database SQL
# 5. Buat .env di server (File Manager → New File)
# 6. Set document root:
#    cPanel → Domains → [DOMAIN] → Document Root → /public_html/[SLUG]/public
# 7. Test: https://[DOMAIN]
```

---

### Vercel (Next.js / Vite)

```bash
# === Di mesin lokal ===

# 1. Install Vercel CLI (opsional — bisa juga via dashboard)
npm install -g vercel

# 2. Login
vercel login

# 3. Deploy
vercel --prod

# === Atau via GitHub (recommended) ===
# 1. Push ke GitHub:     git push origin main
# 2. Vercel Dashboard → Import Git Repository
# 3. Set Environment Variables di Vercel → Settings → Environment Variables
# 4. Auto-deploy setiap push ke main
# 5. Custom domain: Vercel → Settings → Domains → Add [DOMAIN]
#    → Update DNS: CNAME → cname.vercel-dns.com
```

---

### Netlify (Static / Vite / Astro)

```bash
# === Via CLI ===
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=dist

# === Via GitHub (recommended) ===
# 1. Push ke GitHub:     git push origin main
# 2. Netlify → New site from Git → Select repo
# 3. Build command: npm run build
# 4. Publish directory: dist
# 5. Custom domain: Netlify → Domain Settings → Add [DOMAIN]
#    → Update DNS sesuai instruksi Netlify
```

---

## Build Commands per Stack

| Stack | Dev | Build | Start (Production) |
|---|---|---|---|
| PHP Native | XAMPP Apache | - | Apache restart |
| Laravel | `php artisan serve` | `composer install --no-dev` | PHP-FPM + Nginx |
| Next.js | `npm run dev` | `npm run build` | `npm start` / PM2 |
| Vite (React/Vue) | `npm run dev` | `npm run build` | Static hosting / Nginx |
| Astro | `npm run dev` | `npm run build` | Static / SSR via PM2 |

## Post-Deploy Verification

```bash
# 1. Smoke test (cek status HTTP)
curl -I https://[DOMAIN]
# → Expect: HTTP/2 200

# 2. SSL check
curl -vI https://[DOMAIN] 2>&1 | grep "SSL certificate"
# → Expect: SSL certificate verify ok

# 3. Response time check
curl -o /dev/null -s -w "Time: %{time_total}s\n" https://[DOMAIN]
# → Target: < 2 detik

# 4. Browser check (manual)
# → Buka https://[DOMAIN]
# → Cek Console: 0 errors
# → Cek Network: semua 200 OK
# → Test login + 1 fitur kritis
```

## Rollback Plan

| Skenario | Command |
|---|---|
| Code bermasalah | `cd /var/www/[SLUG] && git revert HEAD --no-edit && npm run build && pm2 restart [SLUG]` |
| Rollback ke commit spesifik | `git reset --hard [COMMIT_HASH] && npm run build && pm2 restart [SLUG]` |
| Database migration gagal | `php artisan migrate:rollback --step=1` / `npx prisma migrate reset` |
| Downtime darurat | `pm2 stop [SLUG]` → aktifkan maintenance page di Nginx |
| Restore database | `mysql -u [DB_USER] -p [DB_NAME] < backup_[DATE].sql` |

## Brainvibes Global IDE Deployment (Dual-Platform)

Panduan deployment dan sinkronisasi sistem konfigurasi Brainvibes ke folder global AI (`~/.gemini/`):

### 1. Windows (PowerShell)
```powershell
# Jalankan di terminal PowerShell (Run as Admin jika perlu CBM daemon setup)
cd D:\xampp\htdocs\brainvibes
.\sync.ps1
```

### 2. Linux / macOS (Bash)
```bash
# Prasyarat Linux: bash, jq, rsync, codebase-memory-mcp-bin (AUR/npm)
cd /run/media/gbc/8EE4D697E4D680BF/xampp/htdocs/brainvibes
chmod +x sync.sh scripts/*.sh
./sync.sh
```

### 3. Komponen yang Disinkronkan
- **Core Rules:** `gemini.md`, `gemini-execution.md`, `gemini-templates.md`, `prd-template.md`, `design-system.md`, `AGENTS.md`, `user-prefs.md` → `~/.gemini/`
- **Skills System:** 12 folder skill → `~/.gemini/config/skills/`
- **Knowledge Bases:** 3 knowledge folders → `~/.gemini/antigravity-ide/knowledge/`
- **Lifecycle Hooks:** `config/hooks.json` → `~/.gemini/config/hooks.json`
- **MCP Servers:** `mcp_config.json` → merged ke `~/.gemini/settings.json`

## Related Files

- `deployment-checklist` skill: `config/skills/deployment-checklist/`
- `sync.sh` (Linux) & `sync.ps1` (Windows): Root directory
- Environment template: `.env.example`
- Build config: `package.json` / `composer.json`

