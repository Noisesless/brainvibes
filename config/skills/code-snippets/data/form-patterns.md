# Form Patterns — Snippet Library

*Pattern form siap pakai yang sesuai design-system.md tokens dan A11Y standards.*

---

### [CS-010] Login Form (Responsive + CSRF + Captcha Ready)
Stack: Universal HTML/CSS
Kompleksitas: Medium

```html
<form class="auth-form" method="POST" action="login-handler" autocomplete="on">
  <input type="hidden" name="csrf_token" value="TOKEN_HERE">
  
  <h1 class="auth-form__title">Masuk ke Akun</h1>
  
  <div class="form-group">
    <label for="identity">Email atau Username</label>
    <input type="text" id="identity" name="identity" class="form-input"
           required autocomplete="username" placeholder="nama@email.com">
  </div>
  
  <div class="form-group">
    <label for="password">Password</label>
    <div class="input-password-wrapper">
      <input type="password" id="password" name="password" class="form-input"
             required autocomplete="current-password" minlength="6">
      <button type="button" class="password-toggle" aria-label="Tampilkan password">👁</button>
    </div>
  </div>
  
  <div class="form-group captcha-group">
    <label for="captcha">Kode Captcha</label>
    <div class="captcha-wrapper">
      <img src="api/captcha" alt="Captcha code" id="captcha-image" class="captcha-img">
      <button type="button" onclick="this.previousElementSibling.src='api/captcha?t='+Date.now()" 
              aria-label="Refresh captcha" class="captcha-refresh">🔄</button>
    </div>
    <input type="text" id="captcha" name="captcha" class="form-input"
           required autocomplete="off" maxlength="5" placeholder="Masukkan kode">
  </div>
  
  <button type="submit" class="btn btn-primary w-full">Masuk</button>
  
  <p class="auth-form__footer text-center text-muted">
    Belum punya akun? <a href="register">Daftar</a>
  </p>
</form>
```

```css
@layer components {
  .auth-form {
    max-width: 420px; margin: 0 auto; padding: var(--space-xl);
    background: var(--vibe-surface); border-radius: var(--radius-lg);
    border: 1px solid var(--vibe-border);
  }
  .auth-form__title { text-align: center; margin-bottom: var(--space-l); }
  .form-group { margin-bottom: var(--space-m); }
  .form-group label { display: block; font-weight: 500; margin-bottom: var(--space-xs); font-size: 0.875rem; }
  .input-password-wrapper { position: relative; }
  .password-toggle {
    position: absolute; right: var(--space-s); top: 50%; transform: translateY(-50%);
    background: none; border: none; cursor: pointer; font-size: 1.2rem;
    min-width: 44px; min-height: 44px;
  }
  .captcha-wrapper { display: flex; gap: var(--space-s); align-items: center; margin-bottom: var(--space-xs); }
  .captcha-img { height: 50px; border-radius: var(--radius-sm); }
  .captcha-refresh { background: none; border: none; cursor: pointer; font-size: 1.2rem; min-width: 44px; min-height: 44px; }
  .auth-form__footer { margin-top: var(--space-m); font-size: 0.875rem; }
}
```

Catatan: Password toggle JS: `document.querySelector('.password-toggle').addEventListener('click', (e) => { const input = e.target.previousElementSibling; input.type = input.type === 'password' ? 'text' : 'password'; });`

---

### [CS-011] Search Bar (Debounced + Accessible)
Stack: Universal HTML/CSS/JS
Kompleksitas: Simple

```html
<div class="search-bar" role="search">
  <label for="search-input" class="sr-only">Cari</label>
  <input type="search" id="search-input" class="form-input search-bar__input"
         placeholder="Ketik untuk mencari..." autocomplete="off">
  <span class="search-bar__icon" aria-hidden="true">🔍</span>
</div>
```

```css
@layer components {
  .search-bar { position: relative; max-width: 400px; }
  .search-bar__input { padding-left: 40px; }
  .search-bar__icon { position: absolute; left: var(--space-s); top: 50%; transform: translateY(-50%); pointer-events: none; }
}
```

```javascript
const searchInput = document.getElementById('search-input');
let debounceTimer;
searchInput.addEventListener('input', (e) => {
  clearTimeout(debounceTimer);
  debounceTimer = setTimeout(() => {
    const query = e.target.value.trim();
    if (query.length >= 2) performSearch(query);
  }, 300);
});
```
