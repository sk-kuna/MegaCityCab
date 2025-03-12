// Main JavaScript for MegaCity Cab Website

document.addEventListener('DOMContentLoaded', function() {
  // Navbar scroll effect
  const navbar = document.querySelector('.navbar');
  const menuToggle = document.querySelector('.menu-toggle');
  const navLinks = document.querySelector('.nav-links');
  const navItems = document.querySelectorAll('.nav-links li');
  
  // Set custom property for animation delay on nav items
  navItems.forEach((item, index) => {
    item.style.setProperty('--i', index);
  });

  // Navbar scroll effect
  window.addEventListener('scroll', function() {
    if (window.scrollY > 50) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  });

  // Mobile menu toggle
  menuToggle.addEventListener('click', function() {
    navLinks.classList.toggle('active');
    menuToggle.classList.toggle('active');
    
    // Toggle icon between bars and times
    if (menuToggle.classList.contains('active')) {
      menuToggle.innerHTML = '<i class="fas fa-times"></i>';
    } else {
      menuToggle.innerHTML = '<i class="fas fa-bars"></i>';
    }
  });

  // Close mobile menu when clicking on a nav link
  navLinks.addEventListener('click', function(e) {
    if (e.target.tagName === 'A') {
      navLinks.classList.remove('active');
      menuToggle.classList.remove('active');
      menuToggle.innerHTML = '<i class="fas fa-bars"></i>';
    }
  });

  // Scroll reveal animation
  const revealElements = document.querySelectorAll('.services-grid, .section-title, .steps-container, .footer-content');
  
  revealElements.forEach(el => {
    el.classList.add('reveal');
  });

  function revealOnScroll() {
    revealElements.forEach(element => {
      const elementTop = element.getBoundingClientRect().top;
      const windowHeight = window.innerHeight;
      
      if (elementTop < windowHeight - 100) {
        element.classList.add('active');
      }
    });
  }

  // Initial check on page load
  revealOnScroll();
  
  // Check on scroll
  window.addEventListener('scroll', revealOnScroll);

  // Pulse animation for call-to-action buttons
  const ctaButtons = document.querySelectorAll('.primary-btn');
  ctaButtons.forEach(button => {
    button.classList.add('animate-pulse');
  });

  // Newsletter form submission (prevent default for demo)
  const newsletterForm = document.querySelector('.newsletter-form');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const emailInput = this.querySelector('input[type="email"]');
      
      if (emailInput.value) {
        alert('Thank you for subscribing to our newsletter!');
        emailInput.value = '';
      }
    });
  }
});