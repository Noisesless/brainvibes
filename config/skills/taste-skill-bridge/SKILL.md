---
name: taste-skill-bridge
description: |
  Anti-slop frontend integration bridge. Menghubungkan taste-skill (design intelligence)
  dengan pipeline UUPM + design-system.md. Auto-aktif saat user meminta: buat halaman,
  redesign, landing page, portfolio, UI baru, tampilan baru, ubah desain, frontend,
  perbaiki halaman, buat artikel, halaman berita, template post, edit tampilan,
  update konten halaman, ubah layout, perbaiki artikel,
  sesuai visual dna, sesuai vdna, visual dna, vdna, samakan visual,
  konsistensi visual, ikuti desain halaman utama, ikuti style halaman lain,
  perbaiki agar konsisten, update tampilan.
  Menghasilkan Design Read + Three Dials → UUPM query → CSS token → kode anti-slop.
  Berlaku untuk semua stack: PHP Native, Laravel, Next.js, React, Astro, Vanilla HTML/CSS.
  PRINSIP INTI: Visual DNA sebuah proyek dimulai dari halaman utama (landing/dashboard).
  Semua halaman lain WAJIB mewarisi dan konsisten dengan Visual DNA halaman utama.
---

# TASTE-SKILL BRIDGE — Anti-Slop Frontend Integration

> Skill ini adalah integrasi dari taste-skill (github.com/Leonxlnx/taste-skill) yang
> disesuaikan untuk pipeline Vibes Coding Workflow. Baca aturan ini SEBELUM menulis
> satu baris kode UI pun.
>
> ⚠️ **MANDATORY UNTUK AI:** Saat skill ini di-trigger, AI REQUIRED membaca file ini
> secara **PENUH** menggunakan `view_file` — BUKAN hanya membaca deskripsi singkat dari
> skills registry. Deskripsi registry hanya untuk trigger-detection; aturan sesungguhnya
> ada di body file ini. FORBIDDEN mengeksekusi STEP 0-6 dari memori tanpa baca ulang.

---

## STEP 0 — BRIEF INFERENCE (Wajib Sebelum Apapun)

Sebelum menulis kode atau memilih palet, AI REQUIRED membaca konteks:

### 0.A Sinyal yang Harus Dibaca
1. **Tipe halaman** — landing, dashboard, portfolio, auth, CMS, public portal
2. **Vibe dari prd.md** — ambil dari §3 Karakter Visual dan §3 Core Identity Lock
3. **Audience** — dari prd.md §1 Target User
4. **Stack** — dari prd.md §2 Tech Stack (tentukan apakah pakai Motion/GSAP/vanilla CSS)
5. **Brand assets** — palet warna terkunci di prd.md CORE IDENTITY LOCK
6. **Quiet constraints** — jika proyek pemerintahan/publik/anak-anak → OVERRIDE ke trust-first

### 0.B Output Design Read Wajib (1 Baris — Sebelum Kode)
```
[Design Read] Reading this as: [tipe halaman] untuk [audience], vibe [kata-kunci dari prd.md], 
leaning toward [aesthetic family], dials: V=[1-10] M=[1-10] D=[1-10]
[DNA Source] Inheriting from: [nama file halaman utama] — tokens: [daftar token yang diekstrak]
```

**Contoh output (halaman baru):**
```
[Design Read] Reading this as: Halaman artikel untuk blog tech, vibe dark-editorial,
leaning toward Carbon Slate palette + reading-optimized layout, dials: V=6 M=4 D=3
[DNA Source] Inheriting from: index.html / home.blade.php — tokens: --vibe-primary, --font-heading: Geist, --radius-md: 8px, shadow-style: tinted
```

**Contoh output (halaman utama / tidak ada parent):**
```
[Design Read] Reading this as: Landing page untuk SaaS B2B, vibe dark-professional,
leaning toward Oceanic Jade palette + asymmetric layout, dials: V=7 M=6 D=4
[DNA Source] NEW — ini halaman utama, Visual DNA dimulai di sini. UUPM akan menentukan token.
```

### 0.C Anti-Default Discipline (HARD BLOCK)
FORBIDDEN defaulting ke:
- AI-purple gradients + centered dark mesh hero
- 3 equal feature cards (symmetrical)
- Glassmorphism everywhere tanpa alasan
- Infinite loop micro-animations di semua elemen
- Inter + slate-900 tanpa heading font pair
- **Color overlay/tint layer di atas gambar sebagai "penerapan DNA"** → lihat §0.F
- **Cosmetic-only redesign** (ganti warna/font saja, layout sama) → lihat §0.G
- **Gambar placeholder atau Unsplash generic tanpa prompt spesifik** → lihat §0.H

### 0.F Anti-Color-Overlay Law (HARD BLOCK — AP-016)
> ⛔ FORBIDDEN menggunakan `background: rgba(--vibe-accent, 0.4)` atau semacamnya
> sebagai overlay di atas gambar sebagai teknik "menerapkan Visual DNA".

DNA **tidak diterapkan** lewat overlay warna pada gambar. DNA diterapkan lewat:
- Tipografi (`--font-heading`, `--font-body`)
- Spacing rhythm (8pt grid)
- Border-radius system (`--radius-md`)
- CSS token warna pada elemen UI (bukan gambar)

**Overlay warna HANYA diizinkan jika:**
- Ada teks di atas gambar yang gagal kontras WCAG AA (rasio < 4.5:1)
- Dan tidak ada cara lain (relocate teks, dark scrim minimal)

