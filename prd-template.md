<!-- ════════════════════════════════════════════════════════════════════════════
     ⚠️  CORE IDENTITY LOCK — AI REQUIRED BACA INI PERTAMA SEBELUM APAPUN  ⚠️
     Single Source of Truth identitas proyek ini.
     Diisi OTOMATIS oleh AI setelah wawancara wizard selesai (sebelum §1).
     FORBIDDEN mengubah nilai 🔒 IMMUTABLE tanpa instruksi eksplisit user:
     [OVERRIDE IDENTITY: parameter=nilai_baru]
     ════════════════════════════════════════════════════════════════════════════ -->

## 🔒 CORE IDENTITY LOCK (IMMUTABLE AFTER PRD APPROVAL)

| Parameter Identitas | Nilai Terkunci | Status |
| :--- | :--- | :--- |
| **Nama Aplikasi** | `[Diisi AI setelah wawancara]` | 🔒 IMMUTABLE |
| **Tipe Aplikasi** | `[Company Profile / Blog-CMS / E-Commerce / Web App / Portal]` | 🔒 IMMUTABLE |
| **Skala & Scope** | `[Kantor / Desa / Kabupaten / Nasional / Publik Luas]` | 🔒 IMMUTABLE |
| **Core Value** | `[Satu kalimat fungsi utama aplikasi]` | 🔒 IMMUTABLE |
| **Mode Proyek** | `[Pembangunan Baru dari Nol / Konversi Stack & Re-Platforming]` | 🔒 IMMUTABLE |
| **Tech Stack** | `[Framework + DB + Styling Engine]` | 🔒 IMMUTABLE |
| **Package Manager** | `[npm / pnpm / yarn / bun]` | 🔒 IMMUTABLE |
| **Palet No.** | `[1–15 atau RANDOM → tulis nomor hasil kocokan]` | 🔒 IMMUTABLE |
| **Nama Kluster Palet** | `[Nama kluster terpilih, misal: Carbon Mint]` | 🔒 IMMUTABLE |
| **Hex: Bg / Surface** | `[#XXXXXX / #XXXXXX]` | 🔒 IMMUTABLE |
| **Hex: Accent1 / Accent2** | `[#XXXXXX / #XXXXXX]` | 🔒 IMMUTABLE |
| **Hex: Text Utama** | `[#XXXXXX]` | 🔒 IMMUTABLE |
| **Mode Tema** | `[Static Light / Static Dark / Dynamic Toggle Switch]` | 🔒 IMMUTABLE |
| **Font Family** | `[Inter (Sans-Serif Modern) / Playfair (Serif Elegan) / Roboto (Clean)]` | 🔒 IMMUTABLE |
| **Geometri Box** | `[Sharp 0px / Rounded 6–8px / Pill Bulat Penuh]` | 🔒 IMMUTABLE |
| **Avatar Shape** | `[Lingkaran Sempurna rounded-full / Kotak Tumpul rounded-md]` | 🔒 IMMUTABLE |
| **Navigasi Model** | `[Top Sticky Navbar / Vertical Sidebar Kiri / Floating Dock Menu]` | 🔒 IMMUTABLE |
| **Hero Layout** | `[Fullscreen Image / Split 50:50 / Widget Grid Dashboard]` | 🔒 IMMUTABLE |
| **Captcha** | `[High-Contrast Active / No Captcha — Native Validation Only]` | 🔒 IMMUTABLE |
| **Fase Aktif** | `[Fase X dari Y — diperbarui AI setiap sesi]` | 🔄 DYNAMIC |
| **Terakhir Diperbarui** | `[Timestamp — diperbarui AI setiap sesi]` | 🔄 DYNAMIC |

> **⚠️ HUKUM IMMUTABILITY:** AI yang membaca file ini DIHARAMKAN mengubah baris bertanda 🔒 IMMUTABLE di atas tanpa instruksi eksplisit user menggunakan kata kunci `[OVERRIDE IDENTITY: parameter=nilai_baru]`. Nilai 🔄 DYNAMIC boleh diperbarui AI setiap sesi tanpa konfirmasi. Pelanggaran = **Fatal Identity Violation**.

---

# PRODUCT REQUIREMENTS DOCUMENT (AI-READABLE)

