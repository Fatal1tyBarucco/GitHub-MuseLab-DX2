import { LightningElement, api, track } from 'lwc';

export default class PictureCarousel extends LightningElement {
    @api slides = [];
    @track slideIndex = 0;
    slideWidth = 0;

    renderedCallback() {
        if (this.slideWidth === 0) {
            const gallery = this.template.querySelector('.gallery');
            if (gallery) {
                this.slideWidth = gallery.offsetWidth;
            }
        }
    }

    get filmstripStyle() {
        return `margin-left: -${this.slideIndex * this.slideWidth}px`;
    }

    get slideStyles() {
        return this.slides.map(slide => {
            return `width: ${this.slideWidth}px; background-image: url(${slide})`;
        });
    }

    get hasPrevious() {
        return this.slideIndex > 0;
    }

    get hasNext() {
        return this.slideIndex < this.slides.length - 1;
    }

    get prevButtonClass() {
        return this.slideWidth > 640 ? 'btn prev x-large' : 'btn prev';
    }

    get nextButtonClass() {
        return this.slideWidth > 640 ? 'btn next x-large' : 'btn next';
    }

    handlePrevious() {
        if (this.hasPrevious) {
            this.slideIndex--;
        }
    }

    handleNext() {
        if (this.hasNext) {
            this.slideIndex++;
        }
    }
}
