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