## 1. PROJECT IDENTITY & CORE PURPOSE
- **Nama Project:** [Nama Aplikasi - Wajib dikunci saat wawancara untuk Title & Database Seeder]
- **Tipe Aplikasi:** [Pilih: Company Profile / Blog-CMS / E-Commerce / Web App / Portal Pemerintahan]
- **Skala & Scope Aplikasi:** [Pilih: Kantor (Internal Instansi) / Desa (Kelurahan) / Kabupaten (Kota) / Nasional / Publik Luas | Sebutkan estimasi jumlah pengguna]
- **Core Value:** [Satu kalimat fungsi utama aplikasi]
- **High-Level Explanation & Business Process:** [AI REQUIRED menjabarkan penjelasan makro fungsional secara mendalam, arsitektur bisnis, aliran proses dari awal hingga akhir, serta target ekosistem yang ingin dicapai aplikasi ini]
- **Target User:** [Target pengguna utama dan karakteristiknya]
- **MVP (Minimum Viable Product) Goal:** [Syarat utama agar aplikasi ini disebut "selesai" di tahap pertama]

## 2. TECH STACK, ARCHITECTURE, & ENVIRONMENT AGNOSTIC POLICY
 
### A. Spesifikasi Inti Ekosistem Teknologi (Core Stack Definitions)
- **Mode Eksekusi Proyek:** [Pilih: Pembangunan Baru dari Nol / Konversi Stack & Re-Platforming (Strangler Fig)]
- **Teknologi Proyek Asal (Khusus Konversi):** [Sebutkan stack lama, misal: PHP Native / MySQL / raw JS, atau ketik N/A jika pembangunan baru]
- **Frontend Framework:** [Pilih: HTML-CSS-JS Native / PHP Native / Next.js 14+ App Router / React Vite / **Astro 5+** (untuk content-heavy: blog, portfolio, docs, landing page statis)]
- **Backend Runtime & API:** [Pilih: PHP Native / Laravel / Node.js Express / Node.js Hono.js / Supabase BaaS / Pure Frontend Emulator]
- **Database Engine & ORM:** [Pilih: MySQL / PostgreSQL via Prisma / SQLite / Global State Simulator (Memory-Based json)]
- **Styling & Design Engine:** [Pilih: Tailwind CSS v4 / Vanilla CSS dengan CSS Modules / Bootstrap 5]
- **IDE Workspace Configuration:** [Pilih: Antigravity-IDE Settings / VSCode Settings / EditorConfig Standard / Tanpa Editor Config]
- **Package Manager Engine:** [Pilih: npm / pnpm / yarn / bun]

### B. Pola Arsitektur, Multi-Environment Deployment & Path-Based Routing Rules
- **Environment Agnostic & Anti-Port Collision Policy (STRICT):** AI REQUIRED merancang sistem routing dan konfigurasi environment yang sepenuhnya adaptif, mandiri, dan terisolasi.
  → **BACA `gemini.md §1`** (Dev Port Blacklist — HARD FORBIDDEN port `8000`/`3000`) dan **`user-prefs.md [DEVELOPMENT]`** (Tabel port dev per framework).
- **Mekanisme Path-Based URL Sub-Folder Lokal:** Sistem routing REQUIRED dirancang agar mengenali dan mendukung penuh arsitektur lingkungan lokal berbasis sub-folder tanpa merusak *asset linkage*. Jika dijalankan di server lokal (seperti Apache XAMPP/Laragon), aplikasi harus dapat diakses dengan mulus via URL **`localhost/namafolderproject/`** (bukan root domain murni `localhost/` atau port `localhost:8000`). Sistem juga REQUIRED adaptif jika nantinya dideploy menggunakan sub-domain murni atau domain utama pada server produksi (Shared Hosting / VPS / Cloud).
- **Strict Relative Asset Paths & Dynamic Base URL (Anti-Break Layout):** Untuk mencegah rusaknya tampilan visual (*broken layout*) and munculnya error 404 pada aset atau endpoint API saat aplikasi dipindahkan antar server (dari lingkungan komputer lokal `localhost/namafolderproject/` ke hosting produksi), AI **MUTLAK** REQUIRED menuliskan seluruh pemanggilan aset (CSS, JS, Gambar, `<img src="...">`, `<a href="...">`, serta logika pengalihan/Redirect API di backend) menggunakan *Relative Path* (`./` atau `../`) atau menggunakan fungsi penangkap *Base URL* dinamis yang mendeteksi skema, host, dan sub-folder aktif secara otomatis dari runtime global request. Dilarang keras menggunakan *Absolute Path* kaku yang mengarah ke akar root domain seperti `/assets/img/` karena akan menyebabkan kegagalan pencarian aset di bawah struktur sub-folder `localhost/namafolderproject/`. *Pengecualian bagi Modern SPA/Framework Bundler (seperti Next.js App Router atau React Vite):* Jika framework mewajibkan absolute paths berbasis build time (seperti output bundler `/assets/`), AI REQUIRED menggunakan konfigurasi parameter Base Path yang disediakan resmi oleh framework (misal: `basePath` di `next.config.js` or `base` di `vite.config.js`) daripada menuliskan relative path (`./` or `../`) secara manual di file view, guna menghindari pecahnya asset linkage pada pemecahan modul (code splitting) di rute dinamis bertingkat.
- **Prinsip Modular & Pemisahan Kekuasaan Kode (Architectural Cleanliness):** Kode REQUIRED terbagi ke dalam 3 layer terisolasi ketat.
  → **BACA `gemini-execution.md §4A`** untuk definisi lengkap Anti-Spaghetti Layer Separation (Presentation / Business Logic / Data Access) dan aturan refaktor modular.