**Jika tidak ada gambar real:** WAJIB jalankan `generate_image` dengan prompt kontekstual
(sertakan: industri, mood, palet DNA, gaya visual proyek). FORBIDDEN div kosong atau gambar
generic yang sama dipakai lintas project.

### 0.G Anti-Cosmetic-Redesign Law (HARD BLOCK — AP-018)
> ⛔ FORBIDDEN mengeksekusi redesign hanya dengan mengganti warna, font, atau spacing.
> Layout yang sama = bukan redesign.

**Redesign WAJIB mengubah minimal 2 dari 4 dimensi:**
1. **Hero layout family** → centered | split 50/50 | full-bleed | asymmetric | bento
2. **Section grid structure** → 3-col equal | masonry | timeline | horizontal scroll | zigzag
3. **Navigation model** → top bar | sticky sidebar | floating dock | bottom tab
4. **Typography hierarchy** → display-dominant | body-dominant | mono-accent | editorial

**Jika user minta redesign untuk ke-2 kalinya atau lebih:**
1. AI WAJIB stop dan output 3 opsi layout berbeda dalam format:
   ```
   [REDESIGN OPTIONS]
   Opsi A: [nama layout family] — [deskripsi 1 kalimat]
   Opsi B: [nama layout family] — [deskripsi 1 kalimat]
   Opsi C: [nama layout family] — [deskripsi 1 kalimat]
   ```
2. Tunggu user pilih salah satu SEBELUM eksekusi kode
3. FORBIDDEN langsung eksekusi variasi kosmetik dari hasil sebelumnya

### 0.H Anti-Image-Amnesia Law (HARD BLOCK — AP-019)
> ⛔ FORBIDDEN membuat halaman baru tanpa gambar kontekstual yang spesifik untuk project.

**Cek WAJIB sebelum tulis HTML:**
```
[ ] Apakah generate_image tool tersedia di sesi ini?
    → YA: REQUIRED generate minimal 1 hero image per halaman baru
         Prompt wajib sertakan: [industri] + [mood] + [palet/warna] + [gaya visual]
    → TIDAK: Gunakan Unsplash dengan query spesifik project
         CONTOH BENAR : ?q=fintech+dark+minimal+dashboard&auto=format
         CONTOH SALAH : ?q=abstract&auto=format (generic, dipakai di semua project)
[ ] Apakah gambar ini sudah pernah dipakai di project lain?
    → YA: FORBIDDEN reuse — generate/cari gambar baru
```


### 0.I Page Composition Rhythm Law (HARD RULE — Anti-Monoton)
> **Prinsip:** Sebuah halaman yang baik seperti musik — ada bagian keras, pelan, dramatis,
> dan tenang yang silih berganti. Sections TIDAK boleh monoton dalam treatment visual.

---

#### §0.I-1 — Rhythm Score System (Wajib Dihitung Sebelum Kode)

Sebelum menulis HTML, AI REQUIRED menyusun **Rhythm Score** halaman — daftar urutan
sections dengan treatment visual yang bervariasi:

**5 Jenis Treatment Section:**
```
[A] AIRY         → Background putih/light, max-width container, banyak whitespace
[B] DENSE        → Grid rapat, banyak card/item, background surface/mid-tone
[C] FULL-BLEED   → Background melebar ke edge browser, tidak ada container clip
[D] DARK-MOMENT  → Background gelap atau solid accent, teks terang (kontras tinggi)
[E] MEDIA-HEAVY  → Section didominasi gambar/video besar, teks minimal
```

**Aturan Rhythm Score:**
- FORBIDDEN 3 section berturut-turut dengan treatment SAMA (`[A][A][A]` atau `[B][B][B]`)
- REQUIRED minimal 1 section `[E] MEDIA-HEAVY` atau `[C] FULL-BLEED` per halaman landing
- REQUIRED minimal 1 section `[D] DARK-MOMENT` jika halaman bertema terang
- Urutan ideal: `[A/B] → [C/E] → [A/B] → [D] → [A/B] → footer`

**Output Wajib (tulis SEBELUM kode HTML):**
```
[RHYTHM SCORE]
Nav      : [sticky glass / solid / transparent]
Hero     : [E] full-bleed split image — treatment: image kiri, text kanan
Section2 : [B] dense grid 3-col — treatment: card abu-abu, icon accent
Section3 : [C] full-bleed dark — treatment: bg --vibe-surface, quote besar center
Section4 : [A] airy single col — treatment: whitespace besar, 1 statistik besar
Section5 : [E] media-heavy — treatment: video/image fullwidth, caption bawah
Footer   : [D] dark-moment — treatment: bg gelap, link kolom
```

---

#### §0.I-2 — Section Treatment Playbook

**Kapan pakai [C] FULL-BLEED:**
- Setelah 2+ section container → pecah monotoni
- Section testimonial/quote — dramatisasi pesan
- Section CTA utama — butuh perhatian penuh
- Section yang punya gambar landscape/panorama
```css
/* Full-bleed pattern */
.section-full-bleed {
  width: 100vw;
  margin-inline: calc(50% - 50vw);  /* escape container tanpa ubah HTML */
  padding-block: var(--space-16, 4rem);
}
```

**Kapan pakai [E] MEDIA-HEAVY:**
- Section "Cara Kerja" → screenshot product / demo video
- Section "Hasil" → before/after image besar
- Section portfolio/showcase → masonry atau horizontal scroll gallery
- Hero — gambar atau video mengisi ≥50% viewport

**Kapan pakai [D] DARK-MOMENT:**
- Section statistik / numbers yang ingin di-dramatisasi
- Section testimonial kuat
- Footer
- Pre-footer CTA ("Siap mulai?")

