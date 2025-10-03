# Schema Change Request

**Date**: [YYYY-MM-DD]
**Ticket/Issue**: [Link to issue tracker]
**Author**: [Your Name]
**Reviewer**: [Reviewer Name]

---

## Change Summary

Brief description of what's changing in 1-2 sentences.

---

## Tables Affected

- [ ] `table_name` - [Brief description of change]
- [ ] `another_table` - [Brief description of change]

---

## Detailed Changes

### Adding Columns
```sql
ALTER TABLE table_name 
ADD COLUMN new_column VARCHAR(255) NOT NULL DEFAULT 'value';
```

### Modifying Columns
```sql
ALTER TABLE table_name 
ALTER COLUMN existing_column TYPE TEXT;
```

### Removing Columns
```sql
ALTER TABLE table_name 
DROP COLUMN old_column;
```

### Adding Indexes
```sql
CREATE INDEX idx_table_column ON table_name(column_name);
```

### Other Changes
[Describe any other schema modifications]

---

## Reason for Change

Why is this change necessary? What problem does it solve or what feature does it enable?

---

## Impact Assessment

### Breaking Changes
- [ ] No breaking changes
- [ ] Breaking changes (describe below)

If breaking changes:
- Which queries will break: [List specific queries or "None"]
- Which application code needs updates: [List files/modules]
- API changes required: [List endpoints affected]

### Data Migration Required
- [ ] No data migration needed
- [ ] Data migration required (script below)

If migration required:
```sql
-- Data migration script
UPDATE table_name 
SET new_column = old_column 
WHERE condition;
```

### Performance Impact
- [ ] No performance impact expected
- [ ] Performance impact possible (describe below)

If performance impact:
- Estimated impact: [Positive/Negative]
- Mitigation: [What you'll do to address]

---

## Backward Compatibility

- [ ] Fully backward compatible
- [ ] Requires application code deployment first
- [ ] Requires coordinated deployment

Deployment notes:
[Describe deployment sequence if coordination required]

---

## Migration Scripts

### Forward Migration
File: `migrations/YYYYMMDD_description_up.sql`

```sql
-- Forward migration
BEGIN;

-- Your migration SQL here

COMMIT;
```

### Rollback Script
File: `migrations/YYYYMMDD_description_down.sql`

```sql
-- Rollback migration
BEGIN;

-- Your rollback SQL here

COMMIT;
```

---

## Testing

### Test Environment
- [ ] Tested on local development database
- [ ] Tested on staging database
- [ ] Rollback tested and verified

### Test Results
```
[Paste test output or describe test results]
```

### Data Integrity Validation
After migration, verify:
- [ ] No orphaned records created
- [ ] All required fields populated
- [ ] Referential integrity maintained
- [ ] Application functions correctly

Validation queries:
```sql
-- Check for nulls in required fields
SELECT COUNT(*) FROM table_name WHERE new_column IS NULL;
-- Expected: 0

-- Check for orphaned records
SELECT COUNT(*) FROM child_table c
LEFT JOIN parent_table p ON c.parent_id = p.id
WHERE p.id IS NULL;
-- Expected: 0
```

---

## Approvals

- [ ] Technical review completed by: [Reviewer Name]
- [ ] Data steward review completed by: [Steward Name]
- [ ] Product owner approval: [PO Name]

**Approval Date**: [YYYY-MM-DD]

---

## Deployment Plan

**Scheduled Deployment**: [YYYY-MM-DD HH:MM Timezone]

**Steps**:
1. Announce maintenance window (if required)
2. Create database backup
3. Run forward migration
4. Deploy application code (if required)
5. Verify data integrity
6. Monitor for issues

**Rollback Plan**:
If issues detected:
1. Run rollback script
2. Redeploy previous application version
3. Verify system stability
4. Conduct post-mortem

---

## Post-Deployment

**Deployed**: [YYYY-MM-DD HH:MM Timezone]
**Deployed By**: [Name]

**Verification**:
- [ ] Migration completed successfully
- [ ] Data integrity checks passed
- [ ] Application functioning normally
- [ ] Performance within acceptable range

**Issues Encountered**: [None or describe issues]

**Rollback Required**: [Yes/No]

---

## Notes

[Any additional context, caveats, or future considerations]