### C. Kebijakan Anti-Bloatware & Tata Kelola Dependensi (Strict Dependency Policy)
AI diwajibkan menjaga folder dependensi (`node_modules` atau folder vendor) tetap ramping, bersih, dan bebas dari pustaka pihak ketiga yang tidak efisien.
1. **Hukum Pustaka Bawaan (Standard Library First):** AI FORBIDDEN menginstal dependensi eksternal jika fungsionalitas yang diminta dapat diselesaikan menggunakan API bawaan (*Native*) dari runtime yang digunakan. 
   - *Contoh Konkrit:* Wajib menggunakan `fetch()` native daripada menginstal `axios`; REQUIRED menggunakan `Intl.DateTimeFormat` atau native `Date` objek daripada menginstal `moment.js` atau `dayjs`; REQUIRED menggunakan manipulasi array native daripada menginstal `lodash`.
2. **Protokol Validasi Sebelum Instalasi (Pre-Installation Validation):** Jika fungsionalitas aplikasi benar-benar membutuhkan pustaka pihak ketiga (misalnya enkripsi, JWT, atau ORM), AI **REQUIRED** memeriksa file manajer paket secara senyap terlebih dahulu. AI FORBIDDEN menulis kode yang memanggil modul sebelum menjalankan perintah instalasi resmi via terminal CLI (`npm install [package]` atau perintah manager paket padanannya).
3. **Pencatatan Transparan:** Setiap dependensi pihak ketiga yang diinstal oleh AI REQUIRED didaftarkan secara tertulis pada bagian log dokumen ini beserta alasan teknis penggunaannya.
4. **Hukum Batas Kapasitas Produksi (Strict Production Size Cap):** Proyek yang telah selesai di-build FORBIDDEN menyisakan struktur folder berkapasitas gigabyte akibat sampah alat konstruksi koding. 
   - Untuk Node.js backend, arsitektur REQUIRED menerapkan metode *Single-File Distribution* (mengompilasi seluruh alur ke satu file JavaScript mandiri) atau pemisahan total kamar *DevDependencies*. 
   - Seluruh pustaka development (compiler, minifier, linter, css-processor) REQUIRED diisolasi penuh dan langsung dimatikan/dihapus fungsinya dari ruang runtime server produksi, sehingga ukuran akhir distribusi aplikasi siap saji tetap ramping, ringan, dan efisien.
5. **Protokol Verifikasi Dokumentasi Library via Context7 (Jika Tersedia):** Sebelum menulis kode yang menggunakan library pihak ketiga, AI REQUIRED melakukan verifikasi dokumentasi versi terbaru melalui Context7 (MCP atau CLI `ctx7`) sesuai urutan eksekusi yang ditetapkan.
   → **BACA `gemini.md §SESSION PROTOCOL`** untuk hukum lengkap: trigger wajib, urutan eksekusi, dan aturan non-override.

