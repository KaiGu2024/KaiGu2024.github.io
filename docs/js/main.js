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
