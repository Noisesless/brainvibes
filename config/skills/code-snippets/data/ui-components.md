# UI Components — Snippet Library

*Komponen UI siap pakai yang sesuai design-system.md tokens.*

---

### [CS-001] Modal Dialog (Accessible + Focus Trap)
Stack: Vanilla CSS + JavaScript (Universal)
Kompleksitas: Medium
Dependensi: Tidak ada

```html
<!-- Modal HTML -->
<dialog id="modal-confirm" class="modal">
  <div class="modal__content">
    <header class="modal__header">
      <h2 class="modal__title">Konfirmasi</h2>
      <button class="modal__close" aria-label="Tutup modal">&times;</button>
    </header>
    <div class="modal__body">
      <p>Apakah Anda yakin ingin melanjutkan?</p>
    </div>
    <footer class="modal__footer">
      <button class="btn btn-secondary" data-action="cancel">Batal</button>
      <button class="btn btn-primary" data-action="confirm">Ya, Lanjutkan</button>
    </footer>
  </div>
</dialog>
```

```css
@layer components {
  .modal {
    border: none; border-radius: var(--radius-lg);
    background: var(--vibe-surface); color: var(--vibe-text-main);
    box-shadow: var(--shadow-hover); max-width: 480px; width: 90%;
    padding: 0;
  }
  .modal::backdrop { background: var(--vibe-overlay); }
  .modal__content { padding: var(--space-l); }
  .modal__header { display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-m); }
  .modal__title { font-size: 1.25rem; font-weight: 600; }
  .modal__close { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--vibe-text-muted); min-width: 44px; min-height: 44px; }
  .modal__footer { display: flex; gap: var(--space-s); justify-content: flex-end; margin-top: var(--space-l); }
}
```

```javascript
// Modal controller
function openModal(id) {
  const modal = document.getElementById(id);
  modal.showModal();
}
function closeModal(id) {
  const modal = document.getElementById(id);
  modal.close();
}
// Event delegation
document.addEventListener('click', (e) => {
  if (e.target.matches('.modal__close, [data-action="cancel"]')) {
    e.target.closest('dialog').close();
  }
});
// Close on backdrop click
document.querySelectorAll('.modal').forEach(modal => {
  modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.close();
  });
});
```

Catatan implementasi: Menggunakan native `<dialog>` element — sudah include focus trap dan Esc-to-close bawaan browser.

---

### [CS-002] Toast Notification (Auto-dismiss + Stack)
Stack: Vanilla CSS + JavaScript (Universal)
Kompleksitas: Simple
Dependensi: Tidak ada

```html
<div id="toast-container" aria-live="polite"></div>
```

```css
@layer components {
  #toast-container {
    position: fixed; bottom: var(--space-l); right: var(--space-l);
    display: flex; flex-direction: column-reverse; gap: var(--space-s);
    z-index: 999; pointer-events: none;
  }
  .toast {
    padding: var(--space-s) var(--space-m); border-radius: var(--radius-md);
    color: #fff; font-weight: 500; pointer-events: auto;
    animation: toast-in 0.3s ease forwards;
    max-width: 360px;
  }
  .toast--success { background: var(--vibe-success); color: #000; }
  .toast--error   { background: var(--vibe-error); }
  .toast--warning { background: var(--vibe-warning); color: #000; }
  .toast--exit    { animation: toast-out 0.3s ease forwards; }
  @keyframes toast-in  { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
  @keyframes toast-out { from { opacity: 1; } to { opacity: 0; transform: translateY(-10px); } }
}
```

```javascript
function showToast(message, type = 'success', duration = 3000) {
  const container = document.getElementById('toast-container');
  const toast = document.createElement('div');
  toast.className = `toast toast--${type}`;
  toast.textContent = message;
  container.appendChild(toast);
  setTimeout(() => {
    toast.classList.add('toast--exit');
    setTimeout(() => toast.remove(), 300);
  }, duration);
}
// Penggunaan: showToast('Data berhasil disimpan!', 'success');
```

---

### [CS-003] Dropdown Menu (Keyboard Accessible)
Stack: Vanilla CSS + JavaScript (Universal)
Kompleksitas: Medium
Dependensi: Tidak ada

