# User Data Deletion Test Checklist

**Test Date**: [YYYY-MM-DD]
**Tester**: [Your Name]
**Environment**: [Staging/Production]

---

## Purpose

Verify that user data can be completely deleted in compliance with GDPR Article 17 (Right to Erasure) and CCPA deletion requirements.

---

## Pre-Test Setup

- [ ] Create test user account
- [ ] Record test user ID: `[USER_ID]`
- [ ] Create associated data (content, activity, etc.)
- [ ] Document expected data locations

---

## Data Inventory for Test User

List all tables containing test user data:

| Table | Record Count Before | Primary Key / Foreign Key |
|-------|---------------------|---------------------------|
| users | 1 | id = [USER_ID] |
| [table_2] | [count] | user_id = [USER_ID] |
| [table_3] | [count] | created_by = [USER_ID] |
| [add_more] | [count] | [relationship] |

---

## Deletion Process Test

### Step 1: Execute Deletion
```sql
-- Run your deletion procedure
-- Example:
BEGIN;

-- Delete user content
DELETE FROM user_content WHERE user_id = '[USER_ID]';

-- Delete user associations
DELETE FROM user_associations WHERE user_id = '[USER_ID]';

-- Delete user account
DELETE FROM users WHERE id = '[USER_ID]';

-- Anonymize audit logs (do NOT delete)
UPDATE audit_logs 
SET user_email = 'DELETED_USER',
    user_id = NULL
WHERE user_id = '[USER_ID]';

COMMIT;
```

**Execution Time**: [Duration]
**Errors Encountered**: [None or describe]

---

### Step 2: Verify Deletion Completeness

Run verification queries for each table:

```sql
-- Check users table
SELECT COUNT(*) FROM users WHERE id = '[USER_ID]';
-- Expected: 0

-- Check user content
SELECT COUNT(*) FROM user_content WHERE user_id = '[USER_ID]';
-- Expected: 0

-- Check associations
SELECT COUNT(*) FROM user_associations WHERE user_id = '[USER_ID]';
-- Expected: 0

-- Add queries for all tables with user data
```

**Results**:
- [ ] User record deleted
- [ ] All user content deleted
- [ ] All associations deleted
- [ ] Audit logs anonymized (not deleted)

---

### Step 3: Check for Orphaned Records

```sql
-- Look for records that should have been cascade deleted
SELECT table_name, column_name, COUNT(*) as orphaned_count
FROM (
  -- Add queries for each foreign key relationship
  SELECT 'table_name' as table_name, 
         'user_id' as column_name,
         COUNT(*) 
  FROM table_name 
  WHERE user_id = '[USER_ID]'
  
  -- Repeat for other tables
) orphan_check
WHERE count > 0;
```

**Orphaned Records Found**: [Count]
**Details**: [None or list tables with orphans]

---

### Step 4: Verify Application Behavior

Test that the application handles deleted user correctly:

- [ ] Cannot log in with deleted user credentials
- [ ] User profile page returns 404 or appropriate error
- [ ] References to user in other records show as "Deleted User" or similar
- [ ] No errors logged from foreign key violations
- [ ] No broken links or 500 errors

**Issues Found**: [None or describe]

---

## Retention Requirements Check

Verify that data required for legal retention is properly handled:

| Data Type | Retention Required | Properly Handled |
|-----------|-------------------|------------------|
| Audit logs | 7 years | ✅ Anonymized, not deleted |
| Financial records | [X years] | ✅ [Status] |
| Legal hold data | Until released | ✅ [Status] |

---

## Data Export Verification (Right to Portability)

Before deletion, verify user can export their data:

- [ ] Export functionality tested
- [ ] Export contains all user data
- [ ] Export format is machine-readable (JSON/CSV)
- [ ] Export delivered within SLA (typically 30 days)

**Export File**: [Link or filename]
**Export Completeness**: [✅ Complete | ⚠️ Issues found]

---

## Test Results Summary

**Overall Result**: [✅ PASS | ❌ FAIL]

**Deletion Completeness**: [✅ All data deleted | ⚠️ Some data remains]

**Issues Identified**:
1. [Issue description or "None"]
2. [Issue description or "None"]

**Remediation Required**:
- [ ] No remediation needed
- [ ] Fix required (describe below)

---

## Rollback Test

Verify that deletion is irreversible (as required by GDPR):

- [ ] Attempted to restore deleted user: [✅ Cannot restore | ❌ Restoration possible]
- [ ] Backups reviewed: [User data in backup but flagged as deleted]

---

## Production Deployment Readiness

- [ ] Deletion procedure tested successfully
- [ ] No orphaned records created
- [ ] Application handles deletion gracefully
- [ ] Audit trail properly maintained
- [ ] Export functionality verified
- [ ] Rollback/restore properly blocked

**Ready for Production**: [Yes/No]

**Approver**: [Name]
**Approval Date**: [YYYY-MM-DD]

---

## Notes

[Any additional observations, edge cases discovered, or recommendations]
