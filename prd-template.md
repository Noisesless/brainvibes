# PRODUCT REQUIREMENTS DOCUMENT (AI-READABLE)

## 1. PROJECT IDENTITY & CORE PURPOSE
- **Nama Project:** [Nama Aplikasi - Wajib dikunci saat wawancara untuk Title & Database Seeder]
- **Tipe Aplikasi:** [Pilih: Company Profile / Blog-CMS / E-Commerce / Web App / Portal Pemerintahan]
- **Skala & Scope Aplikasi:** [Pilih: Kantor (Internal Instansi) / Desa (Kelurahan) / Kabupaten (Kota) / Nasional / Publik Luas | Sebutkan estimasi jumlah pengguna]
- **Core Value:** [Satu kalimat fungsi utama aplikasi]
- **High-Level Explanation & Business Process:** [AI WAJIB menjabarkan penjelasan makro fungsional secara mendalam, arsitektur bisnis, aliran proses dari awal hingga akhir, serta target ekosistem yang ingin dicapai aplikasi ini]
- **Target User:** [Target pengguna utama dan karakteristiknya]
- **MVP (Minimum Viable Product) Goal:** [Syarat utama agar aplikasi ini disebut "selesai" di tahap pertama]

## 2. TECH STACK, ARCHITECTURE, & ENVIRONMENT AGNOSTIC POLICY

### A. Spesifikasi Inti Ekosistem Teknologi (Core Stack Definitions)
- **Frontend Framework:** [Pilih: HTML-CSS-JS Native / PHP Native / Next.js 14+ App Router / React Vite]
- **Backend Runtime & API:** [Pilih: PHP Native / Laravel / Node.js Express / Node.js Hono.js / Supabase BaaS / Pure Frontend Emulator]
- **Database Engine & ORM:** [Pilih: MySQL / PostgreSQL via Prisma / SQLite / Global State Simulator (Memory-Based json)]
- **Styling & Design Engine:** [Pilih: Tailwind CSS v4 / Vanilla CSS dengan CSS Modules / Bootstrap 5]
- **IDE Workspace Configuration:** [Pilih: Antigravity-IDE Settings / VSCode Settings / EditorConfig Standard / Tanpa Editor Config]

