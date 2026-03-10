/**
 * @description   Trigger on the Lead object.
 *                Follows single-trigger pattern — all logic delegated to LeadTriggerHandler.
 * @author        Assignment 3
 * @date          2026-03-10
 */
trigger LeadTrigger on Lead (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    new LeadTriggerHandler().run();
}
