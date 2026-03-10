// leadConvertButton.js
import { LightningElement, api, track } from 'lwc';
import convertLead from '@salesforce/apex/LeadConversionHandler.convertLeads';

export default class LeadConvertButton extends LightningElement {

    // The current Lead record Id passed in from the page
    @api recordId;

    // Reactive state
    @track isProcessing = false;   // true = button greyed out + disabled
    @track isSuccess    = false;
    @track errorMessage = null;

    // ── Computed properties ──────────────────────────────────────────────────

    get buttonLabel() {
        if (this.isProcessing) return 'Converting...';
        if (this.isSuccess)    return 'Converted ✓';
        return 'Convert Lead';
    }

    get buttonVariant() {
        // Stays "neutral" (grey) once processing or done
        if (this.isProcessing || this.isSuccess) return 'neutral';
        return 'brand'; // blue when ready
    }

    // ── Event Handler ────────────────────────────────────────────────────────

    handleConvert() {
        // 1. Immediately grey out the button
        this.isProcessing = true;
        this.errorMessage = null;
        this.isSuccess    = false;

        // 2. Call the Invocable Apex method directly
        convertLead({
            requests: [{
                leadId:                 this.recordId,
                doNotCreateOpportunity: false
            }]
        })
        .then(results => {
            const result = results[0];

            if (result.isSuccess) {
                this.isSuccess    = true;
                this.isProcessing = false;
                // Button stays greyed out (disabled=true via isSuccess check below)
            } else {
                this.errorMessage = result.errorMessage || 'Conversion failed.';
                this.isProcessing = false; // Re-enable so user can retry
            }
        })
        .catch(error => {
            this.errorMessage = error.body?.message || 'Unexpected error occurred.';
            this.isProcessing = false;
        });
    }

    // Keep button disabled after successful conversion — no double-converting
    get isDisabled() {
        return this.isProcessing || this.isSuccess;
    }
}
