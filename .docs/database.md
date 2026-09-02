# Brainvibes — Database Schema

## Overview

Brainvibes sendiri bukan aplikasi dengan database, tapi sistem konfigurasi yang mendefinisikan schema database untuk proyek yang dibuat dengannya.

## Database Engine Default

| Parameter | Value |
|---|---|
| `db_engine` | MySQL |
| `local_server` | XAMPP Apache |
| `local_base_path` | `C:\xampp\htdocs\` |

## Schema Template (Generik untuk Semua Proyek)

### Users Table
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    role ENUM('admin', 'user', 'moderator') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
);
```

### Sessions Table (JWT/Session)
```sql
CREATE TABLE sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_expires (expires_at)
);
```

### Projects Table (Multi-project support)
```sql
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    type ENUM('web', 'mobile', 'desktop') DEFAULT 'web',
    stack VARCHAR(100),
    status ENUM('active', 'archived', 'deleted') DEFAULT 'active',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_slug (slug),
    INDEX idx_status (status)
);
```

### Tasks Table (Todo tracking)
```sql
CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('pending', 'in_progress', 'completed', 'failed') DEFAULT 'pending',
    phase INT DEFAULT 1,
    order_index INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    INDEX idx_project (project_id),
    INDEX idx_status (status)
);
```

## Brainvibes Runtime Storage

### JSON-based State (No SQL Required)

| File | Purpose | Format |
|---|---|---|
| `config/projects/*.json` | Project registry | UUID-based JSON |
| `config/mcp_config.json` | MCP server config (Gemini) | JSON |
| `knowledge/.knowledge-index.json` | Knowledge Base index tracking | JSON |
| `app-context.md` | AI snapshot | Markdown (≤100 baris) |
| `handover.md` | Human log | Markdown (100 baris rolling) |
| `~/.cache/codebase-memory-mcp/` | CBM knowledge graph cache | SQLite + FTS5 + LZ4 |
| `.codebase-memory/graph.db.zst` | Team-shared graph snapshot (opsional) | Zstandard compressed SQLite |

## Index Strategy

### Critical Indexes
1. `email` — Auth lookup (UNIQUE)
2. `token` — Session validation (UNIQUE)
3. `slug` — Project routing (UNIQUE)
4. `expires_at` — Session cleanup (TTL)
5. `project_id + status` — Task filtering

### Performance Considerations
- Gunakan `EXPLAIN` untuk query kompleks
- Index hanya kolom yang sering di-query WHERE/JOEIN
- Hindari over-indexing (menambah write overhead)
- Partition tables > 1M rows jika perlu