### D. Arsitektur Fitur Ekspor File & Kebijakan Beban Kinerja (Export & Lazy Loading Policy)
Jika aplikasi membutuhkan fitur konversi dan pengunduhan berkas (Export Excel, PDF, atau CSV), AI REQUIRED menerapkan standar penanganan performa tingkat tinggi berikut:
1. **Pemuatan Dinamis (Lazy Loading / Dynamic Import):** Mengingat pustaka pemroses file (seperti `jspdf`, `exceljs`, atau `xlsx`) memiliki kapasitas ukuran file (*bundle size*) yang sangat besar, AI **DIHARAMKAN** memasukkan pustaka ini ke dalam paket bundel utama aplikasi. Pustaka ekspor REQUIRED dimuat secara dinamis (*Dynamic Import / Dynamic Require*) hanya pada saat pengguna mengklik tombol "Export", guna menjaga kecepatan muat halaman utama tetap secepat kilat.
2. **Standar Output Berkas Ekspor (Industrial Export Standard):**
   - **Ekspor Spreadsheet (Excel/CSV):** Hasil unduhan REQUIRED terformat secara profesional. Baris *Header* REQUIRED tercetak tebal (*Bold*), memiliki lebar kolom otomatis (*Auto-fit width*) agar teks tidak terpotong, tipe data numerik REQUIRED terformat sebagai angka (bukan teks mentah), dan nama file REQUIRED dinamis menyertakan komponen waktu (Format: `[nama_laporan]_YYYY-MM-DD_HHmmss.xlsx`).
   - **Ekspor Dokumen (PDF):** Tata letak PDF REQUIRED memiliki margin yang konsisten (Minimal 15px), REQUIRED mengimplementasikan penanganan otomatis patahan halaman (*Page Break Management*) agar data tidak terpotong di tengah baris, memiliki penomoran halaman otomatis di area *Footer*, dan REQUIRED menarik data identitas aplikasi (Nama & Logo) secara dinamis dari database.

## 3. DESIGN SYSTEM, TYPOGRAPHY, & UI/UX CONSTRAINTS (VERY STRICT)
*(AI Dilarang keras menggunakan nilai atau gaya di luar aturan konsistensi visual ini. Seluruh token warna REQUIRED diimplementasikan menggunakan variabel CSS root, FORBIDDEN keras melakukan hardcode nilai Hex murni langsung pada komponen UI)*

> **[UUPM AUTO-FILL]** Sebelum wawancara palet dimulai, AI REQUIRED menjalankan secara diam-diam:
> ```bash
> python "$HOME/.gemini/config/skills/ui-ux-pro-max/scripts/search.py" "[deskripsi proyek]" --design-system
> # Windows: python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[deskripsi proyek]" --design-system
> ```
> Hasil rekomendasi palet, gaya, dan font digunakan sebagai **basis draf awal** di §3 ini.
> User tinggal memverifikasi dan menyetujui — bukan mengisi dari nol.
> Jika Python tidak tersedia: gunakan 15 kluster `design-system.md §1` sebagai fallback langsung.

- **Status Pilihan Palet:** [Wajib Terisi: Nomor dari UUPM colors.csv (193 palet industri) / Nomor 1-15 dari design-system.md §1 / TRUE RANDOM]
  → AI REQUIRED memeriksa `colors.csv` UUPM untuk industri terkait TERLEBIH DAHULU sebelum memilih
  → Fallback ke 15 kluster `design-system.md §1` jika tidak ada kecocokan industri spesifik
- **Sumber Palet:** [UUPM Industry-Specific (colors.csv) / design-system.md Cluster / Custom]
- **Nama Kluster Terpilih:** [Nama palet UUPM misal "Healthcare App" / Nama kluster DS misal "Oceanic Jade"]
- **Tema Visual & Gaya UI:** [Nama gaya dari UUPM styles.csv — misal: "Soft UI Evolution", "Glassmorphism", "Minimalism"]
  → AI REQUIRED menggunakan kolom `CSS/Technical Keywords` and `Design System Variables` dari styles.csv
- **Sistem Transisi Tema Global:** [Pilih: Static Palette Mode (Tema Statis) / Dynamic Toggle Switch (Saklar Dinamis)]
- **Color Switcher (Appearance Panel):** [Pilih: Aktif (AI kurasi 3-5 palet alternatif) / Tidak Aktif]

### A. Arsitektur Token Warna Dinamis (Tonal Preservation Theme Matrix)
→ **BACA `design-system.md §2`** untuk arsitektur CSS Token (Light/Dark mode), Hukum Sinkronisasi Token Warna, dan panduan oklch() 2026.

### H. Palette Kurasi Color Switcher (Diisi AI — Hanya Jika Color Switcher: Aktif)
→ **BACA `design-system.md §11`** untuk implementasi teknis Color Switcher System dan aturan kurasi palet.
> **AI REQUIRED mengisi tabel ini setelah wawancara selesai, jika Color Switcher dipilih Aktif.**

