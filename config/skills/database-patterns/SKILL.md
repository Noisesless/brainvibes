---
name: database-patterns
description: |
  Panduan, pattern, dan praktik terbaik untuk desain skema database, migrasi data, dan optimasi query.
  Mencakup penanganan transaksi (ACID), indexing, database seeding, dan integrasi ORM (Eloquent, Prisma).
  Aktif saat user meminta "desain database", "skema SQL", "migration", "buat seeder", "transaksi database", "optimasi query".
---

## Cara Penggunaan Skill Ini

Skill ini aktif otomatis pada skenario:

| Skenario | Contoh Trigger | Langkah Utama |
|---|---|---|
| Desain Tabel Baru | "Buat tabel transaksi", "Rancang DB" | Skema ACID + Tipe Data Aman |
| Optimasi Query Lambat | "Query ini lambat", "Index database" | Analisis Indexing + EXPLAIN query |
| Pembuatan Seeder | "Buat seeder user", "Isi dummy data" | Rich Seeder Rules + Password Hash |
| Penanganan Transaksi | "Gunakan transaksi DB", "Savepoint DB" | Implementasi ACID Transaction |

---

## 1. Aturan Keamanan Database & ACID Compliance

### 🔴 Zero-Destructive DB (Sesuai gemini.md §1 HARD BLOCK)
- **DILARANG KERAS** menggunakan query yang merusak data riil saat debug atau scanning (seperti `DROP TABLE`, `TRUNCATE`, atau `migrate:fresh` di environment production/existing).
- Selalu gunakan migration incremental (`ALTER TABLE`, `ADD COLUMN`) alih-alih merombak total tabel yang sudah berisi data.

### 🟡 ACID Transaction (Safety Guard)
Setiap transaksi yang melibatkan **lebih dari satu** query penulisan (INSERT, UPDATE, DELETE) yang saling bergantung wajib dibungkus dalam Database Transaction block untuk menjamin integritas data (All-or-Nothing):

```php
// PHP Native / mysqli:
$conn->begin_transaction();
try {
    $conn->query("INSERT INTO orders ...");
    $conn->query("UPDATE products SET stock = stock - 1 WHERE id = ...");
    $conn->commit();
} catch (Exception $e) {
    $conn->rollback();
    throw $e;
}
```

---

## 2. Standardisasi Tipe Data & Kolom

1. **Primary Key (PK)**
   - Gunakan `BIGINT AUTO_INCREMENT` (untuk database relasional MySQL/PostgreSQL konvensional) atau `VARCHAR(36)` / `VARCHAR(30)` dengan format UUID/CUID (disarankan untuk Next.js/Node.js).
2. **Password Storage**
   - Kolom password wajib bertipe `VARCHAR(255)` untuk menampung Bcrypt/Argon2 hash (minimal 60 karakter). Dilarang menggunakan VARCHAR pendek (< 60) karena hash password akan terpotong dan gagal verifikasi.
3. **Multi-Size Image Columns**
   - Gunakan tipe data `JSON` atau `TEXT` (jika database tidak support native JSON) untuk menyimpan representasi multi-size uploads (misal: `avatar_urls` -> `{"thumb": "...", "medium": "..."}`).
4. **Boolean Fields**
   - Gunakan `TINYINT(1)` atau `BOOLEAN` dengan default value (misal: `status` / `is_active` default `1`).

---

## 3. Strategi Indexing (Optimasi Kecepatan Query)

AI **REQUIRED** menambahkan indeks pada kolom-kolom berikut:
- **Foreign Keys (FK)**: Setiap kolom relasi (seperti `user_id`, `category_id`) wajib di-index untuk mempercepat join query.
- **Search Columns**: Kolom yang sering masuk ke klausa `WHERE`, `ORDER BY`, atau `GROUP BY` (seperti `email`, `status`, `created_at`).
- **Unique Constraints**: Kolom unik seperti `email` atau `username` otomatis dibuat index UNIQUE oleh database.

```sql
-- Contoh syntax indexing MySQL:
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_posts_status_created ON posts(status, created_at);
```

---

## 4. Rich Seeder Rules (Default Credentials)

Saat merancang seeder default untuk deployment/testing, AI wajib mengikuti penamaan kredensial standar berikut:
- **Super Admin**: Kredensial super admin default menggunakan format password: `Adm![AppSlug]@[4digit]`.
  - Email: `admin@[domain].com`
  - Contoh: App "BrainVibes" -> password `Adm!brainvibes@2026`.
- **Member**: Kredensial member default menggunakan format password: `Mem![AppSlug]@[4digit]`.
  - Email: `member@[domain].com`

---

## 5. Protokol Review Skema (Langkah AI)

1. **Langkah 1: Identifikasi Relasi**
   Petakan tabel, primary key, dan foreign key. Pastikan data integrity constraint (ON DELETE RESTRICT/CASCADE) ditentukan secara eksplisit.
2. **Langkah 2: Cek Tipe Data & Kolom Wajib**
   Pastikan ada kolom audit (`created_at`, `updated_at`) pada setiap tabel penting. Cek tipe data password (`VARCHAR(255)`).
3. **Langkah 3: Cek Skema Indexing**
   Verifikasi apakah join query ke tabel tersebut akan memicu Full Table Scan. Tambahkan rekomendasi INDEX jika dibutuhkan.
4. **Langkah 4: Sajikan DDL SQL / ORM Schema**
   Sajikan skema final dalam format DDL SQL yang aman (menggunakan `CREATE TABLE IF NOT EXISTS`) atau skema ORM target (Prisma/Eloquent).