**Kapan pakai [A] AIRY:**
- Setelah section padat/dramatis → beri nafas
- Section FAQ (jawaban panjang)
- Section detail fitur yang butuh fokus membaca

**Kapan pakai [B] DENSE:**
- Feature grid (3-6 fitur)
- Pricing comparison
- Team grid
- Logo wall partner

---

#### §0.I-3 — Section Sinergy Rules (Anti-Konflik Visual)

**Background Alternation Rule:**
```
Jika section sebelumnya BG TERANG → section berikutnya HARUS BG BERBEDA
(pilih: medium/surface, gelap, atau full-bleed image)

Jika section sebelumnya BG GELAP → section berikutnya BOLEH terang atau medium
(jangan gelap lagi langsung)
```

**Width Alternation Rule:**
```
Jika 2 section berturut-turut pakai max-width container →
section ke-3 WAJIB full-bleed atau edge-to-edge
```

**Content Weight Alternation Rule:**
```
Banyak teks → sedikit teks (visual dominan)
Grid banyak item → single statement besar
Dense card layout → spacious editorial
```

---

#### §0.I-4 — "Manusia vs Mesin" Test

Sebelum declare halaman selesai, AI REQUIRED membaca ulang Rhythm Score dan menjawab:

```
[RHYTHM CHECK]
1. Apakah ada minimal 1 section yang membuat user berhenti sejenak? (WOW moment) → [Ya/Tidak]
2. Apakah ada variasi width (container + full-bleed)? → [Ya/Tidak]
3. Apakah background berganti minimal 3x dari atas ke bawah? → [Ya/Tidak]
4. Apakah ada section yang didominasi gambar/visual (bukan teks)? → [Ya/Tidak]
5. Apakah ada "ruang nafas" (airy section) setelah section paling padat? → [Ya/Tidak]
```
Jika ada 2+ jawaban [Tidak] → REDESIGN rhythm sebelum eksekusi kode.

---

### 0.J Premium Visual Architecture (WOW Factors — Humanized UI)
> **Prinsip:** Gunakan elemen-elemen layout premium yang membuat halaman terasa hidup,
> dinamis, dan premium — bukan sekadar blok-blok datar.

#### §0.J-1 — Custom Shape Dividers (Wave/Cloud)
Ganti pembatas lurus antar-section dengan transisi kurva/organik (seperti awan atau gelombang) menggunakan inline SVG.
- **Kapan pakai:** Di bawah Hero section atau di atas Footer untuk transisi yang mulus.
- **Aturan kontras:** SVG fill harus mencocokkan persis warna latar belakang section tujuan.
- **Contoh kode CSS/HTML:**
```html
<div class="hero">
  <!-- Content Hero -->
  <div class="hero__divider">
    <svg viewBox="0 0 1440 120" fill="none" preserveAspectRatio="none">
      <path d="M0,32L120,42.7C240,53,480,75,720,74.7C960,75,1200,53,1320,42.7L1440,32L1440,120L1320,120C1200,120,960,120,720,120C480,120,240,120,120,120L0,120Z" fill="var(--vibe-background)"></path>
    </svg>
  </div>
</div>
```
```css
.hero { position: relative; padding-bottom: 80px; }
.hero__divider {
  position: absolute; bottom: 0; left: 0; width: 100%; overflow: hidden; line-height: 0;
}
.hero__divider svg {
  position: relative; display: block; width: calc(100% + 1.3px); height: 80px;
}
```

#### §0.J-2 — Overlapping Card Layout & Intersecting Badges
Daripada menggunakan kartu datar generic, gunakan layout bertumpuk (overlapping) di mana boks konten mengambang di atas gambar, dengan badge ikon yang berpotongan (intersecting) tepat di tengah garis batas tumpukan.
- **Struktur:**
  - Gambar/Visual di background kartu (full-width atau top-half).
  - Boks konten putih/cerah dengan shadow melayang (`transform: translateY(-24px)` atau positioning absolute).
  - Ikon/Badge berbentuk lingkaran (`rounded-full`) dengan border warna yang kontras, diletakkan tepat di tengah-tengah perbatasan gambar dan boks konten.
- **Tactile effect:** Saat hover pada kartu, berikan pergeseran posisi boks konten dan perbesaran ikon (`scale-110`).

#### §0.J-3 — Floating Micro-Decorations (Organic Particles)
Tambahkan partikel mengambang kecil yang statis atau berputar perlahan (micro-animation) di area kosong Hero atau Widget untuk menambah kedalaman visual (depth).
- **Jenis partikel:** Lingkaran kuning/aksen kecil, ikon bintang/sparkle minimalis, atau garis halus melengkung.
- **Aturan:** Tempatkan di belakang teks (`z-index: 1`) agar tidak menutupi informasi penting, dan gunakan opacity rendah (20% - 40%).

#### §0.J-4 — Non-Standard Card Geometry (Anti-AI Rectangles)
> ⛔ **ATURAN GEOMETRI & PENEMPATAN KARTU:**
> Kartu kotak/simetris standar (`border-radius: 8px-16px` biasa) **TIDAK salah secara fungsional**
> dan sangat bagus untuk data terstruktur seperti *pricing tables* atau *feature grids*.
> Namun, FORBIDDEN menggunakan boks kotak seragam untuk **setiap** elemen di seluruh halaman.

