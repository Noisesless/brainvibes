---
name: taste-skill-bridge-model-hints
description: |
  Model-specific anti-slop hints. Berisi override dan workaround untuk
  model AI yang cenderung menghasilkan UI generik (AI slop).
  Prioritas: Gemini 3.7 Flash. Berlaku juga untuk model lain.
  Dibaca 1x per sesi saat visual task aktif.
---

# MODEL HINTS — Anti-AI-Slop Override per Model

> Baca file ini 1x per sesi saat mengerjakan visual task.
> Berisi known tendencies dan hard overrides per model.

---

## Gemini 3.7 Flash — Known Tendencies & Overrides

### Layout Slop (HARD OVERRIDE)
| Tendency | Override |
|---|---|
| Default centered hero + gradient mesh bg | → Split 50/50 atau Asymmetric hero. FORBIDDEN centered jika V>4 |
| 3 equal feature cards (simetris) | → Bento Matrix 2×2+1×1+2×1, Staggered translateY, atau Split Offset |
| Semua section sama treatment (flat) | → Wajib alternasi Rhythm Score A→C→B→D→A |
| Glassmorphism di semua card | → Hanya 1 section boleh glassmorphism, sisanya solid/tinted |

### Tipografi Slop (HARD OVERRIDE)
| Tendency | Override |
|---|---|
| Inter saja tanpa heading font | → FORBIDDEN. Wajib 2-font pair dari typography.csv |
| `font-size: 16px` flat di semua text | → Wajib `clamp()` responsive scale |
| Tidak ada `text-wrap: balance/pretty` | → REQUIRED pada heading dan paragraf |

### Warna Slop (HARD OVERRIDE)
| Tendency | Override |
|---|---|
| AI-purple `#6C63FF` atau `#8B5CF6` | → FORBIDDEN. Gunakan palet dari colors.csv |
| `rgba(0,0,0,0.1)` shadow | → FORBIDDEN. Gunakan tinted shadow dari design-system.md §4 |
| `background: white` / `color: black` hardcode | → FORBIDDEN. Gunakan `var(--vibe-background)` / `var(--vibe-text-main)` |
| Color overlay di atas gambar | → FORBIDDEN (AP-016). DNA via typography/spacing/radius |

### Elemen Slop (HARD OVERRIDE)
| Tendency | Override |
|---|---|
| Eyebrow/capsule badge di setiap heading | → FORBIDDEN di auth pages. Max 1 per 3 section di halaman lain |
| Ikon SVG hand-rolled (path mentah) | → FORBIDDEN. Gunakan icon library proyek |
| Fake stats ("92% faster", "4.1× growth") | → FORBIDDEN tanpa real data |
| Border/outline/shadow pada logo | → FORBIDDEN. Logo as-is tanpa dekorasi |

### Copy Slop (HARD OVERRIDE)
Dua kebiasaan yang sering muncul, di SEMUA model:

| Tendency | Override |
|---|---|
| Prompt user disalin jadi heading/subtitle ("Halaman untuk menampilkan data...") | → Cetak `[COPY TABLE]`: ambil entitas + aksi, buang kata instruksi. Heading = nomina |
| Slot kosong diisi kata promosi ("Unlock", "Seamless", "Solusi terbaik", "Terdepan") | → Blocklist EN+ID di `COPY_RULES.md §4`. Tanpa fakta = hapus |
| Kalimat pembuka meta ("Halaman ini...", "Selamat datang di...", "Berikut adalah...") | → Hapus, langsung isi |
| Istilah brief desain bocor ke UI ("Hero Section", "Bento Grid", "Dark Mode") | → Pakai nama user-facing |
| Instruksi teknis / timezone bocor ke UI ("(WIB)", "Asia/Jakarta", "Data realtime terbaru", "bcrypt") | → Instruksi waktu/sorting/security adalah logika KODE. FORBIDDEN tempel (WIB), timezone, atau istilah teknis di label/tabel UI |
| Toast/error verbose + tanda seru + emoji | → Max 10 kata, tanpa "!" dan emoji dekorasi |

→ Gunakan bahasa spesifik domain dari `prd.md §1 Target User`. Jalankan lint regex `COPY_RULES.md §7` sebelum declare done.

---

## Claude (Opus/Sonnet) — Known Tendencies

| Tendency | Override |
|---|---|
| Over-engineered CSS (terlalu banyak utility class) | → Gunakan token-based approach, jangan atomic CSS berlebihan |
| Verbose HTML (div nesting terlalu dalam) | → Max 4 level nesting. Gunakan semantic HTML |
| Cenderung patuh tapi kadang skip UUPM search | → Tetap enforce Gate 3 UUPM — jangan skip |
| Suka menambah fitur tidak diminta | → Stick ke brief. FORBIDDEN scope creep visual |

---

## Universal Rules (Semua Model)

1. **UUPM Gate TIDAK BISA DI-SKIP** — model apapun wajib menjalankan Gate 1-5 sebelum menulis kode
2. **Rhythm Score WAJIB** — output `[RHYTHM SCORE]` sebelum HTML
3. **Pre-Flight WAJIB** — output `[TASTE-SKILL PRE-FLIGHT]` sebelum declare done
4. **Copy Gate berlaku universal** — `[COPY TABLE]` sebelum kode, `[COPY CHECK]` sebelum declare done (`COPY_RULES.md`)
