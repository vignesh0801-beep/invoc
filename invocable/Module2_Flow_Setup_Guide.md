# Assignment 3 – Module 2: Screen Flow + Quick Action Setup Guide

## Overview
After deploying the Apex files, follow these steps in Salesforce Setup to complete Module 2.

---

## Step 1 – Create the Screen Flow

1. Go to **Setup → Process Automation → Flows → New Flow**
2. Select **Screen Flow** → Click **Create**

### Screen 1 — Display Lead Details (Validation Screen)

3. Add a **Screen** element. Label it: `Confirm Lead Conversion`
4. Inside the screen, add **Display Text** components to show Lead fields:
   - Use a **Get Records** element *before* the screen to fetch the Lead:
     - Object: `Lead`
     - Filter: `Id = {!recordId}` (recordId is the Input Variable — see Step 1a)
   - Display fields such as: `Name`, `Company`, `Email`, `Phone`, `Status`, `LeadSource`
5. Add a **Checkbox** field: "Skip Opportunity Creation?" (API: `doNotCreateOpportunity`)

### Step 1a — Input Variable
- Add a Flow Variable:
  - **API Name:** `recordId`
  - **Data Type:** Text
  - **Available for Input:** ✅ (checked)

---

### Screen 2 — Confirmation (optional)
- Add a confirmation screen: "Lead will now be converted. Click Finish to proceed."

---

## Step 2 — Call the Invocable Apex Action

1. After the screen, add an **Action** element
2. Search for: **Convert Lead** (the `@InvocableMethod` label)
3. Map inputs:
   | Flow Variable | Apex Input Variable |
   |---|---|
   | `{!Get_Lead.Id}` | `leadId` |
   | `{!doNotCreateOpportunity}` | `doNotCreateOpportunity` |
4. Map outputs (store results in Flow variables):
   | Apex Output | Flow Variable |
   |---|---|
   | `isSuccess` | `varIsSuccess` |
   | `accountId` | `varAccountId` |
   | `contactId` | `varContactId` |
   | `errorMessage` | `varErrorMessage` |

---

## Step 3 — Add Decision & Fault Handling

1. After the Action, add a **Decision** element:
   - **Outcome "Success":** `{!varIsSuccess} = true`
   - **Default Outcome "Failure":** show a screen with `{!varErrorMessage}`

---

## Step 4 — Save & Activate the Flow

- **Flow Label:** `Lead Conversion Screen Flow`
- **API Name:** `Lead_Conversion_Screen_Flow`
- Click **Save** → **Activate**

---

## Step 5 — Create a Quick Action on Lead

1. Go to **Setup → Object Manager → Lead → Buttons, Links, and Actions → New Action**
2. Fill in:
   | Field | Value |
   |---|---|
   | Action Type | `Flow` |
   | Flow | `Lead Conversion Screen Flow` |
   | Label | `Convert Lead` |
   | Name | `Convert_Lead` |
3. Click **Save**

---

## Step 6 — Add Quick Action to Lead Page Layout

1. Go to **Setup → Object Manager → Lead → Page Layouts**
2. Open the relevant layout (e.g., `Lead Layout`)
3. In the palette, click **Mobile & Lightning Actions**
4. Drag **Convert Lead** action into the **Salesforce Mobile and Lightning Experience Actions** section
5. Click **Save**

---

## File Summary

| File | Purpose |
|---|---|
| `LeadTrigger.trigger` | Thin trigger — delegates to handler |
| `LeadTriggerHandler.cls` | All trigger logic, one method per context |
| `LeadConversionHandler.cls` | `@InvocableMethod` — called by the Flow |
| `LeadConversionHandlerTest.cls` | Unit tests (≥75% coverage) |