**Hukum Variasi Bentuk (Shape Alternation Rule):**
1. **Gunakan kartu kotak HANYA pada 1-2 section terstruktur** (misal: Pricing atau Specs).
2. **Section non-data (Testimonial, Team, Highlight, FAQ, Galeri) WAJIB menggunakan alternatif bentuk lain:**
   - **Testimonial**: Buat melayang tanpa boks (airy text only layout dengan grid minimal).
   - **Tim / Galeri / Produk**: Gunakan bentuk kubah (Arch), Oval, atau bentuk Daun asimetris.
   - **CTA/Widget**: Gunakan background full-bleed atau bentuk potongan kustom.

**Alternatif Geometri kustom yang bisa digunakan:**

1. **Asymmetric Rounded (Bentuk Daun / Organic Blob):**
   Sudut berlawanan memiliki kelengkungan yang berbeda jauh untuk memberikan kesan dinamis dan tidak kaku.
   ```css
   .card--asymmetric {
     border-radius: 40px 12px 40px 12px; /* Melengkung di pojok kiri atas & kanan bawah */
   }
   /* ATAU gunakan kelengkungan kustom 8-nilai */
   .card--blob {
     border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%;
   }
   ```

2. **Oval Card Layout (Untuk Layout Sparse & Editorial):**
   Sangat cocok untuk menampilkan visual tim, testimonial, atau kategori produk dengan whitespace longgar.
   ```css
   .card--oval {
     aspect-ratio: 3 / 4;
     border-radius: 9999px; /* Membentuk oval tegak jika aspect-ratio tidak 1:1 */
     overflow: hidden;
   }
   ```

3. **Angled Cut / Origami (Untuk Vibe Cyber / Edgy Tech):**
   Menggunakan `clip-path` untuk memotong sudut kartu secara diagonal (tidak rounded).
   ```css
   .card--angled {
     clip-path: polygon(0 0, 100% 0, 100% calc(100% - 24px), calc(100% - 24px) 100%, 0 100%);
   }
   ```

4. **Arch / Window Layout (Bentuk Kubah):**
   Melengkung penuh hanya di bagian atas, sementara bagian bawah tetap siku-siku (flat). Memberi kesan arsitektural atau jendela galeri seni.
   ```css
   .card--arch {
     border-radius: 120px 120px 12px 12px; /* Kubah atas */
   }
   ```

---




### 0.D Existing Page Audit (Wajib Jika Halaman Sudah Ada)
Jika task adalah **edit / perbaiki / update** halaman yang sudah ada:
1. Baca file HTML/CSS/template target terlebih dahulu (`view_file`)
2. **Audit Tipografi** — cek:
   - Apakah ada 2-font pairing (heading + body)? → Jika TIDAK: **langsung fix sekarang, tidak boleh ditunda**
   - Apakah `font-size`, `line-height`, `text-wrap` sudah sesuai §4.1? → Jika TIDAK: **langsung fix**
3. **Audit Layout Containment** — cek:
   - Apakah content area punya `max-width`? → Jika TIDAK: **deklarasikan sekarang**
   - Apakah ada `overflow-wrap: break-word`? → Jika TIDAK: **tambahkan sekarang**
   - Apakah `img` punya `max-width: 100%`? → Jika TIDAK: **tambahkan sekarang**
4. Catat temuan sebagai `[Audit]` sebelum `[Design Read]`
5. Lanjut ke STEP 1-6 seperti biasa — **FORBIDDEN melewati pipeline meskipun bukan halaman baru**

> ⚠️ **HARD BLOCK — ANTI-EXCUSE LAW:**
> FORBIDDEN menunda fix tipografi atau CSS containment dengan alasan apapun:
> - ❌ "CSS content area belum di-declare" → SALAH: deklarasikan dulu, lalu fix tipografi
> - ❌ "Menunggu layout selesai dulu" → SALAH: tipografi dan containment fix BERSAMAAN dengan layout
> - ❌ "Bukan bagian dari task" → SALAH: jika audit menemukan masalah, wajib fix dalam task yang sama
> - ❌ "User tidak meminta fix tipografi" → SALAH: tipografi adalah bagian dari Visual DNA, wajib konsisten

```
[Audit] Font: Inter saja → FIX: tambah Geist sebagai heading font | Container: tidak ada max-width → FIX: tambah .content { max-width: 65ch } | Status: langsung difix dalam task ini
```

### 0.E Visual DNA Inheritance Protocol (HARD RULE — Wajib untuk Semua Halaman Non-Utama)

> **Prinsip:** Visual DNA sebuah proyek SELALU dimulai dari halaman utama
> (landing page / dashboard / homepage / index). Semua halaman lain adalah **turunan**
> dari Visual DNA tersebut — bukan desain terpisah yang berdiri sendiri.

**Langkah wajib SEBELUM mendesain halaman non-utama:**

**Step E-1 — Deteksi apakah ini halaman utama atau turunan:**
```
Halaman UTAMA (DNA Origin)  : index, home, landing, dashboard, main
Halaman TURUNAN (Harus inherit) : artikel, berita, about, contact, profile,
                                   detail, kategori, list, form, auth pages
```

**Step E-2 — Jika halaman TURUNAN → Baca halaman utama dulu:**
```
1. Temukan file halaman utama → index.html / home.blade.php / page.tsx / index.php
2. Ekstrak DNA tokens:
   a. Palet aktif         → cari var(--vibe-*) atau :root CSS variables
   b. Font pair           → cari font-family declaration (heading + body)
   c. Border-radius system → cari --radius-* atau border-radius pattern
   d. Spacing rhythm      → cari gap/padding pattern (kelipatan 8pt?)
   e. Shadow style        → cari box-shadow (tinted? pure black? neumorphic?)
   f. Nav pattern         → fixed/sticky? height? glassmorphism?
   g. Section structure   → full-width? max-width container? padding pattern?
   h. Button style        → solid? outline? ghost? pill shape?
3. Catat di [DNA Source] sebelum menulis kode apapun
```

