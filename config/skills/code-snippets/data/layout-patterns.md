# Layout Patterns — Snippet Library

*Pattern layout siap pakai: Navbar, Sidebar, Footer, Bottom Nav.*

---

### [CS-020] Top Navbar (Responsive + Auth State)
Stack: Universal HTML/CSS
Kompleksitas: Medium

```html
<header class="navbar" role="banner">
  <nav class="navbar__inner" aria-label="Navigasi utama">
    <a href="/" class="navbar__brand">
      <img src="assets/img/logo.svg" alt="Logo" width="32" height="32">
      <span class="navbar__brand-text">AppName</span>
    </a>
    
    <ul class="navbar__menu" role="menubar">
      <li><a href="/" class="navbar__link active" aria-current="page">Beranda</a></li>
      <li><a href="/tentang" class="navbar__link">Tentang</a></li>
      <li><a href="/kontak" class="navbar__link">Kontak</a></li>
    </ul>
    
    <!-- Auth State: Guest -->
    <div class="navbar__actions" data-auth="guest">
      <a href="/login" class="btn btn-primary">Masuk</a>
    </div>
    
    <!-- Auth State: Logged In -->
    <div class="navbar__actions" data-auth="member" style="display:none;">
      <div class="dropdown" data-dropdown>
        <button class="dropdown__trigger avatar-trigger" aria-expanded="false">
          <img src="assets/img/avatar-default.webp" alt="Avatar" class="avatar avatar--sm" width="36" height="36">
        </button>
        <ul class="dropdown__menu" role="menu">
          <li role="menuitem"><a href="/profil">Profil Saya</a></li>
          <li role="menuitem"><a href="/pengaturan">Pengaturan</a></li>
          <li class="dropdown__divider" role="separator"></li>
          <li role="menuitem"><a href="/logout">Keluar</a></li>
        </ul>
      </div>
    </div>
  </nav>
</header>
```

```css
@layer components {
  .navbar {
    position: sticky; top: 0; z-index: 100;
    background: var(--vibe-surface); border-bottom: 1px solid var(--vibe-border);
    backdrop-filter: blur(12px);
  }
  .navbar__inner {
    display: flex; align-items: center; justify-content: space-between;
    max-width: 1200px; margin: 0 auto;
    padding: var(--space-s) var(--space-m);
    min-height: 64px;
  }
  .navbar__brand { display: flex; align-items: center; gap: var(--space-s); text-decoration: none; color: var(--vibe-text-main); font-weight: 700; }
  .navbar__menu { display: flex; list-style: none; gap: var(--space-m); }
  .navbar__link {
    text-decoration: none; color: var(--vibe-text-muted);
    padding: var(--space-xs) var(--space-s); border-radius: var(--radius-sm);
    transition: var(--vibe-transition); font-weight: 500;
  }
  .navbar__link:hover, .navbar__link.active { color: var(--vibe-primary); }
  .avatar--sm { width: 36px; height: 36px; border-radius: var(--radius-full); object-fit: cover; }
  .avatar-trigger { background: none; border: none; cursor: pointer; padding: 0; }
  
  @media (max-width: 768px) {
    .navbar__menu { display: none; }
    .navbar { display: none; } /* Hidden on mobile — Bottom Nav takes over */
  }
}
```

---

### [CS-021] Bottom Navigation (Mobile — Safe Area)
Stack: Universal HTML/CSS
Kompleksitas: Simple

```html
<nav class="bottom-nav" aria-label="Navigasi mobile">
  <a href="/" class="bottom-nav__item active" aria-current="page">
    <span class="bottom-nav__icon">🏠</span>
    <span class="bottom-nav__label">Beranda</span>
  </a>
  <a href="/explore" class="bottom-nav__item">
    <span class="bottom-nav__icon">🔍</span>
    <span class="bottom-nav__label">Jelajah</span>
  </a>
  <a href="/notif" class="bottom-nav__item">
    <span class="bottom-nav__icon">🔔</span>
    <span class="bottom-nav__label">Notifikasi</span>
  </a>
  <a href="/profil" class="bottom-nav__item">
    <span class="bottom-nav__icon">👤</span>
    <span class="bottom-nav__label">Profil</span>
  </a>
</nav>
```

```css
@layer components {
  .bottom-nav {
    display: none; /* Only show on mobile */
  }
  @media (max-width: 768px) {
    .bottom-nav {
      display: flex; position: fixed; bottom: 0; left: 0; right: 0;
      background: var(--vibe-surface); border-top: 1px solid var(--vibe-border);
      z-index: 100;
      padding-bottom: max(env(safe-area-inset-bottom), 8px); /* iOS safe area */
    }
    .bottom-nav__item {
      flex: 1; display: flex; flex-direction: column; align-items: center;
      padding: var(--space-s) var(--space-xs); gap: 2px;
      text-decoration: none; color: var(--vibe-text-muted);
      font-size: 0.7rem; min-height: 48px;
      transition: var(--vibe-transition);
    }
    .bottom-nav__item.active { color: var(--vibe-primary); }
    .bottom-nav__icon { font-size: 1.25rem; }
    /* Content padding to avoid overlap */
    .main-content { padding-bottom: calc(64px + env(safe-area-inset-bottom, 0px)); }
  }
}
```

Catatan: Sesuai design-system.md §10. Safe-area-inset REQUIRED untuk iPhone dengan notch.
