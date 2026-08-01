import { LightningElement, api, wire } from 'lwc';
import { getRecord, NavigationMixin } from 'lightning/uiRecordApi';
import getSimilarProperties from '@salesforce/apex/PropertyController.getSimilarProperties';

const FIELDS = [
    'Property__c.Id',
    'Property__c.Address__c',
    'Property__c.City__c',
    'Property__c.Price__c',
    'Property__c.Beds__c'
];

export default class SimilarProperties extends NavigationMixin(LightningElement) {
    @api recordId;
    @api searchCriteria = 'Price';
    property;
    similarProperties = [];
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredProperty({ error, data }) {
        if (data) {
            this.property = data;
            this.loadSimilarProperties();
        } else if (error) {
            this.error = error;
            console.error('Error loading property:', error);
        }
    }

    loadSimilarProperties() {
        if (!this.property) return;

        const bedrooms = this.property.fields.Beds__c?.value;
        const price = this.property.fields.Price__c?.value;

        getSimilarProperties({
            propertyId: this.recordId,
            bedrooms: bedrooms,
            price: price,
            searchCriteria: this.searchCriteria
        })
        .then(result => {
            this.similarProperties = result;
        })
        .catch(error => {
            this.error = error;
            console.error('Error loading similar properties:', error);
        });
    }

    get title() {
        return `Similar Properties by ${this.searchCriteria}`;
    }

    handleNavigateToRecord(event) {
        event.preventDefault();
        const recordId = event.currentTarget.dataset.recordId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    formatPrice(price) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            maximumFractionDigits: 0
        }).format(price || 0);
    }
}
