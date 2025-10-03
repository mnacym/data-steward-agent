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

Modifying Columns
ALTER TABLE table_name 
ALTER COLUMN existing_column TYPE TEXT;
