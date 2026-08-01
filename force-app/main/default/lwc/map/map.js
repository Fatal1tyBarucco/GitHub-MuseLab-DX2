import { LightningElement, api, track } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/leaflet1';

export default class Map extends LightningElement {
    @api latitude;
    @api longitude;
    map;
    marker;
    jsLoaded = false;

    renderedCallback() {
        if (this.jsLoaded) return;

        Promise.all([
            loadStyle(this, leaflet + '/leaflet.css'),
            loadScript(this, leaflet + '/leaflet.js')
        ])
        .then(() => {
            this.jsLoaded = true;
            this.initializeMap();
        })
        .catch(error => {
            console.error('Error loading Leaflet:', error);
        });
    }

    initializeMap() {
        const mapContainer = this.template.querySelector('.map-container');
        if (!mapContainer) return;

        this.map = L.map(mapContainer).setView([this.latitude || 0, this.longitude || 0], 13);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(this.map);

        if (this.latitude && this.longitude) {
            this.updateMarker();
        }
    }

    @api
    setLocation(lat, long) {
        this.latitude = parseFloat(lat);
        this.longitude = parseFloat(long);

        if (this.map) {
            this.map.setView([this.latitude, this.longitude], 13);
            this.updateMarker();
        }
    }

    updateMarker() {
        if (!this.map) return;

        if (this.marker) {
            this.marker.setLatLng([this.latitude, this.longitude]);
        } else {
            this.marker = L.marker([this.latitude, this.longitude]).addTo(this.map);
        }
    }
}