**Step E-3 — Apply inherited DNA ke halaman baru:**
```
SEMUA token dari halaman utama → WAJIB dipakai di halaman turunan
FORBIDDEN memperkenalkan:
  - Font baru yang tidak ada di halaman utama
  - Radius system yang berbeda (misal: halaman utama sharp → halaman artikel tiba-tiba pill)
  - Palet warna baru (accent color baru yang tidak ada di halaman utama)
  - Shadow style yang berbeda tone/gaya
  - Nav style yang berbeda (halaman utama fixed, halaman lain tidak punya nav)
```

**Step E-4 — Boleh BERBEDA di halaman turunan (hanya ini):**
```
✅ Layout density (artikel lebih sparse daripada dashboard)
✅ Section type (artikel tidak punya hero, tapi punya article header)
✅ Konten spesifik (gambar kontekstual, data berbeda)
✅ Motion intensity LEBIH RENDAH (artikel lebih tenang dari landing page)
✅ Typography scale LEBIH KECIL (artikel body text, bukan display headline)
```

**HARD BLOCK:**
FORBIDDEN membuat halaman turunan tanpa membaca halaman utama terlebih dahulu.
Jika halaman utama belum ada → buat halaman utama dulu, ATAU tandai halaman ini
sebagai "temporary DNA origin" dan catat di `[DNA Source] PLACEHOLDER`.

---

## STEP 1 — THREE DIALS INFERENCE

Setelah Design Read, set 3 dials. Semua keputusan layout, motion, density mengacu ini.

| Dial | Range | Default |
|---|---|---|
| `DESIGN_VARIANCE` | 1=Simetri Penuh → 10=Chaos Kreatif | 7 |
| `MOTION_INTENSITY` | 1=Statis → 10=Sinematik/Physics | 5 |
| `VISUAL_DENSITY` | 1=Art Gallery/Airy → 10=Cockpit Data | 4 |

### Tabel Inferensi Dials dari Konteks Proyek

| Sinyal dari prd.md | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| Dashboard admin / data-heavy | 5 | 3 | 7 |
| Landing page SaaS / startup | 7 | 6 | 4 |
| Portfolio / creative agency | 9 | 8 | 3 |
| Proyek pemerintahan / publik | 3 | 2 | 5 |
| E-commerce premium | 7 | 6 | 3 |
| Blog / editorial / CMS | 6 | 4 | 3 |
| Auth pages (login/register) | 5 | 4 | 4 |
| Redesign — preserve | match existing | +1 | match |
| Redesign — overhaul | +2 | +2 | match |

---

## STEP 2 — UUPM PIPELINE (Wajib Diam-diam)

Setelah dials diset, jalankan UUPM search secara diam-diam:

**Langkah 0 — Cek Python Tersedia (Silent):**
```cmd
python --version
```

**Jika Python TERSEDIA** → jalankan UUPM search:
```cmd
python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[tipe_proyek] [industri] [vibe_keyword]" --design-system
```

Ekstrak dari output:
- **Primary/Accent hex** → konversi ke `oklch()` → masuk ke `--raw-palette-*`
- **Gaya visual** → jadi CSS keyword guidance untuk komponen
- **`Design System Variables`** dari `styles.csv` → masuk ke `:root` token
- **`Implementation Checklist`** → jadi pre-delivery checklist

**Jika Python TIDAK TERSEDIA (Terhambat/Gagal/Izin Ditolak)** → lakukan **Direct-Read Fallback**:
1. Jangan biarkan desain di-skip. Gunakan tool `view_file` atau `grep_search` secara langsung untuk mengurai file database UUPM di folder `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data/`:
   - `colors.csv` -> Cari baris kategori industri/vibe terkait untuk mendapatkan Primary/Accent hex.
   - `styles.csv` -> Cari baris gaya visual terkait untuk mendapatkan variabel layout.
   - `typography.csv` -> Dapatkan font pairing yang sesuai.
2. Jika pencarian manual CSV terhambat, gunakan fallback sekunder dengan memilih palet dari **15 kluster `design-system.md §1`** berdasarkan inferred vibe:
   - VARIANCE 8-10 → kluster "Cyber Industrial" / "Acid Streetwear" / "Holographic Dream"
   - VARIANCE 5-7 → kluster "Oceanic Jade" / "Nordic Earth" / "Carbon Slate"
   - VARIANCE 3-4 → kluster "Executive Navy" / "Medical Trust" / "Corporate Steel"
   - VARIANCE 1-2 → kluster "Minimalist Ivory" / "Pure Mono"
3. Catat di prd.md §3: `Sumber Palet: UUPM Direct-Read CSV (Python tidak aktif)`


Jika stack terdeteksi (React/Next.js/Laravel), jalankan tambahan:
```cmd
python "%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\scripts\search.py" "[komponen]" --stack [nextjs|react|laravel|vue|astro]
```

---

## STEP 3 — DESIGN SYSTEM INTEGRATION

### §3.A Stack Defaults (Pilih Berdasarkan prd.md §2)

| Stack | CSS Engine | Animation | Icons |
|---|---|---|---|
| Next.js / React | Tailwind v4 | motion/react | @phosphor-icons/react |
| Laravel + Blade | Vanilla CSS + @layer | CSS transition | @tabler/icons (CDN) atau Phosphor Icons CDN |
| PHP Native | Vanilla CSS + @layer | CSS transition | @tabler/icons (CDN) atau Phosphor Icons CDN |
| Astro 5+ | Vanilla CSS + @layer | CSS + View Transitions | @phosphor-icons |