```html
<div class="dropdown" data-dropdown>
  <button class="dropdown__trigger" aria-expanded="false" aria-haspopup="true">
    Menu ▾
  </button>
  <ul class="dropdown__menu" role="menu">
    <li role="menuitem"><a href="#">Profil</a></li>
    <li role="menuitem"><a href="#">Pengaturan</a></li>
    <li class="dropdown__divider" role="separator"></li>
    <li role="menuitem"><a href="#" class="text-danger">Keluar</a></li>
  </ul>
</div>
```

```css
@layer components {
  .dropdown { position: relative; display: inline-block; }
  .dropdown__menu {
    position: absolute; top: 100%; right: 0; margin-top: var(--space-xs);
    background: var(--vibe-surface); border: 1px solid var(--vibe-border);
    border-radius: var(--radius-md); box-shadow: var(--shadow-hover);
    min-width: 180px; list-style: none; padding: var(--space-xs) 0;
    opacity: 0; transform: translateY(-8px); pointer-events: none;
    transition: var(--vibe-transition); z-index: 50;
  }
  .dropdown[data-open] .dropdown__menu { opacity: 1; transform: translateY(0); pointer-events: auto; }
  .dropdown__menu li a {
    display: block; padding: var(--space-s) var(--space-m);
    color: var(--vibe-text-main); text-decoration: none;
    transition: var(--vibe-transition);
  }
  .dropdown__menu li a:hover { background: var(--vibe-hover); }
  .dropdown__divider { border-top: 1px solid var(--vibe-divider); margin: var(--space-xs) 0; }
}
```

```javascript
document.querySelectorAll('[data-dropdown]').forEach(dropdown => {
  const trigger = dropdown.querySelector('.dropdown__trigger');
  trigger.addEventListener('click', (e) => {
    e.stopPropagation();
    const isOpen = dropdown.hasAttribute('data-open');
    document.querySelectorAll('[data-dropdown][data-open]').forEach(d => d.removeAttribute('data-open'));
    if (!isOpen) dropdown.setAttribute('data-open', '');
    trigger.setAttribute('aria-expanded', !isOpen);
  });
});
document.addEventListener('click', () => {
  document.querySelectorAll('[data-dropdown][data-open]').forEach(d => {
    d.removeAttribute('data-open');
    d.querySelector('.dropdown__trigger').setAttribute('aria-expanded', 'false');
  });
});
```

---

### [CS-004] Skeleton Loader (Content Placeholder)
Stack: Vanilla CSS (Universal)
Kompleksitas: Simple
Dependensi: Tidak ada

```html
<!-- Card Skeleton -->
<div class="skeleton-card">
  <div class="skeleton skeleton--image"></div>
  <div class="skeleton skeleton--title"></div>
  <div class="skeleton skeleton--text"></div>
  <div class="skeleton skeleton--text skeleton--short"></div>
</div>
```

```css
@layer components {
  .skeleton {
    background: var(--vibe-skeleton);
    border-radius: var(--radius-sm);
    animation: skeleton-pulse 1.5s ease-in-out infinite;
  }
  .skeleton--image  { width: 100%; height: 200px; border-radius: var(--radius-md); margin-bottom: var(--space-m); }
  .skeleton--title  { width: 70%; height: 24px; margin-bottom: var(--space-s); }
  .skeleton--text   { width: 100%; height: 16px; margin-bottom: var(--space-xs); }
  .skeleton--short  { width: 50%; }
  .skeleton--avatar { width: 48px; height: 48px; border-radius: var(--radius-full); }
  @keyframes skeleton-pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
}
```

---

### [CS-005] Overlapping Card Layout (Intersecting Badges)
Stack: Vanilla CSS + HTML (Sesuai Gambar "Cleaning Services")
Kompleksitas: Medium
Dependensi: Icon library (e.g. Tabler / Phosphor)

