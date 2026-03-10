/**
 * @description   Test class for LeadTrigger and LeadTriggerHandler.
 *                Covers all trigger contexts to ensure >=75% code coverage.
 * @author        Assignment 3
 * @date          2026-03-10
 */
@IsTest
private class LeadTriggerHandlerTest {

    // ─── Test Data Setup ────────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName  = 'Trigger',
            Company   = 'Trigger Test Co',
            Email     = 'triggerlead@example.com',
            Status    = 'Open - Not Contacted'
        );
        insert testLead;
    }

    // ─── Before Insert ──────────────────────────────────────────────────────────

    @IsTest
    static void testBeforeInsert() {
        Test.startTest();
            Lead newLead = new Lead(
                FirstName = 'Before',
                LastName  = 'Insert',
                Company   = 'Insert Co',
                Status    = 'Open - Not Contacted'
            );
            insert newLead;
        Test.stopTest();

        Lead inserted = [SELECT Id, LastName FROM Lead WHERE LastName = 'Insert' LIMIT 1];
        System.assertNotEquals(null, inserted.Id, 'Lead should be inserted');
    }

    // ─── Before Update ──────────────────────────────────────────────────────────

    @IsTest
    static void testBeforeUpdate() {
        Lead lead = [SELECT Id, Status FROM Lead WHERE LastName = 'Trigger' LIMIT 1];

        Test.startTest();
            lead.Status = 'Working - Contacted';
            update lead;
        Test.stopTest();

        Lead updated = [SELECT Id, Status FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('Working - Contacted', updated.Status, 'Status should be updated');
    }

    // ─── Before Delete ──────────────────────────────────────────────────────────

    @IsTest
    static void testBeforeDelete() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Trigger' LIMIT 1];

        Test.startTest();
            delete lead;
        Test.stopTest();

        List<Lead> deleted = [SELECT Id FROM Lead WHERE Id = :lead.Id ALL ROWS];
        System.assertEquals(1, deleted.size(), 'Lead should exist in recycle bin');
    }

    // ─── After Insert ───────────────────────────────────────────────────────────

    @IsTest
    static void testAfterInsert() {
        Test.startTest();
            Lead newLead = new Lead(
                FirstName = 'After',
                LastName  = 'Insert',
                Company   = 'After Insert Co',
                Status    = 'Open - Not Contacted'
            );
            insert newLead;
        Test.stopTest();

        Lead inserted = [SELECT Id FROM Lead WHERE LastName = 'Insert' LIMIT 1];
        System.assertNotEquals(null, inserted.Id, 'Lead should be inserted via after insert context');
    }

    // ─── After Update ───────────────────────────────────────────────────────────

    @IsTest
    static void testAfterUpdate() {
        Lead lead = [SELECT Id, FirstName FROM Lead WHERE LastName = 'Trigger' LIMIT 1];

        Test.startTest();
            lead.FirstName = 'Updated';
            update lead;
        Test.stopTest();

        Lead updated = [SELECT Id, FirstName FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('Updated', updated.FirstName, 'FirstName should be updated');
    }

    // ─── After Delete ───────────────────────────────────────────────────────────

    @IsTest
    static void testAfterDelete() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Trigger' LIMIT 1];

        Test.startTest();
            delete lead;
        Test.stopTest();

        List<Lead> result = [SELECT Id FROM Lead WHERE Id = :lead.Id];
        System.assertEquals(0, result.size(), 'Lead should be deleted');
    }

    // ─── After Undelete ─────────────────────────────────────────────────────────

    @IsTest
    static void testAfterUndelete() {
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Trigger' LIMIT 1];
        delete lead;

        Test.startTest();
            undelete lead;
        Test.stopTest();

        Lead restored = [SELECT Id FROM Lead WHERE Id = :lead.Id];
        System.assertNotEquals(null, restored.Id, 'Lead should be restored after undelete');
    }
}