**HARD RULES (semua stack):**
- NEVER `h-screen` untuk hero → REQUIRED `min-h-[100dvh]`
- NEVER flex percentage math → REQUIRED CSS Grid
- NEVER `useState` untuk tracking continuous values (scroll/mouse) → gunakan Motion's `useMotionValue`

### §3.B Font System (Anti-Slop) + Typography Enforcement

**REQUIRED — Wajib pada SEMUA halaman (baru maupun existing):**
- REQUIRED: 2-font pairing dari `typography.csv` UUPM — 1 heading font + 1 body font
- FORBIDDEN: Inter sendirian tanpa heading font — selalu pair dengan: Geist, Outfit, Cabinet Grotesk, Satoshi, atau GT America
- Fallback stack wajib: `font-family: '[HeadingFont]', '[Fallback]', system-ui, sans-serif`
- Discouraged as default: Fraunces, Instrument Serif (LLM favorites — terlalu generik)

**CSS Implementation Wajib (deklarasikan di `:root` atau file CSS utama):**
```css
:root {
  --font-heading: 'Geist', 'Outfit', system-ui, sans-serif;  /* dari UUPM typography.csv */
  --font-body:    'Inter', system-ui, sans-serif;
}

h1, h2, h3, h4, h5, h6 { font-family: var(--font-heading); }
body, p, li, td          { font-family: var(--font-body); }
```

> ⚠️ **ANTI-EXCUSE — Typography Fix adalah UNCONDITIONAL:**
> FORBIDDEN menunda atau melewati fix tipografi karena alasan apapun.
> Jika CSS container belum ada → buat container-nya DULU, lalu apply tipografi.
> Tipografi bukan opsional — ini bagian dari Visual DNA.

### §3.C Icon Policy
- Priority: `@phosphor-icons/react` > `@tabler/icons-react` > `@radix-ui/react-icons`
- PHP/Laravel: gunakan Tabler Icons via CDN `<script src="https://cdn.jsdelivr.net/npm/@tabler/icons@latest/icons-sprite.svg">` atau Phosphor Icons CDN
- FORBIDDEN: lucide-react (kecuali user minta)
- FORBIDDEN: hand-roll SVG icons (ikon di-draw manual dalam kode)
- FORBIDDEN: border, outline, stroke, atau box-shadow pada elemen logo — logo WAJIB as-is tanpa dekorasi
- ONE icon family per project — jangan campur
- **Catatan:** Inline SVG dari CDN (`cdn.simpleicons.org`) untuk **logo brand** (logo wall) tetap DIIZINKAN — ini beda dengan hand-roll icon

---

## STEP 4 — LAYOUT ANTI-SLOP RULES

### §4.1 Typography + CSS Containment (WAJIB BERSAMAAN — Tidak Terpisah)

> ⚠️ **HARD RULE:** Tipografi dan CSS containment adalah SATU KESATUAN.
> FORBIDDEN mengerjakan salah satu tanpa yang lain.
> Jika content area belum ada container → BUAT DULU, lalu apply tipografi.

**Typography Scale:**
- Display/Headlines: `clamp(1.75rem, 4vw, 2.5rem)`, `font-weight: 700`, `line-height: 1.25`
- Subheadings H2/H3: `clamp(1.25rem, 3vw, 1.75rem)`, `font-weight: 600`, `line-height: 1.35`
- Body: `font-size: 1rem`, `line-height: 1.6` (artikel) / `1.5` (UI)
- Caption/Meta: `font-size: 0.875rem`, `line-height: 1.4`
- REQUIRED `text-wrap: balance` pada H1/H2/H3
- REQUIRED `text-wrap: pretty` pada paragraf

**CSS Containment Wajib (deklarasikan di SEMUA halaman):**
```css
/* WAJIB ada di setiap halaman — tidak ada alasan untuk tidak declare ini */
.content-area,
.article-body,
.page-body,
main {
  max-width: 65ch;           /* untuk artikel/editorial */
  /* ATAU */
  max-width: var(--content-width, 72rem);  /* untuk halaman umum */
  margin-inline: auto;
  padding-inline: var(--space-4, 1rem);
  overflow-wrap: break-word;
  word-break: break-word;
}

/* Selalu apply ke semua halaman */
*, *::before, *::after {
  box-sizing: border-box;
}

img, video, svg {
  max-width: 100%;
  height: auto;
  display: block;
}

pre, code {
  overflow-x: auto;
  max-width: 100%;
  white-space: pre-wrap;     /* mencegah horizontal overflow */
  word-break: break-all;
}
```

### §4.2 Color Calibration
- Max 1 accent color. Saturation < 80% default
- FORBIDDEN AI-purple (`#6C63FF`) sebagai default — gunakan UUPM colors.csv
- FORBIDDEN fluctuate antara warm dan cool gray dalam 1 proyek
- **COLOR CONSISTENCY LOCK:** Accent dipilih sekali → locked di semua section

### §4.3 Layout — Anti-Center Bias
- FORBIDDEN: Centered Hero jika `DESIGN_VARIANCE > 4`
- REQUIRED: gunakan Split Screen 50/50, Left-aligned, atau Asymmetric
- **SECTION REPETITION BAN:** Max 1 kali per layout family per page
- **ZIGZAG CAP:** Max 2 section berturut-turut image+text split. Section ke-3 HARUS beda
- **EYEBROW RESTRAINT:** Max 1 eyebrow per 3 section. Jika section A pakai eyebrow → 2 section berikutnya FORBIDDEN pakai eyebrow