| Posisi | Nomor Palet | Nama Kluster | Aksen Utama | Alasan Kurasi AI |
| :--- | :--- | :--- | :--- | :--- |
| Palet Utama (default) | `[dari wawancara]` | `[nama kluster]` | `[oklch accent]` | 🔒 IMMUTABLE — default fallback |
| Alternatif 1 | `[AI pilih]` | `[nama kluster]` | `[oklch accent]` | `[alasan harmonis]` |
| Alternatif 2 | `[AI pilih]` | `[nama kluster]` | `[oklch accent]` | `[alasan harmonis]` |
| Alternatif 3 (opsional) | `[AI pilih]` | `[nama kluster]` | `[oklch accent]` | `[alasan harmonis]` |

### B. Typography Consistency Rule
*AI REQUIRED mengunci hierarki ukuran huruf, jarak antar baris, dan ketebalan yang seragam. Dilarang menggunakan font default browser.*
→ **BACA `design-system.md §3`** untuk Typography Hierarchy dan panduan font loading per stack.

- **Font Family Terpilih (Pilihan Wawancara):**
  - Body font: `[Pilih: Inter / Geist / Outfit / Roboto / Open Sans]`
  - Heading font: `[Pilih: Outfit / Cabinet Grotesk / Satoshi / Geist / Playfair Display]`
  - ⚠️ **WAJIB 2 font berbeda** — heading ≠ body. FORBIDDEN Inter sendirian.
  - ❌ **BANNED sebagai default:** Fraunces, Instrument Serif — LLM tells

- **Font Loading Policy (Production):**
  - **Next.js** → `next/font/google` (zero CDN, zero layout shift)
  - **Laravel / PHP Native / Astro** → `@font-face` self-hosted di `/public/fonts/`
  - **Development only** → Google Fonts CDN link (boleh di localhost, FORBIDDEN di production)
  → Detail implementasi: **BACA `design-system.md §3` bagian "Font Loading — Development vs Production"**

### C. Unified Card, Radius & Shadow System
- **Bentuk Geometri Elemen / Radius Box:** [Pilih: Sharp (0px) / Rounded (6px-8px) / Pill (Bulat penuh)]. Ukuran kelengkungan kotak REQUIRED identik di seluruh aplikasi termasuk frame pada halaman depan, kartu data dashboard, maupun modal pop-up panel admin.
→ **BACA `design-system.md §4`** untuk nilai lengkap Shadow Standard (Soft Elevation) dan Shadow Interaction (Hover Glow) yang wajib dipakai — FORBIDDEN hardcode nilai di komponen.
→ **BACA `styles.csv` UUPM kolom `Design System Variables`** untuk nilai `--border-radius` dan shadow yang sesuai gaya visual terpilih. Gunakan sebagai basis sebelum override dengan design-system.md §4.

### D. Spacing System (8-Point Grid)
*Sistem penjarakan REQUIRED patuh pada kelipatan angka 8. AI FORBIDDEN melakukan hardcode nilai padding atau margin acak (seperti 13px, 19px, atau 21px).*
→ **BACA `design-system.md §6`** untuk Spacing System 8-Point Grid (XS: 4px / S: 8px / M: 16px / L: 24px / XL: 32px). FORBIDDEN hardcode nilai acak (13px, 19px, 21px).

### E. Case-Sensitivity & Lowercase Routing Rules
- **Aturan Penamaan Berkas & Direktori (Case-Sensitive Compliant):** Untuk mencegah kegagalan build saat proyek dijalankan di lingkungan server Linux yang case-sensitive, AI **MUTLAK REQUIRED** menggunakan penamaan **huruf kecil (lowercase) murni** untuk semua nama folder, berkas routing, views, dan nama aset (e.g. `/views/admin/login.php` bukan `/Views/Admin/Login.php`).
- **Standardisasi Impor Komponen:** Seluruh penulisan perintah `import` atau `require` di dalam kode REQUIRED cocok secara persis (case-sensitive) dengan nama berkas fisik di disk.

### F. Dummy Content & Rich Media Seeder Policy
- AI REQUIRED menggunakan gambar HD dari sumber internet resmi (Unsplash/Picsum) yang aktif dan teks dummy yang KONTEKSTUAL sesuai tema aplikasi *(FORBIDDEN keras memakai teks malas dan berulang seperti "test1", "lorem ipsum")*. Aplikasi DIHARAMKAN tampil dalam kondisi kosong melompong atau gersang tanpa estetika visual.

