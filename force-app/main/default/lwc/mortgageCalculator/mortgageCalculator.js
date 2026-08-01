import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Property__c.Price__c'];

export default class MortgageCalculator extends LightningElement {
    @api recordId;
    principal = 200000;
    years = 30;
    rate = 5;
    monthlyPayment = 0;
    property;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredProperty({ error, data }) {
        if (data) {
            this.property = data;
            this.principal = data.fields.Price__c?.value || 200000;
            this.calculateMonthlyPayment();
        } else if (error) {
            console.error('Error loading property:', error);
        }
    }

    connectedCallback() {
        this.calculateMonthlyPayment();
    }

    get yearOptions() {
        return [
            { label: '20', value: 20 },
            { label: '25', value: 25 },
            { label: '30', value: 30 },
            { label: '35', value: 35 }
        ];
    }

    get formattedMonthlyPayment() {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(this.monthlyPayment || 0);
    }

    handlePrincipalChange(event) {
        this.principal = parseFloat(event.target.value) || 0;
        this.calculateMonthlyPayment();
    }

    handleYearsChange(event) {
        this.years = parseInt(event.target.value, 10);
        this.calculateMonthlyPayment();
    }

    handleRateChange(event) {
        this.rate = parseFloat(event.target.value) || 0;
        this.calculateMonthlyPayment();
    }

    calculateMonthlyPayment() {
        const principal = this.principal;
        const years = this.years;
        const rate = this.rate / 100 / 12;
        const payments = years * 12;

        if (rate === 0) {
            this.monthlyPayment = principal / payments;
        } else {
            this.monthlyPayment = principal * (rate * Math.pow(1 + rate, payments)) / (Math.pow(1 + rate, payments) - 1);
        }

        this.dispatchEvent(new CustomEvent('mortgagechange', {
            detail: {
                principal: this.principal,
                years: this.years,
                rate: this.rate,
                monthlyPayment: this.monthlyPayment
            }
        }));
    }
}