### §4.4 Cards & Shadows
- Cards HANYA saat elevation communicates hierarchy
- Shadow HARUS ditint ke hue background — no pure black shadow
- **SHAPE CONSISTENCY LOCK:** Satu corner-radius untuk seluruh halaman (sharp/soft/pill)
- FORBIDDEN: mixed radius system tanpa documented rule

### §4.5 Interactive States (Wajib Semua)
- Loading: Skeletal loaders matching final layout shape
- Empty State: Beautifully composed, shows how to populate
- Error State: Clear, inline (forms) atau toast (transient only)
- Tactile feedback: pada `:active` gunakan `-translate-y-[1px]` atau `scale-[0.98]`
- **BUTTON CONTRAST CHECK (mandatory):** Setiap button wajib WCAG AA (4.5:1 body, 3:1 large text)
- **CTA WRAP BAN:** Button label MUST fit 1 line. Label > 3 kata → shorten
- **NO DUPLICATE CTA INTENT:** Satu intent = satu label di seluruh page

### §4.6 Hero Section Rules
- Hero HARUS fit dalam initial viewport (no scroll untuk lihat CTA)
- Max 2 lines headline di desktop
- Subtext max 20 words, max 4 lines
- Max 4 text elements total: [eyebrow OR nothing] + [headline] + [subtext] + [CTAs]
- Hero top padding MAX `pt-24` (≈6rem)
- **BANNED di dalam hero:** trust logo wall, pricing teaser, feature bullet list
- Logo wall = seksi BAWAH hero, bukan di dalam hero

### §4.7 Navigation Rules
- Nav HARUS render single line di desktop
- Nav height: 64-72px default, MAX 80px
- Bento cells = tepat sebanyak content. Empty cell = redesign grid
- Mobile collapse HARUS dideklarasikan eksplisit per section

### §4.8 Visual Assets (Mandatory)
1. Jika `generate_image` tersedia → REQUIRED generate kontekstual (hero, product shot, mood)
2. Tidak ada gen tool → gunakan `https://images.unsplash.com/photo-xxx?auto=format&fit=crop&w=800&q=80` dengan seed deskriptif
3. **FORBIDDEN:** div-based fake screenshots, placeholder SVG rectangles
4. **FORBIDDEN:** halaman text-only tanpa minimal 2-3 real images
5. Logo wall → gunakan SVG nyata dari `cdn.simpleicons.org/{slug}/currentColor`

### §4.9 Content Rules
- Headline: max 8 kata
- Subtext: max 25 kata per section
- Quote/testimonial: max 3 lines
- Attribution: name + role + company (FORBIDDEN: name only)
- **COPY SELF-AUDIT:** Re-read semua visible string sebelum declare done
- **FORBIDDEN:** fake-precise numbers (92%, 4.1×) tanpa real data

### §4.10 Article & Editorial Layout Rules (Wajib untuk Tipe Post/Berita/Artikel/Blog)

Jika tipe halaman adalah artikel, berita, post, blog, editorial — rules berikut WAJIB diterapkan:

**Container Wajib:**
```css
.article-wrapper {
  max-width: 72rem;           /* outer container */
  margin-inline: auto;
  padding-inline: clamp(1rem, 5vw, 2rem);
}

.article-content {
  max-width: 65ch;            /* optimal reading width */
  margin-inline: auto;
  overflow-wrap: break-word;
  word-break: break-word;
  hyphens: auto;
}
```

**Typography Artikel Wajib:**
```css
.article-content p {
  font-family: var(--font-body);
  font-size: clamp(1rem, 1.5vw, 1.125rem);  /* sedikit lebih besar untuk readability */
  line-height: 1.75;                          /* lebih longgar dari UI */
  text-wrap: pretty;
  color: var(--vibe-text-main);
  margin-block: var(--space-4, 1rem);
}

.article-content h1 {
  font-family: var(--font-heading);
  font-size: clamp(1.75rem, 4vw, 2.5rem);
  line-height: 1.2;
  text-wrap: balance;
  font-weight: 700;
}

.article-content h2, .article-content h3 {
  font-family: var(--font-heading);
  font-size: clamp(1.25rem, 2.5vw, 1.75rem);
  line-height: 1.3;
  text-wrap: balance;
  font-weight: 600;
  margin-block-start: var(--space-8, 2rem);
}
```

**Media & Elemen Lain:**
```css
.article-content img,
.article-content figure {
  max-width: 100%;      /* WAJIB — mencegah overflow */
  height: auto;
  display: block;
  border-radius: var(--radius-md);
  margin-block: var(--space-6, 1.5rem);
}

.article-content pre {
  overflow-x: auto;     /* WAJIB — mencegah code block overflow */
  max-width: 100%;
  padding: var(--space-4, 1rem);
  border-radius: var(--radius-sm);
  background: var(--vibe-surface);
}

.article-content table {
  width: 100%;
  overflow-x: auto;     /* WAJIB — tabel sering overflow di mobile */
  display: block;
}

.article-content blockquote {
  border-inline-start: 4px solid var(--vibe-accent);
  padding-inline-start: var(--space-4, 1rem);
  margin-inline: 0;
  font-style: italic;
  color: var(--vibe-text-muted);
}
```

