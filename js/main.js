// AinTandem Website JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Add any interactive elements here if needed
    console.log('AinTandem website loaded');
    
    // Add smooth scrolling for navigation if we add it later
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