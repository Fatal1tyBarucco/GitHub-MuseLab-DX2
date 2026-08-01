import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PropertyTile extends NavigationMixin(LightningElement) {
    @api property;

    get thumbnailStyle() {
        return `background-image:url(${this.property?.Thumbnail__c})`;
    }

    get formattedPrice() {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            maximumFractionDigits: 0
        }).format(this.property?.Price__c || 0);
    }

    handleTileClick() {
        this.dispatchEvent(new CustomEvent('propertyselect', {
            detail: { propertyId: this.property?.Id },
            bubbles: true,
            composed: true
        }));
    }

    handleNavigateToRecord(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.property?.Id,
                actionName: 'view'
            }
        });
    }
}