> **ANTI-EXCUSE:** FORBIDDEN halaman artikel/berita tanpa deklarasi `.article-content` atau `.article-wrapper`.
> Jika template belum ada container — buat sekarang sebagai bagian dari task.
> CSS containment adalah PRASYARAT tipografi, bukan alasan untuk menunda tipografi.


---

## STEP 5 — PRE-FLIGHT CHECK (Sebelum Declare Selesai)

AI REQUIRED menjalankan checklist ini sebelum menyatakan task UI selesai:

### Pre-Flight Checklist (Mechanical)
- [ ] **DNA Inheritance:** Halaman non-utama sudah inherit font/palet/radius/shadow dari halaman utama
- [ ] **File Written:** Perubahan sudah ditulis ke disk via `write_to_file`/`replace_file_content` — FORBIDDEN declare done jika hanya output di chat
- [ ] **Typography:** Dua font dipakai (heading + body), bukan Inter sendirian
- [ ] **Hero:** Fit dalam viewport, max 4 text elements, top padding ≤ pt-24
- [ ] **Height:** Tidak ada `h-screen` → sudah `min-h-[100dvh]`
- [ ] **Center Bias:** Jika VARIANCE > 4, hero BUKAN centered
- [ ] **Eyebrow count:** ≤ ceil(sectionCount / 3)
- [ ] **Zigzag:** Tidak ada 3+ consecutive image+text split layout
- [ ] **CTA:** Semua labels fit 1 line, tidak ada duplicate intent
- [ ] **Button contrast:** Semua tombol pass WCAG AA 4.5:1
- [ ] **Shape consistency:** Menggunakan 1 corner-radius system yang konsisten untuk semua komponen. Jika menggunakan geometri kustom (asimetris/blob/oval/arch), pastikan sudah diterapkan secara seragam dan tidak dicampur tanpa aturan tertulis.
- [ ] **Geometry Check:** FORBIDDEN hanya menggunakan persegi panjang rounded standar di seluruh halaman. Minimal ada 1 tipe elemen visual/kartu yang menggunakan bentuk geometri kustom (asimetris, oval, blob, arch, atau intersecting circle badges) untuk memecah monotoni.
- [ ] **Color:** Tidak ada hardcode `white`/`black`/`#6C63FF`
- [ ] **Spacing:** Semua padding/margin dalam kelipatan 8pt
- [ ] **Images:** Minimal 2 real images, tidak ada fake screenshot div, tidak ada color overlay
- [ ] **Mobile:** Semua section punya explicit mobile collapse rule
- [ ] **CSS tokens:** Semua warna via `var(--vibe-*)`, tidak ada hex hardcode
- [ ] **Article containment:** Jika tipe artikel/berita → `overflow-wrap: break-word` + `img { max-width: 100% }` + `pre { overflow-x: auto }` sudah diterapkan
- [ ] **Rhythm Score:** Sudah ada [RHYTHM SCORE] output. Tidak ada 3 section berturut dengan treatment sama. Ada minimal 1 [C] atau [E] section. Rhythm Check: 4+ dari 5 jawaban [Ya]

**Format output self-check:**
```
[TASTE-SKILL PRE-FLIGHT]
DNA: ✅ | File: ✅ | Typography: ✅ | Hero: ✅ | Center-bias: ✅ | Eyebrow: ✅
CTA: ✅ | Contrast: ✅ | Shape: ✅ (Asymmetric/Blob/Oval/Arch) | Tokens: ✅ | Images: ✅ | Mobile: ✅ | Article: ✅
Rhythm: ✅ [A→C→B→D→A] — WOW moment: ✅ | Full-bleed: ✅ | BG variety: ✅
```
Jika ada ❌ → perbaiki SEBELUM declare done.

---

## STEP 6 — MOTION GUIDELINES (Berlaku jika MOTION_INTENSITY ≥ 4)

- Motion HARUS bermotivasi: hierarchy, storytelling, feedback, atau state transition
- FORBIDDEN: animasi "karena terlihat keren" tanpa alasan
- **MARQUEE MAX:** 1 per halaman. Lebih dari 1 = lazy filler
- Spring physics default: `type: "spring", stiffness: 100, damping: 20`
- FORBIDDEN: linear easing untuk UI interactions
- `prefers-reduced-motion`: REQUIRED fallback untuk semua animasi

---

## REFERENSI SILANG

| Komponen | Baca Di |
|---|---|
| CSS token architecture (oklch, @layer) | `design-system.md §2` |
| Master palette 15 kluster | `design-system.md §1` |
| Typography hierarchy | `design-system.md §3` |
| Shadow & elevation | `design-system.md §4` |
| Z-index map | `design-system.md §5` |
| Spacing 8-point grid | `design-system.md §6` |
| Page Composition Rhythm | `taste-skill-bridge/SKILL.md §0.I` |
| Anti-Color-Overlay | `taste-skill-bridge/SKILL.md §0.F` |
| Anti-Cosmetic-Redesign | `taste-skill-bridge/SKILL.md §0.G` |
| UUPM color database (193 palet) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\colors.csv` |
| UUPM style database (84 gaya) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\styles.csv` |
| UUPM typography (73 pairings) | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\typography.csv` |
| UUPM UX guidelines | `%USERPROFILE%\.gemini\config\skills\ui-ux-pro-max\data\ux-guidelines.csv` |
| Auth + security rules | `gemini.md §4B` |
| Active link policy | `gemini.md §4A` |
| Upload pipeline | `gemini.md §4E` |
| Anti-slop HARD BLOCK lengkap | `gemini.md §4K F` |
| Anti-patterns library (AP-016 to AP-019) | `lessons-learned/data/anti-patterns.md` |
