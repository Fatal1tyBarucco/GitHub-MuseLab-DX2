import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

const FIELDS = [
    'Property__c.Id',
    'Property__c.Thumbnail__c',
    'Property__c.Address__c',
    'Property__c.City__c',
    'Property__c.Price__c',
    'Property__c.Beds__c',
    'Property__c.Baths__c',
    'Property__c.Date_Listed__c'
];

export default class PropertySummary extends NavigationMixin(LightningElement) {
    @api recordId;
    property;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredProperty({ error, data }) {
        if (data) {
            this.property = data;
        } else if (error) {
            console.error('Error loading property:', error);
        }
    }

    get hasRecord() {
        return this.recordId != null;
    }

    get thumbnail() {
        return this.property?.fields?.Thumbnail__c?.value;
    }

    get address() {
        return this.property?.fields?.Address__c?.value;
    }

    get city() {
        return this.property?.fields?.City__c?.value;
    }

    get beds() {
        return this.property?.fields?.Beds__c?.value;
    }

    get baths() {
        return this.property?.fields?.Baths__c?.value;
    }

    get dateListed() {
        return this.property?.fields?.Date_Listed__c?.value;
    }

    get formattedPrice() {
        const price = this.property?.fields?.Price__c?.value;
        return price ? new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            maximumFractionDigits: 0
        }).format(price) : '';
    }

    handleEdit() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'edit'
            }
        });
    }

    @api
    setRecordId(id) {
        this.recordId = id;
    }
}
