/**
 * @description   Invocable Apex class to handle Lead conversion.
 *                Called from a Screen Flow via an Invocable Action.
 * @author        Assignment 3
 * @date          2026-03-10
 */
public with sharing class LeadConversionHandler {

    /**
     * @description Wrapper class used as input from the Flow.
     */
    public class LeadConversionRequest {
        @InvocableVariable(label='Lead ID' description='The ID of the Lead to convert' required=true)
        public Id leadId;

        @InvocableVariable(label='Convert Without Opportunity' description='Set true to skip Opportunity creation')
        public Boolean doNotCreateOpportunity;
    }

    /**
     * @description Wrapper class used as output back to the Flow.
     */
    public class LeadConversionResult {
        @InvocableVariable(label='Is Success')
        public Boolean isSuccess;

        @InvocableVariable(label='Account ID')
        public Id accountId;

        @InvocableVariable(label='Contact ID')
        public Id contactId;

        @InvocableVariable(label='Opportunity ID')
        public Id opportunityId;

        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }

    /**
     * @description Invocable method called by Flow to convert a Lead.
     * @param  requests  List of LeadConversionRequest from the Flow
     * @return           List of LeadConversionResult sent back to the Flow
     */
    @InvocableMethod(
        label='Convert Lead'
        description='Converts a Salesforce Lead into Account, Contact, and optionally Opportunity.'
        category='Lead'
    )
    public static List<LeadConversionResult> convertLeads(List<LeadConversionRequest> requests) {
        List<LeadConversionResult> results = new List<LeadConversionResult>();

        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        LeadStatus convertedStatus = [
            SELECT MasterLabel
            FROM   LeadStatus
            WHERE  IsConverted = TRUE
            LIMIT  1
        ];

        for (LeadConversionRequest req : requests) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(req.leadId);
            lc.setConvertedStatus(convertedStatus.MasterLabel);
            lc.setDoNotCreateOpportunity(req.doNotCreateOpportunity != null && req.doNotCreateOpportunity);
            leadConverts.add(lc);
        }

        List<Database.LeadConvertResult> lcResults = Database.convertLead(leadConverts, false);

        for (Database.LeadConvertResult lcr : lcResults) {
            LeadConversionResult result = new LeadConversionResult();
            result.isSuccess      = lcr.isSuccess();
            result.accountId      = lcr.getAccountId();
            result.contactId      = lcr.getContactId();
            result.opportunityId  = lcr.getOpportunityId();

            if (!lcr.isSuccess()) {
                List<String> errors = new List<String>();
                for (Database.Error err : lcr.getErrors()) {
                    errors.add(err.getMessage());
                }
                result.errorMessage = String.join(errors, '; ');
            }

            results.add(result);
        }

        return results;
    }
}