### B. Pola Arsitektur, Multi-Environment Deployment & Path-Based Routing Rules
- **Environment Agnostic & Anti-Port Collision Policy (STRICT):** AI wajib merancang sistem routing dan konfigurasi environment yang sepenuhnya adaptif, mandiri, dan terisolasi. Aplikasi **DILARANG KERAS** menggunakan, mengunci, atau berasumsi menggunakan port statis tertentu (terutama **PORT 8000** karena sudah digunakan oleh aplikasi produksi aktif di lokal user, begitu juga port standar lain seperti 3000, 5000, atau 8080). 
- **Mekanisme Path-Based URL Sub-Folder Lokal:** Sistem routing wajib dirancang agar mengenali dan mendukung penuh arsitektur lingkungan lokal berbasis sub-folder tanpa merusak *asset linkage*. Jika dijalankan di server lokal (seperti Apache XAMPP/Laragon), aplikasi harus dapat diakses dengan mulus via URL **`localhost/namafolderproject/`** (bukan root domain murni `localhost/` atau port `localhost:8000`). Sistem juga wajib adaptif jika nantinya dideploy menggunakan sub-domain murni atau domain utama pada server produksi (Shared Hosting / VPS / Cloud).
- **Strict Relative Asset Paths & Dynamic Base URL (Anti-Break Layout):** Untuk mencegah rusaknya tampilan visual (*broken layout*) dan munculnya error 404 pada aset atau endpoint API saat aplikasi dipindahkan antar server (dari lingkungan komputer lokal `localhost/namafolderproject/` ke hosting produksi), AI **MUTLAK** wajib menuliskan seluruh pemanggilan aset (CSS, JS, Gambar, `<img src="...">`, `<a href="...">`, serta logika pengalihan/Redirect API di backend) menggunakan *Relative Path* (`./` atau `../`) atau menggunakan fungsi penangkap *Base URL* dinamis yang mendeteksi skema, host, dan sub-folder aktif secara otomatis dari runtime global request. Dilarang keras menggunakan *Absolute Path* kaku yang mengarah ke akar root domain seperti `/assets/img/` karena akan menyebabkan kegagalan pencarian aset di bawah struktur sub-folder `localhost/namafolderproject/`. *Pengecualian bagi Modern SPA/Framework Bundler (seperti Next.js App Router atau React Vite):* Jika framework mewajibkan absolute paths berbasis build time (seperti output bundler `/assets/`), AI wajib menggunakan konfigurasi parameter Base Path yang disediakan resmi oleh framework (misal: `basePath` di `next.config.js` or `base` di `vite.config.js`) daripada menuliskan relative path (`./` or `../`) secara manual di file view, guna menghindari pecahnya asset linkage pada pemecahan modul (code splitting) di rute dinamis bertingkat.
- **Prinsip Modular & Pemisahan Kekuasaan Kode (Architectural Cleanliness):** Kode wajib terbagi menjadi layer yang terisolasi secara ketat (*Separation of Concerns*). AI wajib mematuhi **Prinsip K.I.S.S (Keep It Simple, Stupid)** dan **YAGNI (You Aren't Gonna Need It)**. Dilarang membuat abstraksi berlapis yang tidak dibutuhkan oleh fungsionalitas MVP. Pembagian layer mutlak:
  1. *Presentation Layer (UI Components / Views):* Hanya mengurusi render visual dan interaksi user.
  2. *Business Logic Layer (State/Hooks/Controllers):* Tempat mengelola data state dan pengondisian logika bisnis.
  3. *Data Access Layer (API Services/Queries/Models):* Tempat satu-satunya untuk melakukan komunikasi ke database atau eksternal API.

### C. Kebijakan Anti-Bloatware & Tata Kelola Dependensi (Strict Dependency Policy)
AI diwajibkan menjaga folder dependensi (`node_modules` atau folder vendor) tetap ramping, bersih, dan bebas dari pustaka pihak ketiga yang tidak efisien.
1. **Hukum Pustaka Bawaan (Standard Library First):** AI dilarang keras menginstal dependensi eksternal jika fungsionalitas yang diminta dapat diselesaikan menggunakan API bawaan (*Native*) dari runtime yang digunakan. 
   - *Contoh Konkrit:* Wajib menggunakan `fetch()` native daripada menginstal `axios`; wajib menggunakan `Intl.DateTimeFormat` atau native `Date` objek daripada menginstal `moment.js` atau `dayjs`; wajib menggunakan manipulasi array native daripada menginstal `lodash`.
2. **Protokol Validasi Sebelum Instalasi (Pre-Installation Validation):** Jika fungsionalitas aplikasi benar-benar membutuhkan pustaka pihak ketiga (misalnya enkripsi, JWT, atau ORM), AI **WAJIB** memeriksa file manajer paket secara senyap terlebih dahulu. AI dilarang menulis kode yang memanggil modul sebelum menjalankan perintah instalasi resmi via terminal CLI (`npm install [package]` atau perintah manager paket padanannya).
3. **Pencatatan Transparan:** Setiap dependensi pihak ketiga yang diinstal oleh AI wajib didaftarkan secara tertulis pada bagian log dokumen ini beserta alasan teknis penggunaannya.
4. **Hukum Batas Kapasitas Produksi (Strict Production Size Cap):** Proyek yang telah selesai di-build dilarang keras menyisakan struktur folder berkapasitas gigabyte akibat sampah alat konstruksi koding. 
   - Untuk Node.js backend, arsitektur wajib menerapkan metode *Single-File Distribution* (mengompilasi seluruh alur ke satu file JavaScript mandiri) atau pemisahan total kamar *DevDependencies*. 
   - Seluruh pustaka development (compiler, minifier, linter, css-processor) wajib diisolasi penuh dan langsung dimatikan/dihapus fungsinya dari ruang runtime server produksi, sehingga ukuran akhir distribusi aplikasi siap saji tetap ramping, ringan, dan efisien.

### D. Arsitektur Fitur Ekspor File & Kebijakan Beban Kinerja (Export & Lazy Loading Policy)
Jika aplikasi membutuhkan fitur konversi dan pengunduhan berkas (Export Excel, PDF, atau CSV), AI wajib menerapkan standar penanganan performa tingkat tinggi berikut:
1. **Pemuatan Dinamis (Lazy Loading / Dynamic Import):** Mengingat pustaka pemroses file (seperti `jspdf`, `exceljs`, atau `xlsx`) memiliki kapasitas ukuran file (*bundle size*) yang sangat besar, AI **DIHARAMKAN** memasukkan pustaka ini ke dalam paket bundel utama aplikasi. Pustaka ekspor wajib dimuat secara dinamis (*Dynamic Import / Dynamic Require*) hanya pada saat pengguna mengklik tombol "Export", guna menjaga kecepatan muat halaman utama tetap secepat kilat.
2. **Standar Output Berkas Ekspor (Industrial Export Standard):**
   - **Ekspor Spreadsheet (Excel/CSV):** Hasil unduhan wajib terformat secara profesional. Baris *Header* wajib tercetak tebal (*Bold*), memiliki lebar kolom otomatis (*Auto-fit width*) agar teks tidak terpotong, tipe data numerik wajib terformat sebagai angka (bukan teks mentah), dan nama file wajib dinamis menyertakan komponen waktu (Format: `[nama_laporan]_YYYY-MM-DD_HHmmss.xlsx`).
   - **Ekspor Dokumen (PDF):** Tata letak PDF wajib memiliki margin yang konsisten (Minimal 15px), wajib mengimplementasikan penanganan otomatis patahan halaman (*Page Break Management*) agar data tidak terpotong di tengah baris, memiliki penomoran halaman otomatis di area *Footer*, dan wajib menarik data identitas aplikasi (Nama & Logo) secara dinamis dari database.

## 3. DESIGN SYSTEM, TYPOGRAPHY, & UI/UX CONSTRAINTS (VERY STRICT)
*(AI Dilarang keras menggunakan nilai atau gaya di luar aturan konsistensi visual ini. Seluruh token warna wajib diimplementasikan menggunakan variabel CSS root, DILARANG keras melakukan hardcode nilai Hex murni langsung pada komponen UI)*

- **Status Pilihan Palet:** [Wajib Terisi: Nomor 1-15 / TRUE RANDOM SELECTION berdasarkan Bab 3 Gemini.md]
- **Nama Kluster Terpilih:** [Wajib Terisi Nama Kluster Terpilih dari Otak Gemini.md]
- **Tema Visual & Mood / Vibrasi Karakter:** [Otomatis Terisi Menyesuaikan Karakter Palet yang Menang]
- **Sistem Transisi Tema Global:** [Pilih: Static Palette Mode (Tema Statis) / Dynamic Toggle Switch (Saklar Dinamis)]


###A. Arsitektur Token Warna Dinamis (Tonal Preservation Theme Matrix)
 
/* HUKUM MUTLAK ANTI-COLOR WIPING (TREN 2026 CONSTITUTION)
   AI dilarang keras menggunakan warna #FFFFFF murni untuk Light Mode atau
   #000000 / #121212 murni untuk Dark Mode. Kedua mode WAJIB di-generate 
   menggunakan satu rumpun rona dasar (undertone/hue) yang sama dari kluster
   palet terpilih agar karakter asli aplikasi tetap utuh saat tema berganti.
*/

:root {
  /* AMUNISI BASE DNA PALET (DIKUNCI SAAT WAWANCARA) */
  --raw-palette-bg: [Wajib Terisi Hex Bg Palet Terpilih];
  --raw-palette-surface: [Wajib Terisi Hex Surface Palet Terpilih];
  --raw-palette-text: [Wajib Terisi Hex Text Palet Terpilih];
  --raw-palette-accent-1: [Wajib Terisi Hex Accent 1 Palet Terpilih];
  --raw-palette-accent-2: [Wajib Terisi Hex Accent 2 Palet Terpilih];

  /* GLOBAL TRANSITION ENGINE */
  --vibe-transition: all 0.2s ease-in-out;
  
  /* TOKEN FALLBACK KEAMANAN STATUS GLOBAL */
  --vibe-error: #FF3E3E;
  --vibe-success: #00E676;
  --vibe-warning: #FFD600;
}

/* ==========================================================================
   ARSITEKTUR TEMA ADAPTIF (ANTI-COLOR WIPING & PRESERVASI SPEKTRUM)
   ==========================================================================
   Aturan Pemetaan:
   - Light Mode = Selalu menggunakan warna asli bawaan palet (var(--raw-palette-bg)), 
                  bahkan jika palet aslinya bernuansa gelap.
   - Dark Mode  = Di-generate versi malam / Deep Tonal yang diturunkan kecerahannya 
                  secara ekstrem dari rona dasar palet asli.
   ========================================================================== */

/* --- SCENARIO A: LIGHT MODE ACTIVE (PALETTE ORIGINAL DNA) --- 
   [WARNING: DILARANG KERAS meng-hardcode #FFFFFF / #FFF pada --vibe-background.
   Warna background Light Mode wajib mewarisi nilai asli palet secara langsung] */
[data-theme="light"] {
  --vibe-background: var(--raw-palette-bg);        /* Menggunakan Hex asli palet bawaan tren - DILARANG DI-HARDCODE KE PUTIH */
  --vibe-surface: var(--raw-palette-surface);      /* Satu tingkat lebih cerah atau bergeser saturasi lembut */
  --vibe-text-main: var(--raw-palette-text);       /* Diturunkan ke skala gelap (Charcoal/Slate) dengan undertone senada */
  --vibe-text-muted: rgba(0, 0, 0, 0.6);
  --vibe-primary: var(--raw-palette-accent-1);     /* Warna aksen utama */
  --vibe-secondary: var(--raw-palette-accent-2);   /* Warna aksen sekunder */
}

/* --- SCENARIO B: DARK MODE ACTIVE (DEEP TONAL PRESERVATION) --- 
   [WARNING: Wajib di-generate versi Midnight / Deep Tonal yang lebih gelap dari rona palet asli] */
[data-theme="dark"] {
  --vibe-background: [Wajib Di-generate: Versi Midnight / Deep Tonal Tergelap dari rona latar palet asli];
  --vibe-surface: [Wajib Di-generate: Satu tingkat lebih terang dari background gelap di atas];
  --vibe-text-main: [Wajib Di-generate: Versi cerah kontras tinggi / putih susu senada rona palet asli]; 
  --vibe-text-muted: rgba(255, 255, 255, 0.6);
  --vibe-primary: var(--raw-palette-accent-1);     /* Aksen tetap menyala di atas permukaan gelap */
  --vibe-secondary: var(--raw-palette-accent-2);   /* Aksen sekunder */
}

* **Hukum Sinkronisasi Token Warna (Anti-Text Gaib):** AI wajib memastikan bahwa penamaan class utility pada framework terikat mutlak ke variabel di atas. AI dilarang keras menerapkan kombinasi warna font yang memiliki tingkat kontras rendah dengan warna latar belakang komponen (`font putih + card putih + bg putih`). Jika user mengubah saklar tema, seluruh warna halaman wajib berganti secara halus menggunakan efek transisi `transition-colors duration-200`.

### B. Typography Consistency Rule
*AI wajib mengunci hierarki ukuran huruf (font-size), jarak antar baris (line-height), dan ketebalan (font-weight) yang seragam di setiap halaman. Dilarang keras menggunakan font default browser yang acak:*
- **Font Family Terpilih:** [Pilih dari Wawancara: Sans-Serif Modern (Inter / Geist) | Serif Elegan (Playfair Display) | Official Clean (Roboto / Open Sans)]
- **H1 (Judul Utama / Hero Title):** 24px sampai 32px / 2rem, Bold, Line-Height: 1.25
- **H2 (Sub-Judul / Section Title):** 20px / 1.5rem, Semi-Bold, Line-Height: 1.35
- **BodyText (Isi Konten / Form Label):** 16px / 1rem, Regular, Line-Height: 1.5
- **SmallText (Keterangan / Badge / Toast Callout):** 14px / 0.875rem, Light, Line-Height: 1.4

### C. Unified Card, Radius & Shadow System
- **Bentuk Geometri Elemen / Radius Box:** [Pilih: Sharp (0px) / Rounded (6px-8px) / Pill (Bulat penuh)]. Ukuran kelengkungan kotak wajib identik di seluruh aplikasi termasuk frame pada halaman depan, kartu data dashboard, maupun modal pop-up panel admin.
- **Shadow Standard (Soft Elevation):** `box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);`
- **Shadow Interaction (Hover Active Glow):** `box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);` *(Wajib dikombinasikan dengan efek transisi smooth `transition-all duration-200 ease-in-out` dan sedikit transformasi naik `hover:-translate-y-1`)*.

### D. Spacing System (8-Point Grid)
*Sistem penjarakan wajib patuh pada kelipatan angka 8. AI dilarang keras melakukan hardcode nilai padding atau margin acak (seperti 13px, 19px, atau 21px).*
- **Ukuran Spacing Baku:** XS: 4px | S: 8px | M: 16px | L: 24px | XL: 32px

### E. Dummy Content & Rich Media Seeder Policy
- AI WAJIB menggunakan gambar HD dari sumber internet resmi (Unsplash/Picsum) yang aktif dan teks dummy yang KONTEKSTUAL sesuai tema aplikasi *(DILARANG keras memakai teks malas dan berulang seperti "test1", "lorem ipsum")*. Aplikasi DIHARAMKAN tampil dalam kondisi kosong melompong atau gersang tanpa estetika visual.

### F. Regulasi Mutlak Aset Gambar, Ilustrasi Pemanis, Avatar User, dan Logo Perusahaan (MANDATORY VISUAL POLICY)
- **Hukum Kewajiban Komponen Visual:** Penggunaan gambar, ilustrasi kontekstual sebagai pemanis halaman, komponen foto avatar user, serta logo identitas perusahaan adalah **MUTLAK WAJIB** ada di setiap proyek yang dibangun. 
- **Implementasi Fisik & Fail-Safe Strategy (Anti-Broken Image):**
  1. *Penyediaan File Cadangan Lokal:* AI wajib menghasilkan aset gambar placeholder ber-resolusi HD yang sesuai dengan tema proyek, lalu menyimpannya secara fisik di dalam folder direktori aset statis bawaan framework (`/public/assets/images/` atau `/assets/img/`) sejak Fase 1 di `todo.md`.
  2. *Skrip Pencegat Error Runtime (`onerror` Guard):* Setiap baris tag `<img>` yang ditulis di dalam seluruh file view aplikasi **MUTLAK WAJIB** dipasangi fungsi pencegat error runtime. Jika URL gambar eksternal (CDN/Unsplash) gagal dimuat, skrip harus secara otomatis mengalihkan sumber gambar ke file cadangan lokal agar tidak memicu ikon broken image silang merah.
     - *Contoh implementasi skrip pada HTML/PHP Native:* `<img src="https://images.unsplash.com/photo-xxx" onerror="this.onerror=null; this.src='./assets/img/avatar-default.png';" class="rounded-md object-cover" alt="User Avatar">`

## 4. ADVANCED LAYOUTING, ACTIVE NAVIGATION, & UTILITY RULES
*(AI patuh penuh pada tata kelola visual, manajemen z-index, dan siklus state navigasi berikut)*

### A. Aturan Link & Keaktifan Halaman (Zero-Dead-End Policy)
- **Hukum Utama:** Seluruh menu, tombol, sidebar item, atau tautan visual yang dideklarasikan pada sistem navigasi **WAJIB dibuatkan file fisik halatannya secara utuh dan terhubung ke sistem Routing aktif**.
- **Larangan Keras:** AI dilarang keras menggunakan placeholder `href="#"`, `href="javascript:void(0)"`, atau membuat tombol mati tanpa fungsi perpindahan halaman/konten nyata.
- **Kondisi Fallback:** Jika halaman fitur turunan belum diimplementasikan kodenya pada fase berjalan, AI wajib mengarahkan routing ke halaman temporary bertema khusus yang menampilkan komponen "Under Construction Card" dengan pesan estimasi fase penyelesaian yang ramah pengguna.

### B. Arsitektur Navigasi Dinamis & Manajemen State Otentikasi
- Antarmuka navigasi (Navbar/Sidebar) dilarang bersifat statis. AI wajib menerapkan logika percabangan state otentikasi global dengan skenario sebagai berikut:
    1.  **State: GUEST (Pengunjung Anonim / Belum Login)**
        * *Elemen yang Ditampilkan:* Logo Aplikasi, Menu Publik (Home, About, Gallery), dan satu tombol utama bertuliskan `Login` atau `Mulai`.
        * *Elemen yang Disembunyikan:* AI wajib menyembunyikan total semua akses visual ke Admin Panel, Dashboard internal, Menu Pengaturan (Settings), dan tombol Logout.
	2.  **State: LOGGED_IN_USER (Anggota/Member Resmi)**
        * *Elemen yang Ditampilkan:* Menu Publik, Menu Khusus Member. Tombol `Login` pada Guest State wajib bertransformasi secara dinamis menjadi komponen **User Profile Dropdown** berupa **Avatar Gambar/Foto Profil User yang bentuk geometrinya wajib patuh mutlak pada hasil wawancara Bab 3 (apakah rounded-full, rounded-md, atau rounded-none) dengan aspek rasio tetap 1:1**.
        * *Struktur User Dropdown:* Jika komponen visual profil diklik, wajib memunculkan menu dropdown melayang (floating panel) yang berisi link aktif menuju: Halaman `Profil Saya`, Halaman `Pengaturan Akun`, dan Tombol `Logout`.
    3.  **State: ADMIN / SUPER ADMIN (Pengelola Tertinggi)**
        * *Elemen yang Ditampilkan:* Seluruh elemen pada `Logged_In_User` ditambah dengan menu khusus berlabel `Admin Panel` atau `User Management` yang diletakkan pada posisi strategis navigasi utama atau elemen pertama di User Dropdown.

### C. Geometri Layout & Kriteria Komponen Navigasi Makro
- **Gaya Navigasi Utama:** [Pilih: Top Sticky Navbar / Vertical Sidebar Kiri / Floating Dock Menu]
- **Gaya Hero Section:** [Pilih: Fullscreen Background Image min-height 100vh dengan overlay gradien / Split 50:50 Kiri-Teks Kanan-Gambar / Data Widget Dashboard Grid / Tanpa Hero]
- **Komponen Gambar Grafik:** [Pilih: Ya (Menggunakan Chart.js / ApexCharts) / Tidak Perlu Grafik]
- **Global Utility Buttons:** 1. *Back to Top Button (Wajib):* Setiap halaman panjang **WAJIB** dipasangkan komponen tombol melayang (*floating button*) "Back to Top" di pojok kanan bawah yang aktif me-scroll layar ke atas dengan efek smooth.
    2. *Dark Mode Toggle:* [Pilih: Ya (Aktif terpasang tombol switch untuk Dynamic Toggle Switch) / Tidak (Sistem dikunci sebagai Static Palette Mode)].
- **Komponen Footer Layout:** [Pilih: Simple Copyright Text / Multi-Column Links & Social Medias / Tanpa Footer]

> ### BLUEPRINT MANIFEST HALAMAN FISIK (MUTLAK DIKUNCI SAAT WAWANCARA)
> AI DILARANG KERAS hanya mencatat daftar halaman secara global atau kasar. Seluruh file visual wajib dikelompokkan dan dijabarkan secara rinci ke dalam 3 Kluster Akses nyata tanpa boleh ada yang terlewat, dan wajib ditulis eksplisit path fisiknya sesuai framework oleh AI sebelum masuk ke todo.md:
> 
> | Kluster Akses | Nama Halaman | Target Path Berkas Fisik (View) | Controller yang Menangani | Model Database Terkait | Endpoint API / Integrasi Pihak ke-3 | Status Fungsional |
> | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
> | **Kluster Publik (Guest View)** | Landing Page Utama | [Isi Path Fisik Riil, misal: index.php atau /app/page.tsx] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Publik (Guest View)** | Auth Login Center | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Publik (Guest View)** | Register Onboarding | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Publik (Guest View)** | Lupa & Reset Password | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Terproteksi (Member Area)** | Dashboard Utama User | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Terproteksi (Member Area)** | User Profile Center | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Terproteksi (Member Area)** | Workspace Settings | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Pengelola (Admin Panel)** | Dashboard Analitik | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Pengelola (Admin Panel)** | Global App Settings | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Pengelola (Admin Panel)** | User Role CRUD Table | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Pengelola (Admin Panel)** | Form Add New User | [Isi Path Fisik Riil oleh AI] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |
> | **Kluster Pengelola (Admin Panel)** | CMS Media Slider Organizer | [Isi Path Fisik Riil oleh AI jika Carousel aktif] | [Controller] | [Model] | [API Path / Mock] | Belum Dibuat |

### D. Parameter Properti Bayangan & Peta Z-Index (Anti-Tabrakan Elemen)
- **Z-Index Map (Konstitusi Level Kedalaman):**
    * `z-index: 0` -> Base Layer & Konten Utama
    * `z-index: 10` -> Elemen Overlapping Terstruktur (Card mengambang ringan)
    * `z-index: 50` -> Dropdown Menu, Tooltip, & Popover
    * `z-index: 100` -> Sticky Navigation Bar / Fixed Sidebar Panel
    * `z-index: 500` -> Mobile Drawer / Hamburger Menu Overlay
    * `z-index: 999` -> Modal Dialog Box & Fullscreen Dark Overlay Layer

## 5. COMPONENT REGISTRY (ANTI-DUPLICATION)
*(AI WAJIB mendaftarkan setiap komponen UI ke dalam daftar periksa di bawah ini segera setelah file fisiknya dibuat pada disk, guna melacak modularitas dan mencegah penulisan ulang komponen yang sama)*

- [ ] `Button`: `[Path file komponen riil]`
- [ ] `Input/Form Element`: `[Path file komponen riil]`
- [ ] `Navbar / Sidebar`: `[Path file komponen riil]`
- [ ] `Toast / Alert Notification`: `[Path file komponen riil]`
- [ ] `BackToTop Button`: `[Path file komponen riil]`
- [ ] `Captcha Generator`: `[Path file komponen riil]`
- [ ] `PasswordVisibilityControl`: `[Path file komponen riil]`

---

## 6. DATA LOGIC & ACTIVE FEATURE ECOSYSTEM
*(AI wajib mematuhi arsitektur aliran data, ekosistem fitur otentikasi terproteksi, standardisasi pipeline media, dan hukum pembentukan skema database berikut)*

### A. Arsitektur Aliran Data & Manajemen State (Data Flow Engineering)
- **Aliran Data (Data Flow):** Pola mutlak: `Komponen UI (View) -> Custom Hooks / State Dispatcher -> API Client Service -> Backend API Endpoint -> Database`. Dilarang keras melakukan query database langsung dari komponen UI tanpa melalui layer abstraction.
- **Dynamic Application Identity:** Komponen Nama Web dan elemen Gambar Logo **DIHARAMKAN** ditulis secara statis (*hardcode*). Wajib ditarik secara dinamis dari tabel konfigurasi database `settings`, sehingga Admin dapat merubah identitas visual web secara terpusat melalui form pengaturan aplikasi.
- **Kebijakan Isolasi Transaksi & ACID Compliance (Strict Transaction Isolation):** Setiap kali aplikasi mengimplementasikan logika bisnis yang melibatkan kalkulasi nilai sensitif, pengurangan/penambahan data numerik (seperti saldo, poin, stok barang), atau manipulasi data yang tersebar di lebih dari satu tabel database, AI **MUTLAK** wajib membungkus seluruh rangkaian query tersebut ke dalam mekanisme **Database Transaction** resmi dari database engine/ORM yang digunakan. AI dilarang keras menulis query manipulasi multi-tabel secara terpisah tanpa pengaman transaksi. Jika terjadi kegagalan sistem pada salah satu baris eksekusi di tengah jalan, AI wajib memastikan sistem memicu fungsi pembatalan total (*Rollback Mutlak*) secara instan guna menjaga integritas data tertinggi dan mencegah terjadinya cacat selisih hitungan data pada pangkalan data produksi.

### B. Sistem Otentikasi & Kewajiban Pembangunan Pilar Ekosistem Turunan [Opsional - Hanya jika Punya Login]
- **Kebijakan Pilihan Sistem:** [Pilih: Tanpa Login / Punya Login (JWT Based / Session Based)]
- **Hukum Fitur Aktif (MUTLAK):** Jika pilihan bertuliskan "Punya Login", sistem otentikasi tersebut **WAJIB fungsional 100%**. AI dilarang keras membuat form login kosmetik. Sistem wajib mampu menerbitkan token/session, menyimpannya di sisi client secara aman (HttpOnly Cookie / Secure LocalStorage), dan membersihkannya saat Logout.

- **Spesifikasi Arsitektur Gerbang Login:**
  1. *Dual Input Identity Engine:* Kotak input utama form wajib diprogram menerima data string Email ataupun Username pengguna secara fleksibel.
  2. *Password Eye Switcher Tool:* Isian password wajib dibekali tombol manipulasi atribut `type` klien (*seen/unseen*) untuk mempermudah visibilitas sandi.
  3. *Captcha Guard System:* [Pilih: Menggunakan Captcha / Tanpa Captcha]. Jika aktif, background wajib kontras tinggi dengan karakter angka/huruf (*Anti-Blur*), dan pengujian string bersifat: [Pilih: Case-Sensitive / Case-Insensitive].
  4. *Background Layout Overlay:* Komponen gerbang login wajib dipasangkan gambar latar belakang HD (Unsplash/Picsum) yang ditutup lapisan *overlay semi-transparent gradient tint* di bawah objek form utama.

- **Kewajiban Pilar Ekosistem Turunan Autentikasi (Otomatis Aktif Jika Opsi "Punya Login" Dipilih):**
  AI dilarang keras mengabaikan atau menunda pembuatan modul-modul turunan berikut. Sistem wajib otomatis melahirkan file fisik halaman dan logika fungsional untuk pilar-pilar ini:
  1. **Flow Auth & Onboarding Lengkap:** Menyediakan halaman `Register` (Pendaftaran User Baru), `Lupa Password` (Request token), dan `Reset Password` yang fungsional terhubung ke backend.
  2. **Halaman Profil User Aktif (User Profile Center):** Halaman user untuk mengubah data personal (Nama, Email), mengubah password lama ke password baru dengan validasi, serta fitur unggah foto profil (Avatar).
  3. **Manajemen Pengaturan & Preferensi (App Settings Workspace):** Menyediakan komponen *toggle switch* aktif untuk memicu perubahan tema dari warna asli palet ke versi warna malam (Deep Tonal) yang langsung tersimpan di preferensi browser (LocalStorage) atau database (Hanya aktif jika opsi Dynamic Toggle Switch dipilih pada Bab 3).
  4. **Halaman Global App Settings (Admin Control):** Halaman khusus berkredensial Admin untuk mengubah konfigurasi global aplikasi yang dinamis (Mengubah Nama Aplikasi, Logo Web, Hero Background Image, dan teks Hak Cipta pada Footer) langsung ke tabel database `settings`.
     * **Aturan Tambahan Integrasi Sosmed (Dynamic Engagement Guard):** Jika user memilih opsi "DYNAMIC ENGAGEMENT" pada fase wawancara, Form Kontrol Administrator pada halaman ini wajib menyediakan slot input file upload tambahan untuk memperbarui gambar `og:image` global ke database settings. Backend controller wajib mengolah file tersebut menggunakan engine kompresi WebP otomatis dengan potongan geometri 1:1 dari titik tengah (center-focused adjustment) agar visual pratinjau link (Rich Preview) saat dibagikan ke WhatsApp, TikTok, Instagram, Threads, dan Facebook tidak buram, pecah, atau kosong.
   5. **Manajemen User & Hak Akses (User Role Management Dashboard / Super Admin Privilege):** Halaman visual berbentuk tabel bagi Admin/Super Admin untuk memantau seluruh user yang terdaftar, menambah user baru langsung dari panel (*Add New User*), mengubah tingkatan hak akses (*Role Change* dari Member ke Admin atau sebaliknya), serta tombol aksi untuk memblokir akun (*Suspend/Banned User*) dan menghapus user menggunakan metode *Soft Delete*.
  6. **Halaman CMS Media Slider/Banner Organizer (Otomatis Aktif jika Banner Slider/Carousel Dipilih):** Modul visual kontrol admin untuk memanipulasi data slider; mencakup fungsi mengunggah gambar baru (.webp kompresi otomatis), menghapus media lawas, serta memanipulasi urutan susunan sequence penayangan slider pada halaman depan.

### C. Kebijakan Pengelolaan Media & Berkas Berkapasitas Besar (Upload Pipeline Policy)
- **Fungsionalitas Upload Riil:** Seluruh form input file untuk Gambar Logo Aplikasi dan Avatar Profil Pengguna wajib diprogram aktif terhubung ke backend controller (DILARANG KERAS hanya berupa kosmetik tag HTML).
- **Mekanisme Auto-Crop 1:1 Kotak Persegi Sempurna:** Jika berkas gambar yang diunggah oleh pengguna atau admin memiliki rasio aspek acak/tidak beraturan, skrip backend wajib mencegat dan memotong gambar secara otomatis (*auto-crop*) berbasis titik tengah (*center-focused adjustment*) untuk memaksa gambar bertransformasi menjadi geometri Kotak Persegi Sempurna bersudut tipis (`rounded-md` atau `rounded-lg`) dengan aspek rasio `1:1`.
- **Kompresi Otomatis & Standarisasi WebP:** Segera setelah pemotongan 1:1 selesai, gambar wajib dilewatkan ke fungsi *intercept pipeline* di backend untuk dikompresi ukurannya (maksimum lebar 400px untuk avatar) dan dikonversi otomatis menjadi format modern `.webp` sebelum disimpan fisik di folder lokal `/public/assets/images/` untuk menjaga ringannya performa UI.

### D. Skema Database & Hukum Penyemaian Data Awal (Database Schema & Rich Seeder Rules) [Opsional - Hanya jika menggunakan Database/Backend]
- **Struktur Skema Dasar:** AI wajib menuliskan struktur draf tabel secara lengkap di bawah ini, termasuk tipe data (DataType), Primary Key, Foreign Key, relasi antartabel yang presisi, serta penamaan Model ORM yang bersangkutan (e.g. `User`, `Transaction`, `Settings`). *Hukum Khusus Kontinuitas:* AI dilarang keras menggunakan perintah destruktif (seperti fresh seeder/migrate:fresh) saat menganalisis proyek berjalan. AI wajib membatasi manipulasi database hanya pada migrasi inkremental biasa (`migrate --force`) guna mempertahankan data uji coba/testing riil yang telah diinput oleh pengguna di database lokal.
- **Aturan Pembuatan Seeder (MUTLAK):** Pada file script SQL (`schema.sql` / `database.sql` / file migrations), AI **WAJIB** menyertakan perintah `INSERT INTO` atau seeder class untuk data awal.
- **Kewajiban Akun Default & Rich Contextual Dummy Data Policy:** Script database wajib menanamkan minimal satu akun admin default siap pakai dengan username/email: `admin` dan password: `admin123` (atau versi hash-nya), serta menyediakan tabel data user aktif lengkap beserta minimal 3 data dummy pengguna yang kaya, bervariasi, memiliki status berbeda, dan menggunakan konteks nama/data asli (DILARANG malas menulis "test1", "test2"). Aplikasi harus langsung terlihat penuh isi dan *ready to use* saat pertama kali dijalankan di lingkungan lokal.
- **Draft Schema Area / Global Local State Simulation Model (AI Generation Zone):**
  - *[Tuliskan draf struktur tabel database atau struktur penampung state JSON secara detail di sini. Jika menggunakan komponen Slider, wajib sertakan tabel/objek `sliders` (id, image_path, order_position, created_at)].*

## 7. SECURITY, ROUTE GUARDING, & UX BEHAVIOR
*(AI wajib mematuhi protokol keamanan siber tingkat tinggi, proteksi jalur navigasi, dan standar interaksi antarmuka berikut)*

### A. Mekanisme Proteksi Jalur Halaman & Middleware (Strict Route Guarding) [Opsional - Hanya jika Punya Login]
AI wajib mengunci sistem Router/Middleware ke dalam 3 Zona Proteksi berikut secara mutlak:
1. **ZONA 1: PUBLIC ROUTES (Jalur Terbuka):** Dapat diakses oleh siapa saja tanpa session token (Landing Page, About, Artikel, Login, Register).
2. **ZONA 2: PROTECTED ROUTES (Jalur Terproteksi / Member Area):** Jika token otentikasi tidak ditemukan atau tidak valid, sistem **WAJIB memblokir akses secara instan dan mengarahkan paksa (redirect) user kembali ke halaman Login** disertai notifikasi peringatan.
3. **ZONA 3: ADMIN ROUTES (Jalur Eksklusif Super User):** Wajib lolos Zona 2 dan memeriksa klaim parameter `role == 'Admin'`. Jika tidak sesuai, sistem **WAJIB menolak akses secara mutlak dan menampilkan Halaman Error 403 (Unauthorized Access)**.

### B. Keamanan Form Publik & Pertahanan Siber (High-Contrast Captcha & Rate Limiting) [Opsional - Hanya jika menggunakan Database/Backend]
- **Strict Captcha Security & High-Contrast Visibility:** Seluruh formulir yang dapat diakses oleh publik luas tanpa login—khususnya **Form Login dan Kolom Komentar**—**WAJIB** dilengkapi dengan sistem pelindung Captcha fungsional (bukan kosmetik, jika diaktifkan pada bab 6). Angka/huruf Captcha wajib menggunakan warna tegas bersaturasi tinggi di atas latar belakang kontras agar terlihat sangat jelas oleh mata pengguna manusia. **DILARANG KERAS** menggunakan skema warna buram, lapisan abu-abu (*grey layer*), atau hitam-putih (*black & white*) yang menyatu dengan background. Validasi Captcha wajib diverifikasi secara ketat di sisi *backend/API Services*. Wajib menyediakan tombol atau ikon kecil di samping kotak Captcha untuk menghasilkan ulang (*generate new code*).
- **Perlindungan Anti-Bruteforce (Rate Limiting):** Membatasi jumlah request pada endpoint sensitif (terutama `/api/auth/login`). Maksimal 5 kali percobaan login yang gagal dalam rentang waktu 15 menit dari IP yang sama sebelum diblokir sementara dengan status `429 Too Many Requests`.
- **Sanitasi Input & Validasi Data:** Menggunakan library validasi skema yang ketat (seperti Zod / Joi) untuk membersihkan input dari karakter berbahaya (Anti-SQL Injection & Anti-XSS).

### C. Standar Interaksi UI & Respons Feedback (UX Behavior Standard)
- **Manajemen Notifikasi Responsif (Toast Engine):** AI dilarang menggunakan fungsi bawaan browser seperti `alert()`. Semua respons balik wajib dirender menggunakan komponen Toast Notification melayang (Hijau untuk Sukses, Merah untuk Error/Gagal, Kuning untuk Peringatan) dengan durasi maksimal 3000ms.
- **Manajemen Keterlambatan Data (Loading State):** Guna menghindari efek layar berkedip kosong saat fetching state, AI **WAJIB menyediakan dan mernder komponen *Skeleton Loader*** (animasi kotak abu-abu berdenyut) atau *Spinner Component* yang presisi pada layout.
- **Pesan Error yang Humanis:** Jika terjadi kegagalan sistem, AI wajib memperlihatkan komponen visual pesan error yang ramah pengguna di layar (misal: "Gagal memuat data, silakan coba beberapa saat lagi").

## 8. ENVIRONMENT VARIABLES, REPOSITORY SANITATION, & CREDENTIAL SECURITY (STRICT) [Opsional - Hanya jika menggunakan Database/Backend]
*(AI wajib mematuhi protokol perlindungan rahasia, isolasi berkas debug, dan hukum tata kelola repositori Git berikut secara mutlak untuk mencegah kebocoran data)*

### A. Arsitektur Manajemen Variabel Lingkungan & Isolasi Kredensial (Strict Secrets Map)
- **Hukum Utama Anti-Hardcode Kredensial:** Seluruh konfigurasi sensitif—termasuk kredensial database (database username, password, host, port), kunci API pihak ketiga (API Keys), secret key JWT/Session, dan mode environment (development/production)—**DILARANG KERAS ditulis secara langsung (*hardcode*) di dalam file kode sumber aplikasi**.
- **Peta Berkas `.env` Utama:** AI wajib meletakkan seluruh kunci rahasia ke dalam satu file terpusat bernama `.env` di direktori utama (*root*). Di dalam dokumen PRD hasil generate, AI wajib memetakan daftar *keys* yang dibutuhkan secara transparan tanpa menyertakan nilainya (*values* asli).
- **Panduan Replikasi Lingkungan (`.env.example`):** AI wajib menciptakan dan memperbarui berkas `.env.example` di root folder yang berisi daftar kunci kosong atau nilai dummy contoh sebagai panduan replikasi lingkungan bagi pengembang lain, tanpa membocorkan kredensial asli.
- **Dynamic Port & Configuration Fetching:** Kode program wajib dirancang untuk membaca konfigurasi port, host, dan koneksi secara dinamis dari variabel lingkungan ini, sehingga aplikasi siap dilempar ke environment produksi (Shared Hosting / VPS / Cloud Hosting) tanpa perlu mengubah struktur kode internal.

### B. Konstitusi `.gitignore` Mutlak & Tata Kelola Git (Pre-Coding Git Governance)
Sebelum AI menjalankan fungsi pembuatan folder, berkas backend, frontend, atau menulis satu baris kode fungsional pun di detik pertama proyek dimulai, **TUGAS NOMOR SATU yang wajib dieksekusi oleh AI adalah membuat dan mengonfigurasi file `.gitignore` di root folder**. File ini wajib mengunci secara permanen pola berkas berikut agar tidak bocor ke riwayat *commit* Git:
1. *Kredensial Pribadi & Token Rahasia:* `.env`, `.env.local`, `.env.production`, `*.pem`, `*.key`, berkas sertifikat, dan file rahasia lainnya.
2. *Cetak Biru & Metadata Internal AI (Kerahasiaan Arsitektur):* `prd.md`, `todo.md`, `handover.md`.
3. *Dependensi Kapasitas Besar:* `node_modules/`, `vendor/`, `.pnpm-store/`, dan folder manajer paket lainnya.
4. *Berkas Sampah Lokal & Sistem Operasi:* `.DS_Store`, `Thumbs.db`, `.idea/`, `.vscode/`, `*.suo`, `*.ntvs*`.
5. *Log Sistem & Berkas Uji Coba:* `*.log`, `npm-debug.log*`, `yarn-debug.log*`, `yarn-error.log*`.
6. *Isolasi Area Uji Coba:* Folder internal `/.scratchpad/` wajib masuk ke dalam daftar cekkal secara permanen sejak awal.

### C. Kebijakan Isolasi Berkas Uji Coba (Isolated Debugging Zone Rules)
AI diharamkan keras mengotori folder utama proyek (*root*) atau folder fitur aktif dengan berkas-berkas eksperimen acak saat mencoba memecahkan masalah (*debugging/testing*).
1. **Zonasi Khusus Ruang Scratchpad:** Jika AI membutuhkan ruang untuk membuat skrip uji coba koneksi, skrip eksekusi query SQL mentah, file log dump JSON, atau file tes fungsionalitas (seperti `test.js`, `dump.sql`, `debug.json`), AI **HANYA DIIZINKAN** membuatnya di dalam satu folder terisolasi bernama `/.scratchpad/` di root proyek.
2. **Dinding Hukum Pengaman:** Karena folder `/.scratchpad/` sudah dicekal secara mutlak oleh aturan `.gitignore` di Sub-Bab B, seluruh aktivitas pelacakan kutu dan eksperimen kode AI dijamin tidak akan pernah mengotori pohon repositori atau masuk ke riwayat Git lokal Anda.

### D. Mekanisme Pembersihan Mandiri Pasca-Review (Self-Cleaning Routine Policy)
- **Penghapusan Berkas Temporer Otomatis:** Setelah proses pelacakan kutu (*debugging*) selesai, kode utama dinyatakan berhasil berjalan stabil, dan logika fungsional telah dipindahkan ke file arsitektur resmi aplikasi, AI **WAJIB menggunakan tool filesystem untuk menghapus kembali** seluruh berkas temporer yang ia ciptakan di dalam folder `/.scratchpad/`.
- **Sanitasi Repositori Sebelum Serah Terima (Handover):** Sebelum AI menyatakan sebuah tugas di `todo.md` berstatus "Selesai", atau melakukan rutinitas *auto-commit*, AI wajib melakukan inspeksi visual dan struktural pada pohon repositori untuk memastikan tidak ada metadata lokal, file log, atau berkas sampah yang tertinggal di luar struktur folder resmi yang telah disepakati pada Poin 10.
- **Log Pembersihan Rahasia:** Jika ditemukan ada kunci rahasia atau token yang sempat bocor ke file teks biasa selama fase *debugging*, AI wajib segera menghapus file tersebut, membersihkan jejaknya dari memori sementara, dan memberikan laporan tertulis kepada pengguna untuk melakukan rotasi kredensial demi keamanan siber.

---

## 9. DEPLOYMENT TARGET, SEO & MODERN SOCIAL MEDIA METADATA
- **Target Hosting Environment:** Local Development (Apache Sub-folder / Modern Runtime Node.js) & Ready to Deploy to Production Server (Shared Hosting / VPS / Cloud Hosting).
- **SEO & Modern Social Media Rich Preview Tags:** AI wajib menyertakan konfigurasi meta tags dinamis (Title, Description) dan arsitektur Open Graph lengkap (og:title, og:description, og:image, og:type) pada routing halaman utama. Konfigurasi ini wajib dioptimasi secara presisi agar menghasilkan kartu pratinjau yang profesional, aman, dan memikat saat link aplikasi dibagikan ke ekosistem media sosial kekinian saat ini: **TikTok, WhatsApp (Rich Preview Chat), Instagram (Bio Link View), YouTube (Community Post Cards), Facebook (Feed Preview), dan Threads (Card Post Link)**. Asset `og:image` wajib ditarik menggunakan URL absolut lengkap yang mendeteksi domain/host aktif saat itu secara dinamis agar gambar pratinjau kaya data tidak pecah atau kosong saat dimuat oleh aplikasi media sosial tersebut.

---

## 10. PROJECT FILE STRUCTURE (ASCII TREE MAP)

AI wajib memutasi dan men-generate visualisasi ASCII Tree secara utuh ke dalam berkas prd.md sesuai dengan karakteristik arsitektur ekosistem teknologi pilihan hasil wawancara menggunakan aturan pemetaan di bawah ini:

### SKENARIO A: Native HTML / PHP Environment Blueprint
├── /.docs/                 <── [WAJIB] Pusat seluruh dokumentasi teknis inti proyek
│   ├── architecture.md     <── Dokumentasi penjelasan aliran data makro aplikasi
│   ├── api-spec.md         <── Spesifikasi fungsi routing, parameter request, & backend
│   └── database.md         <── Skema data terstruktur DDL SQL / Local Store Object
├── /.scratchpad/           <── Zona terisolasi pengujian, log dumping, & debug (Git-Ignored)
├── /assets/                <── Kamar utama seluruh berkas statis di level root lingkungan native
│   ├── /css/
│   │   └── style.css       <── Berkas CSS utama penampung Core Utility Engine & aturan anti-gepeng
│   └── /img/               <── Folder penyimpanan aset gambar lokal & asset fallback (Fail-Safe)
├── /includes/              <── Bagian potongan layout global aplikasi (Navbar, Footer, Sidebar)
├── index.php / index.html  <── Gerbang masuk utama aplikasi (Landing Page View fungsional)
├── .env.example            <── Panduan blueprint variabel lingkungan proyek tanpa value asli
├── .gitignore              <── Proteksi rahasia siber mencekal berkas sensitif, prd, todo, & handover
├── handover.md             <── Kompas pelacak progress state harian (Auto-Generated Incremental Log)
├── prd.md                  <── Kitab suci spesifikasi fitur proyek hasil konfirmasi wawancara
└── todo.md                 <── Peta jalan linear aktivitas koding berjenjang 6 Fase Checkbox

### SKENARIO B: Modern Bundler Framework (React Vite / Next.js) App Router Architecture
├── /.docs/                 <── [WAJIB] Pusat seluruh dokumentasi teknis inti proyek
│   ├── architecture.md     <── Dokumentasi penjelasan aliran data makro aplikasi
│   ├── api-spec.md         <── Spesifikasi mutasi status, routing API, & server actions spec
│   └── database.md         <── Blueprint skema model data terstruktur / Local JSON Store
├── /.scratchpad/           <── Zona terisolasi pengujian, log dumping, & debug (Git-Ignored)
├── /public/                <── Folder aset statis wajib untuk prasyarat kompilasi mesin bundler
│   └── /images/            <── Tempat penyimpanan berkas cadangan gambar lokal (Fail-Safe Aset)
├── /src/                   <── Kamar utama seluruh modul kode program aplikasi berjalan
│   ├── /components/        <── Folder komponen visual modular global (Navbar, Button, UI Element)
│   ├── /config/
│   │   └── state.js        <── Tempat data state management simulator / Client memory dikunci
│   ├── /styles/
│   │   └── global.css      <── Integrasi Tailwind CSS v4 dengan cache-busting token dinamis
│   └── /views / /app/      <── File fisik halaman aktif penyusun kluster akses sistem router
├── .env.example            <── Panduan blueprint variabel lingkungan proyek tanpa value asli
├── .gitignore              <── Proteksi rahasia siber mencekal berkas sensitif, prd, todo, & handover
├── handover.md             <── Kompas pelacak progress state harian (Auto-Generated Incremental Log)
├── prd.md                  <── Kitab suci spesifikasi fitur proyek hasil konfirmasi wawancara
└── todo.md                 <── Peta jalan linear aktivitas koding berjenjang 6 Fase Checkbox

##[AI WAJIB MEN-GENERATE ASCII TREE STRUKTUR FOLDER DI SINI SEBELUM MULAI KODING]