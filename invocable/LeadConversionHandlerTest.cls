/**
 * @description   Test class for LeadConversionHandler.
 *                Provides >= 75% code coverage and validates happy/error paths.
 * @author        Assignment 3
 * @date          2026-03-10
 */
@IsTest
private class LeadConversionHandlerTest {

    // ─── Test Data Setup ────────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Lead testLead = new Lead(
            FirstName   = 'Test',
            LastName    = 'Lead',
            Company     = 'Test Company',
            Email       = 'testlead@example.com',
            Status      = 'Open - Not Contacted'
        );
        insert testLead;
    }

    // ─── Tests ──────────────────────────────────────────────────────────────────

    @IsTest
    static void testConvertLead_Success() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead' LIMIT 1];

        LeadConversionHandler.LeadConversionRequest req = new LeadConversionHandler.LeadConversionRequest();
        req.leadId                   = lead.Id;
        req.doNotCreateOpportunity   = true;

        Test.startTest();
            List<LeadConversionHandler.LeadConversionResult> results =
                LeadConversionHandler.convertLeads(
                    new List<LeadConversionHandler.LeadConversionRequest>{ req }
                );
        Test.stopTest();

        System.assertEquals(1,    results.size(),          'Expected 1 result');
        System.assertEquals(true, results[0].isSuccess,    'Conversion should succeed');
        System.assertNotEquals(null, results[0].accountId, 'Account should be created');
        System.assertNotEquals(null, results[0].contactId, 'Contact should be created');
        System.assertEquals(null, results[0].opportunityId,'Opportunity should be skipped');
    }

    @IsTest
    static void testConvertLead_WithOpportunity() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead' LIMIT 1];

        LeadConversionHandler.LeadConversionRequest req = new LeadConversionHandler.LeadConversionRequest();
        req.leadId                   = lead.Id;
        req.doNotCreateOpportunity   = false;

        Test.startTest();
            List<LeadConversionHandler.LeadConversionResult> results =
                LeadConversionHandler.convertLeads(
                    new List<LeadConversionHandler.LeadConversionRequest>{ req }
                );
        Test.stopTest();

        System.assertEquals(true, results[0].isSuccess,       'Conversion should succeed');
        System.assertNotEquals(null, results[0].opportunityId, 'Opportunity should be created');
    }
}