### G. Regulasi Mutlak Aset Gambar, Ilustrasi Pemanis, Avatar User, dan Logo Perusahaan (MANDATORY VISUAL POLICY)
- **Hukum Kewajiban Komponen Visual:** Penggunaan gambar, ilustrasi kontekstual sebagai pemanis halaman, komponen foto avatar user, serta logo identitas perusahaan adalah **MUTLAK REQUIRED** ada di setiap proyek yang dibangun. 
- **Implementasi Fisik & Fail-Safe Strategy (Anti-Broken Image & SVG Brand Local):**
  1. *Penyediaan File Cadangan Lokal:* AI REQUIRED menghasilkan aset gambar placeholder ber-resolusi HD yang sesuai dengan tema proyek, lalu menyimpannya secara fisik di dalam folder direktori aset statis bawaan framework (`/public/assets/images/` atau `/assets/img/`) sejak Fase 1 di `todo.md`.
  2. *Skrip Pencegat Error Runtime (`onerror` Guard):* Setiap tag `<img>` dari sumber CDN eksternal REQUIRED dipasangi `onerror` fallback ke file lokal agar tidak memicu broken image silang merah.
     → **BACA `gemini-execution.md §4F`** untuk protokol HTTP request aman + hukum fallback lokal (onerror image guard).
  3. *Aturan Aset Lokal SVG Brand (Non-CDN):* Semua berkas SVG logo, brand, atau ikon utama (termasuk yang bersumber dari thesvg.org) wajib diunduh secara manual dan disimpan secara lokal (misal: `/public/assets/svg/`). Dilarang memuat SVG brand dari CDN luar langsung pada runtime.
     → **BACA `design-system.md §13`** untuk panduan lengkap integrasi SVG lokal dengan oklch() (fill/stroke via CSS variables, fallback hex injection, inline SVG component pattern).

---

## Bab 4. ADVANCED LAYOUTING, ACTIVE NAVIGATION, & UTILITY RULES
*(AI patuh penuh pada tata kelola visual, manajemen z-index, dan siklus state navigasi)*

- **Aturan Link & Keaktifan Halaman (Zero-Dead-End Policy):**
  → **BACA `gemini-execution.md §4A`** untuk hukum lengkap.
- **Pilihan Navigasi Model:** `[Top Sticky Navbar / Vertical Sidebar Kiri / Floating Dock Menu]`
- **Strategi Fallback Halaman Belum Jadi:** `[Under Construction Card dengan estimasi fase / Redirect ke halaman sebelumnya]`

- **Arsitektur Navigasi Dinamis & Manajemen State Otentikasi:**
  → **BACA `gemini-execution.md §4A`** untuk spesifikasi teknis 3 state: Guest → Login button, Logged In → Avatar Dropdown, Admin → tambahan Admin Panel menu.
  - **Sistem Login:** `[Pilih: Tanpa Login / JWT Based / Session Based]`
  - **Avatar Shape (Mengikuti Bab 3):** `[rounded-full / rounded-md]`
  - **Item Dropdown User:** `[Profil Saya, Pengaturan Akun, Logout]`

- **Geometri Layout & Kriteria Komponen Navigasi Makro:**
  - **Gaya Hero Section:** `[Pilih: Fullscreen Background Image min-height 100vh / Split 50:50 Kiri-Teks Kanan-Gambar / Data Widget Dashboard Grid / Tanpa Hero]`
  - **Komponen Gambar Grafik:** `[Pilih: Ya (Menggunakan Chart.js / ApexCharts) / Tidak Perlu Grafik]`
  - **Mobile Navigation Mode:** `[Pilih: Bottom Tab Bar (default) / Floating Header]`
    → **BACA `design-system.md §10`** untuk touch targets dan safe area.
  - **Global Utility Buttons:** 1. *Back to Top Button (Wajib)*, 2. *Dark Mode Toggle*, 3. *Appearance Panel (Color Switcher)*.

- **Blueprint Manifest Halaman Fisik:**
  AI wajib mengelompokkan dan menjabarkan rute fisik halaman ke dalam tabel:
  | Kluster Akses | Nama Halaman | Target Path Berkas Fisik (View) | Controller yang Menangani | Model Database Terkait | Endpoint API / Integrasi Pihak ke-3 | Status Fungsional |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
  | **Kluster Publik (Guest View)** | Landing Page Utama | [Isi Path Fisik] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
  | **Kluster Publik (Guest View)** | Auth Login Center | [Isi Path Fisik] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
  | **Kluster Terproteksi (Member Area)** | Dashboard Utama User | [Isi Path Fisik] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
  | **Kluster Pengelola (Admin Panel)** | Dashboard Analitik | [Isi Path Fisik] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |

