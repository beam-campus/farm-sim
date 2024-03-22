import Swiper from 'swiper/bundle';


LandscapeCaroussel = {
    mounted() {
        document.addEventListener('DOMContentLoaded', function () {
            new Swiper('.swiper-container', {
                slidesPerView: '3',
                spaceBetween: 2, // Adjust as needed
                loop: true, // Enable looping
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
            });
        });
    }
}
