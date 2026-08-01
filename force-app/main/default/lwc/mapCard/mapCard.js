import { LightningElement, api, wire } from 'lwc';
import { getRecord, NavigationMixin } from 'lightning/uiRecordApi';

export default class MapCard extends NavigationMixin(LightningElement) {
    @api recordId;
    @api title = 'Location';
    @api latField = 'Location__Latitude__s';
    @api longField = 'Location__Longitude__s';
    @api titleField = 'Name';
    @api fields = ['Id'];

    sObject;
    fullScreen = false;

    get dynamicFields() {
        return this.fields.map(f => `${this.objectApiName}.${f}`);
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$dynamicFields' })
    wiredRecord({ error, data }) {
        if (data) {
            this.sObject = data;
            this.updateMap();
        } else if (error) {
            console.error('Error loading record:', error);
        }
    }

    get objectApiName() {
        return this.recordId ? this.recordId.substring(0, 3) : '';
    }

    get recordTitle() {
        return this.sObject?.fields?.[this.titleField]?.value || this.title;
    }

    get latitude() {
        return this.sObject?.fields?.[this.latField]?.value;
    }

    get longitude() {
        return this.sObject?.fields?.[this.longField]?.value;
    }

    get hasLocation() {
        return this.latitude != null && this.longitude != null;
    }

    updateMap() {
        if (!this.hasLocation) return;

        const mapComponent = this.template.querySelector('c-map');
        if (mapComponent) {
            mapComponent.setLocation(this.latitude, this.longitude);
        }
    }

    handleFullScreen() {
        this.fullScreen = true;
    }

    handleCloseDialog() {
        this.fullScreen = false;
    }

    @api
    setRecordId(id) {
        this.recordId = id;
    }
}
