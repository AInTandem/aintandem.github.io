// AinTandem Website JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize AOS with custom settings for organic tech aesthetic
    AOS.init({
        duration: 800,
        easing: 'ease-out-cubic',
        once: false,
        offset: 100,
        delay: 50,
        disable: function() {
            // Disable AOS on mobile devices with small screens to improve performance
            return window.innerWidth < 768;
        }
    });
    
    console.log('AinTandem website loaded with AOS animations');
    
    // Smooth scrolling for navigation
    const links = document.querySelectorAll('a[href^="#"]');
    for (const link of links) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    }
});