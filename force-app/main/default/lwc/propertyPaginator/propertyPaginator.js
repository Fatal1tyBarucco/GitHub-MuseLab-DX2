import { LightningElement, api } from 'lwc';

export default class PropertyPaginator extends LightningElement {
    @api page;
    @api pages;
    @api total;

    get hasPrevious() {
        return this.page > 1;
    }

    get hasNext() {
        return this.page < this.pages;
    }

    get summaryText() {
        return `${this.total} properties • page ${this.page} of ${this.pages}`;
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('pageprevious'));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent('pagenext'));
    }
}
