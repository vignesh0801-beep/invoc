import { LightningElement, api, track } from 'lwc';
import convertLead from '@salesforce/apex/LeadConversionHandler.convertLeads';

export default class LeadConvertButton extends LightningElement {

    @api recordId;

    @track isProcessing = false;
    @track isSuccess    = false;
    @track errorMessage = null;

    get buttonLabel() {
        if (this.isProcessing) return 'Converting...';
        if (this.isSuccess)    return 'Converted ✓';
        return 'Convert Lead';
    }

    get buttonVariant() {
        if (this.isProcessing || this.isSuccess) return 'neutral';
        return 'brand';
    }

    handleConvert() {
        this.isProcessing = true;
        this.errorMessage = null;
        this.isSuccess    = false;

        convertLead({ leadId: this.recordId })
        .then(result => {
            if (result.isSuccess) {
                this.isSuccess    = true;
                this.isProcessing = false;
            } else {
                this.errorMessage = result.errorMessage || 'Conversion failed.';
                this.isProcessing = false;
            }
        })
        .catch(error => {
            this.errorMessage = error.body?.message || 'Unexpected error occurred.';
            this.isProcessing = false;
        });
    }

    get isDisabled() {
        return this.isProcessing || this.isSuccess;
    }
}