- **Parameter Properti Bayangan & Peta Z-Index:**
  → **BACA `design-system.md §5`** untuk Z-Index Map lengkap.

---

## Bab 5. COMPONENT REGISTRY (ANTI-DUPLICATION)
*(AI wajib mencantumkan komponen yang telah dibuat agar modular dan tidak berulang)*

**Komponen Dasar:**
- [ ] `Button`: `[Path file komponen]`
- [ ] `Input/Form Element`: `[Path file komponen]`
- [ ] `Navbar / Sidebar`: `[Path file komponen]`
- [ ] `Toast / Alert Notification`: `[Path file komponen]`
- [ ] `BackToTop Button`: `[Path file komponen]`
- [ ] `Captcha Generator`: `[Path file komponen]`
- [ ] `PasswordVisibilityControl`: `[Path file komponen]`

**Komponen Interaktif / Data / Halaman Khusus:**
- [ ] `Modal / Dialog Box`: `[Path file komponen]`
- [ ] `Dropdown Menu`: `[Path file komponen]`
- [ ] `Skeleton Loader`: `[Path file komponen]`
- [ ] `Avatar / Profile Image`: `[Path file komponen]`
- [ ] `Data Table` (dengan pagination): `[Path file komponen]`
- [ ] `Chart / Grafik`: `[Path file komponen]`
- [ ] `StealthFetchClient`: `[Path file komponen]`
- [ ] `Under Construction Card`: `[Path file komponen]`
- [ ] `Error 403 / 404 Page`: `[Path file komponen]`

---

## Bab 6. DATA LOGIC & ACTIVE FEATURE ECOSYSTEM
*(Aturan aliran data, otentikasi terproteksi, media pipeline, dan skema database)*

- **Arsitektur Aliran Data & Manajemen State:**
  → **BACA `gemini-execution.md §4A`** untuk Layer Separation, ACID, dan Dynamic Identity.
- **Sistem Otentikasi & Kewajiban Pilar Ekosistem Turunan:**
  - **Sistem Login:** `[Pilih: Tanpa Login / JWT Based / Session Based]`
  - Jika "Punya Login", wajib fungsional 100% dengan pilar-pilar: Onboarding/Register/Lupa Reset Password, User Profile Center, App Settings Preferensi, Global App Settings, Manajemen User & Hak Akses (CRUD + Ban + Soft Delete), CMS Media Slider (Carousel organizer).
- **Kebijakan Pengelolaan Media & Berkas (Upload Pipeline Policy):**
  → **BACA `gemini-execution.md §4E`** untuk 5 tahap secure upload. Format nama file: `[app-slug]_[konteks]_[uuid-8char]_[timestamp].webp`.
  - **Tipe Upload yang Dipakai:** `[Avatar Profil User / Logo Aplikasi / Gambar Konten CMS / File Attachment / Tidak Ada]`
  - **Direktori Target Upload:** `[Isi target dir]`
  - **APP_SLUG untuk Naming:** Diambil dari `.env`.
- **Skema Database & Hukum Penyemaian Data (Seeder):**
  - **Draft Schema Area / Global Local State Model:** Tuliskan struktur tabel database, state JSON, atau compatibility matrix.
  - **Password Akun Default (Secure Credential Policy):** Wajib format `Adm![AppSlug]@[4digit]`.
  | Role | Username/Email | Password | Hash Algorithm | Status |
  | :--- | :--- | :--- | :--- | :--- |
  | Super Admin | `admin@[domain-app].com` | `[Adm![AppSlug]@[4digit]]` | bcrypt (cost=12) | ⚠️ WAJIB GANTI |
  | Demo Member | `member@[domain-app].com` | `[Usr![AppSlug]@[4digit]]` | bcrypt (cost=12) | Akun demo |

---

## Bab 7. SECURITY, ROUTE GUARDING, & UX BEHAVIOR
*(Protokol keamanan siber, middleware, dan UX feedback)*

- **Middleware Proteksi Jalur Halaman (Strict Route Guarding):**
  - **Zona 1 (Public Routes):** Landing Page, Login, Register, dll.
  - **Zona 2 (Protected Routes / Member Area):** Redirect ke /login jika auth token tidak valid.
  - **Zona 3 (Admin Routes):** Cek `role == 'Admin'`. Redirect ke Error 403 page jika tidak sah.
