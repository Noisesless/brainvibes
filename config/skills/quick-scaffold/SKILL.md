---
name: quick-scaffold
description: Generator boilerplate file cepat per-stack (PHP Native, Laravel, Next.js). Trigger otomatis saat user meminta buat komponen, model, controller, form, atau route baru.
triggers:
  - buat komponen
  - buat model
  - buat controller
  - buat form
  - buat route
  - scaffold
  - generate file
---

# Quick Scaffold Skill

## Tujuan
Menghasilkan boilerplate file yang konsisten dengan Vibes Coding Workflow tanpa AI menulis ulang dari nol setiap kali.

## Cara Pakai
AI REQUIRED membaca file ini saat menerima instruksi: "buat komponen X", "buat model Y", "scaffold Z".

---

## §1. Stack Detection (Silent)
Baca dari `app-context.md §IDENTITY`:
- `Frontend` → tentukan stack frontend
- `Backend`  → tentukan stack backend
- `Styling`  → tentukan CSS framework
- `Icon Set` → tentukan icon library

---

## §2. Template PHP Native

### Model
`php
// models/[ModelName].php — PDO + Prepared Statement (WAJIB)
class [ModelName] {
    private PDO $db;
    public function __construct(PDO $db) { $this->db = $db; }

    public function findAll(): array {
        $stmt = $this->db->prepare("SELECT * FROM [table] ORDER BY created_at DESC");
        $stmt->execute(); return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    public function findById(int $id): array|false {
        $stmt = $this->db->prepare("SELECT * FROM [table] WHERE id = ?");
        $stmt->execute([$id]); return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    public function create(array $data): bool {
        $stmt = $this->db->prepare("INSERT INTO [table] ([col1],[col2]) VALUES (?,?)");
        return $stmt->execute([$data['col1'], $data['col2']]);
    }
    public function update(int $id, array $data): bool {
        $stmt = $this->db->prepare("UPDATE [table] SET [col1]=?,[col2]=? WHERE id=?");
        return $stmt->execute([$data['col1'], $data['col2'], $id]);
    }
    public function delete(int $id): bool {
        $stmt = $this->db->prepare("DELETE FROM [table] WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
`

### Controller (PHP Native)
`php
// controllers/[Name]Controller.php
require_once __DIR__ . '/../models/[ModelName].php';
class [Name]Controller {
    private [ModelName] $model;
    public function __construct(PDO $db) { $this->model = new [ModelName]($db); }
    public function index(): void {
        requireLogin();
        $items = $this->model->findAll();
        require_once __DIR__ . '/../views/[name]/index.php';
    }
    public function store(): void {
        requireLogin();
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit; }
        if (!verifyCsrf($_POST['_token'] ?? '')) { http_response_code(403); exit; }
        $data = ['col1' => htmlspecialchars(trim($_POST['col1'] ?? ''), ENT_QUOTES, 'UTF-8')];
        if (empty($data['col1'])) { $_SESSION['error'] = 'col1 wajib diisi.'; header('Location: /[route]'); exit; }
        $this->model->create($data);
        $_SESSION['success'] = 'Data tersimpan.'; header('Location: /[route]'); exit;
    }
}
`

---

## §3. Template Laravel

### Model
`php
// app/Models/[ModelName].php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class [ModelName] extends Model {
    protected $fillable = ['col1', 'col2', 'user_id'];
    protected $hidden   = ['deleted_at'];
    public function user() { return $this->belongsTo(User::class); }
}
`

### Controller Resource
`php
// app/Http/Controllers/[Name]Controller.php
namespace App\Http\Controllers;
use App\Models\[ModelName]; use Illuminate\Http\Request;
class [Name]Controller extends Controller {
    public function index() {
        $items = [ModelName]::latest()->paginate(15);
        return view('[name].index', compact('items'));
    }
    public function store(Request $request) {
        $validated = $request->validate(['col1' => 'required|string|max:255']);
        [ModelName]::create($validated);
        return redirect()->route('[name].index')->with('success', 'Tersimpan.');
    }
}
`

---

## §4. Template Next.js

### Page Component (App Router)
`	sx
// app/[route]/page.tsx
import type { Metadata } from 'next'
export const metadata: Metadata = { title: '[Title] — [App]', description: '[Desc]' }
export default async function [Name]Page() {
  return (<main className="[name]-page"><h1>[Title]</h1></main>)
}
`

### API Route Handler
`	s
// app/api/[route]/route.ts
import { NextRequest, NextResponse } from 'next/server'
export async function GET(req: NextRequest) {
  try { return NextResponse.json({ data: [], success: true }) }
  catch { return NextResponse.json({ error: 'Server Error' }, { status: 500 }) }
}
export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    if (!body.field) return NextResponse.json({ error: 'field required' }, { status: 400 })
    return NextResponse.json({ data: body, success: true }, { status: 201 })
  } catch { return NextResponse.json({ error: 'Server Error' }, { status: 500 }) }
}
`

### Reusable Component
`	sx
// components/[Name]/[Name].tsx
'use client'
import { useState } from 'react'
interface [Name]Props { title: string; className?: string }
export function [Name]({ title, className = '' }: [Name]Props) {
  const [isActive, setIsActive] = useState(false)
  return (<div className={`[name] ${className}`}><h2>{title}</h2></div>)
}
export default [Name]
`

---

## §5. Aturan Penggunaan
1. Deteksi stack dari `app-context.md §IDENTITY`
2. Pilih template dari §2 (PHP), §3 (Laravel), atau §4 (Next.js)
3. Ganti semua `[PLACEHOLDER]` dengan nilai aktual proyek
4. Terapkan CSS tokens dari `app-context.md §DESIGN`
5. Ikuti naming convention proyek yang sudah ada
6. JANGAN salin komentar template ke file produksi
