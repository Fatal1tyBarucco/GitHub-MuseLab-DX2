import { LightningElement, wire, track } from 'lwc';
import findAll from '@salesforce/apex/PropertyController.findAll';

const PAGE_SIZE = 8;

export default class PropertyTileList extends LightningElement {
    @track properties = [];
    page = 1;
    pages = 1;
    total = 0;
    searchKey = '';
    minPrice = 0;
    maxPrice = 10000000;

    connectedCallback() {
        this.loadProperties();
    }

    loadProperties(page = 1) {
        findAll({
            searchKey: this.searchKey,
            minPrice: this.minPrice,
            maxPrice: this.maxPrice,
            pageSize: PAGE_SIZE,
            pageNumber: page
        })
        .then(result => {
            this.properties = result.properties;
            this.page = result.page;
            this.total = result.total;
            this.pages = Math.ceil(result.total / PAGE_SIZE);
        })
        .catch(error => {
            console.error('Error loading properties:', error);
        });
    }

    handleRangeChange(event) {
        this.minPrice = event.detail.minValue;
        this.maxPrice = event.detail.maxValue;
        this.loadProperties();
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.detail.value;
        this.loadProperties();
    }

    handlePagePrevious() {
        this.loadProperties(this.page - 1);
    }

    handlePageNext() {
        this.loadProperties(this.page + 1);
    }

    handlePropertySelect(event) {
        // Dispatch event for parent components
        this.dispatchEvent(new CustomEvent('propertyselect', {
            detail: event.detail
        }));
    }
}