- **Keamanan Form Publik & Pertahanan Siber:**
  - **Captcha:** `[Pilih: Aktif / Tidak Aktif]`
  - **Validasi Captcha:** `[Pilih: Case-Sensitive / Case-Insensitive]`
    → BACA `gemini-execution.md §4B` untuk Captcha anti-bot.
  - **Sanitasi Input:** Menggunakan schema validation (Zod / Joi) untuk Anti-SQLi & XSS.
- **Standar Interaksi UI & Respons Feedback (UX Behavior Standard):**
  - **Toast Engine:** Dilarang menggunakan `alert()`. Gunakan Toast (Sukses/Error/Warn) max 3000ms.
  - **Loading State:** Sediakan `Skeleton Loader` or `Spinner`.
  - **Pesan Error:** Ramah pengguna (misal: "Gagal memuat data...").

---

## Bab 8. ENVIRONMENT VARIABLES & CREDENTIAL SECURITY
*(Perlindungan rahasia siber, .gitignore, isolasi debug, dan debug pipeline)*

- **Secrets Management:** Semua kredensial wajib di `.env` dan di-untrack.
- **Peta Berkas `.env` Utama:** Petakan kunci rahasia yang digunakan (tanpa value asli) ke `.env.example`.
- **APP_SLUG (REQUIRED):** Definisikan `APP_SLUG` di `.env` (Format: lowercase-with-dash).
- **Konstitusi `.gitignore` Mutlak:**
  → **BACA `gemini-templates.md §6A`** untuk 5 kategori rahasia dapur, 5-tahap workflow commit wajib.
- **Debug & YOLO Debug Pipeline:**
  → **BACA `gemini-execution.md §4H`** untuk Browser Tool Gate + scratchpad DOM rules, dan **`gemini-templates.md §5`** untuk YOLO Debugging.

---

## Bab 9. DEPLOYMENT TARGET, SEO & PRODUCTION READINESS
*(Deployment, SEO parameters, Core Web Vitals)*

- **Target Hosting:** `[Shared Hosting / VPS / Cloud / Local XAMPP]`
- **Domain Produksi:** `[URL produksi]`
- **HTTPS:** `[Aktif (SSL/TLS) / Belum]`
- **SEO Identity Lock (Per-Proyek):** Site Title, Meta Description, og:image, Schema.org type, robots.txt, sitemap.xml.
  - **Tipe Schema.org Terpilih:** `[Organization / WebApplication / Blog / Store / GovernmentOrganization]`
  - **robots.txt & Sitemap:** Tentukan target disallow (misal: `/admin/`, `/api/`).
  - **Core Web Vitals Target:** LCP ≤ 2.5s (preload hero), CLS ≤ 0.1 (aspect ratio), INP ≤ 200ms (yield heavy JS).

---

## Bab 10. PROJECT FILE STRUCTURE (ASCII TREE MAP)
*(AI wajib memutasi ASCII Tree sesuai arsitektur terpilih)*
- **SKENARIO A (Native HTML/PHP):** layout folder native.
- **SKENARIO B (Modern Bundler Framework - React/Next.js):** layout folder bundler.

---

## Bab 11. TRANSITION BLUEPRINT REGISTRY (KHUSUS KONVERSI STACK)
*(Matriks migrasi database, model, controller, dan view dari stack lama ke baru)*

- **A. Database Schema Conversion Map:**
  | Tabel Legacy | Kolom Legacy | Tipe Data Legacy | Tabel Target Baru | Kolom Target Baru | Tipe Data Baru / ORM Type | Status Porting | Catatan / Blocker |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
- **B. Database Model Registry:**
  | Model Legacy | Nama Berkas Legacy | Relasi Legacy | Model ORM Baru | Path Berkas Baru | Relasi / ORM Syntax Baru | Status Porting | Catatan / Blocker |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
- **C. Backend Controller & API Translation Map:**
  | Controller Legacy | Endpoint Legacy | Logika Fungsional | Controller Target | API Route Target Baru | Status Porting | Catatan / Blocker |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
- **D. Third-Party API Integration Map:**
  | Layanan Pihak Ketiga | Library Legacy | Konfigurasi Legacy | Library Target Baru | Konfigurasi Baru (.env) | Status Porting | Catatan / Blocker |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
- **E. Frontend View & Asset Translation Registry:**
  | Berkas View Legacy | Kluster Akses | Komponen UI Utama | Berkas View Target | Deskripsi Visual Baru | Status Porting | Catatan / Blocker |
  | :--- | :--- | :--- | :--- | :--- | :--- | :--- |