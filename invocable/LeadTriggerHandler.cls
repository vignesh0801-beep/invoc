/**
 * @description   Handler class for LeadTrigger.
 *                Implements the TriggerHandler framework pattern:
 *                each trigger context has its own dedicated method.
 * @author        Assignment 3
 * @date          2026-03-10
 */
public with sharing class LeadTriggerHandler {

    // ─── Entry Point ────────────────────────────────────────────────────────────

    /**
     * @description Routes execution to the correct context method.
     */
    public void run() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert)  { onBeforeInsert(Trigger.new); }
            if (Trigger.isUpdate)  { onBeforeUpdate(Trigger.new, Trigger.oldMap); }
            if (Trigger.isDelete)  { onBeforeDelete(Trigger.old); }
        }

        if (Trigger.isAfter) {
            if (Trigger.isInsert)   { onAfterInsert(Trigger.new); }
            if (Trigger.isUpdate)   { onAfterUpdate(Trigger.new, Trigger.oldMap); }
            if (Trigger.isDelete)   { onAfterDelete(Trigger.old); }
            if (Trigger.isUndelete) { onAfterUndelete(Trigger.new); }
        }
    }

    // ─── Before Contexts ────────────────────────────────────────────────────────

    /**
     * @description Before Insert — runs before new Lead records are saved.
     * @param  newLeads  List of new Lead records (not yet committed)
     */
    private void onBeforeInsert(List<Lead> newLeads) {
        // TODO: Add before-insert logic here.
        // Example: setDefaultLeadSource(newLeads);
    }

    /**
     * @description Before Update — runs before existing Lead records are updated.
     * @param  newLeads  List of updated Lead records (new values)
     * @param  oldMap    Map of Lead Id → old Lead record values
     */
    private void onBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        // TODO: Add before-update logic here.
        // Example: validateStatusTransition(newLeads, oldMap);
    }

    /**
     * @description Before Delete — runs before Lead records are deleted.
     * @param  oldLeads  List of Lead records about to be deleted
     */
    private void onBeforeDelete(List<Lead> oldLeads) {
        // TODO: Add before-delete logic here.
    }

    // ─── After Contexts ─────────────────────────────────────────────────────────

    /**
     * @description After Insert — runs after new Lead records are committed.
     * @param  newLeads  List of newly inserted Lead records (with IDs)
     */
    private void onAfterInsert(List<Lead> newLeads) {
        // TODO: Add after-insert logic here.
        // Example: sendWelcomeNotification(newLeads);
    }

    /**
     * @description After Update — runs after existing Lead records are updated.
     * @param  newLeads  List of updated Lead records (new values, with IDs)
     * @param  oldMap    Map of Lead Id → old Lead record values
     */
    private void onAfterUpdate(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        // TODO: Add after-update logic here.
    }

    /**
     * @description After Delete — runs after Lead records are deleted.
     * @param  oldLeads  List of deleted Lead records
     */
    private void onAfterDelete(List<Lead> oldLeads) {
        // TODO: Add after-delete logic here.
    }

    /**
     * @description After Undelete — runs after Lead records are restored from the Recycle Bin.
     * @param  newLeads  List of undeleted Lead records
     */
    private void onAfterUndelete(List<Lead> newLeads) {
        // TODO: Add after-undelete logic here.
    }
}
