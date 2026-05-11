// Progress bar
const bar = document.getElementById('progress-bar');
window.addEventListener('scroll', () => {
  const scrolled = window.scrollY;
  const total = document.documentElement.scrollHeight - window.innerHeight;
  bar.style.width = total > 0 ? (scrolled / total * 100) + '%' : '0%';
});

// Mobile nav toggle
const toggle = document.querySelector('.nav-toggle');
const mobileNav = document.querySelector('.nav-mobile');
toggle.addEventListener('click', () => {
  mobileNav.classList.toggle('open');
});

// Close mobile nav on link click
mobileNav.querySelectorAll('a').forEach(a => {
  a.addEventListener('click', () => mobileNav.classList.remove('open'));
});

// Page-load + scroll-triggered staggered reveal.
// Elements with .reveal-up fade up from 14px when they enter the viewport.
// Above-the-fold elements intersect immediately on first paint, so the
// CSS --reveal-delay cascade plays out as a single orchestrated reveal.
const revealEls = document.querySelectorAll('.reveal-up');
if ('IntersectionObserver' in window && revealEls.length) {
  const io = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { rootMargin: '0px 0px -8% 0px', threshold: 0.05 });
  revealEls.forEach(el => io.observe(el));
} else {
  // No IntersectionObserver — show everything immediately.
  revealEls.forEach(el => el.classList.add('visible'));
}