```html
<div class="service-card">
  <div class="service-card__image-wrapper">
    <img class="service-card__image" src="https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=400&q=80" alt="Home Cleaning">
  </div>
  
  <div class="service-card__body">
    <!-- Intersecting Badge -->
    <div class="service-card__badge">
      <!-- Icon SVG dari Tabler/Phosphor -->
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-home" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <path d="M5 12l-2 0l9 -9l9 9l-2 0" />
        <path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7" />
        <path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6" />
      </svg>
    </div>
    
    <h3 class="service-card__title">Home Cleaning</h3>
    <p class="service-card__description">
      Layanan pembersihan rumah menyeluruh yang bersih, higienis, dan dapat Anda percayai setiap saat.
    </p>
    
    <a href="/services/home-cleaning" class="service-card__cta">
      Read More <span class="arrow">→</span>
    </a>
  </div>
</div>
```

```css
@layer components {
  .service-card {
    position: relative;
    display: flex;
    flex-direction: column;
    border-radius: var(--radius-lg, 16px);
    overflow: visible; /* Penting agar badge/boks konten bisa melayang */
    background: transparent;
    width: 100%;
    max-width: 380px;
    margin-bottom: 2rem;
  }

  .service-card__image-wrapper {
    position: relative;
    width: 100%;
    height: 240px;
    border-radius: var(--radius-lg, 16px);
    overflow: hidden;
  }

  .service-card__image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform var(--vibe-transition);
  }

  /* Hover effect pada gambar */
  .service-card:hover .service-card__image {
    transform: scale(1.05);
  }

  /* Boks konten yang menindih (overlapping) gambar */
  .service-card__body {
    position: relative;
    background: var(--vibe-surface, #ffffff);
    margin-inline: var(--space-4, 16px);
    margin-top: -48px; /* Menaikkan box konten agar menindih gambar */
    padding: var(--space-6, 24px);
    padding-top: var(--space-8, 36px);
    border-radius: var(--radius-md, 12px);
    box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.1);
    z-index: 10;
    text-align: center;
    transition: transform var(--vibe-transition), box-shadow var(--vibe-transition);
  }

  .service-card:hover .service-card__body {
    transform: translateY(-4px);
    box-shadow: 0 15px 35px -10px rgba(0, 0, 0, 0.15);
  }

  /* Intersecting Badge - lingkaran yang memotong pas di tengah garis batas */
  .service-card__badge {
    position: absolute;
    top: -24px; /* Setengah dari tinggi badge (48px) agar tepat di tengah */
    left: 50%;
    transform: translateX(-50%);
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: var(--vibe-accent-1, #1e3a1e); /* Warna hijau gelap seperti gambar */
    color: var(--vibe-accent-2, #ffffff); /* Warna teks/ikon */
    display: flex;
    align-items: center;
    justify-content: center;
    border: 3px solid var(--vibe-surface, #ffffff); /* Border tebal pemotong visual */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    z-index: 20;
    transition: transform var(--vibe-transition), background-color var(--vibe-transition);
  }

  .service-card:hover .service-card__badge {
    transform: translateX(-50%) scale(1.1);
    background: var(--vibe-accent-2, #ffd800); /* Berubah ke warna aksen sekunder */
    color: #000000;
  }

  .service-card__title {
    font-family: var(--vibe-font-head, sans-serif);
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--vibe-text-main, #111827);
    margin-bottom: var(--space-2, 8px);
  }

  .service-card__description {
    font-family: var(--vibe-font-main, sans-serif);
    font-size: 0.875rem;
    line-height: 1.5;
    color: var(--vibe-text-sub, #4b5563);
    margin-bottom: var(--space-4, 16px);
  }

  /* CTA Button tipe Pill (Read More) */
  .service-card__cta {
    display: inline-flex;
    align-items: center;
    gap: var(--space-1, 4px);
    background: var(--vibe-accent-2, #ffd800); /* Warna kuning premium */
    color: #000000;
    font-size: 0.875rem;
    font-weight: 600;
    text-decoration: none;
    padding: var(--space-2, 8px) var(--space-4, 16px);
    border-radius: 9999px; /* Bentuk pill */
    transition: background-color var(--vibe-transition), transform var(--vibe-transition);
  }

  .service-card__cta:hover {
    background: var(--vibe-accent-1, #1e3a1e);
    color: #ffffff;
  }

  .service-card__cta .arrow {
    transition: transform 0.2s ease;
  }

  .service-card__cta:hover .arrow {
    transform: translateX(4px);
  }
}
```

