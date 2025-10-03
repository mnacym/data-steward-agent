# Data Dictionary - [Your Product Name]

**Last Updated**: [YYYY-MM-DD]
**Owner**: [Data Steward Name/Email]

---

## Overview

Brief description of your data model and architecture.

**Database**: [PostgreSQL | MySQL | MongoDB]
**Multi-tenancy**: [Schema-per-tenant | Row-level security | Database-per-tenant | Single-tenant]

---

## Table: users

**Purpose**: Store user account information and authentication details

**Owner**: Engineering Team
**Classification**: Sensitive (contains PII)

| Column | Type | Nullable | Default | Description | PII |
|--------|------|----------|---------|-------------|-----|
| id | UUID | No | gen_random_uuid() | Primary key | No |
| email | VARCHAR(255) | No | - | User email address | Yes |
| name | VARCHAR(255) | No | - | User full name | Yes |
| phone | VARCHAR(50) | Yes | NULL | Optional phone number | Yes |
| created_at | TIMESTAMPTZ | No | NOW() | Account creation timestamp | No |
| updated_at | TIMESTAMPTZ | No | NOW() | Last update timestamp | No |
| is_active | BOOLEAN | No | true | Account active status | No |

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE INDEX idx_users_email (email)
- INDEX idx_users_created_at (created_at)

**Relationships**:
- Has many: user_sessions
- Has many: [your_entities]

**Retention**: Account lifetime + 30 days post-deletion
**Deletion**: Cascade to related tables, anonymize in audit_logs

---

## Table: [your_entity]

**Purpose**: [What this table stores]

**Owner**: [Team Name]
**Classification**: [Public | Internal | Sensitive]

| Column | Type | Nullable | Default | Description | PII |
|--------|------|----------|---------|-------------|-----|
| id | UUID | No | gen_random_uuid() | Primary key | No |
| user_id | UUID | No | - | Foreign key to users | No |
| [field_name] | [TYPE] | [Yes/No] | [default] | [description] | [Yes/No] |
| created_at | TIMESTAMPTZ | No | NOW() | Creation timestamp | No |
| updated_at | TIMESTAMPTZ | No | NOW() | Last update timestamp | No |

**Indexes**:
- PRIMARY KEY (id)
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
- INDEX idx_[entity]_user_id (user_id)

**Relationships**:
- Belongs to: users
- Has many: [related_entities]

**Retention**: [Retention period]
**Deletion**: [Deletion strategy]

---

## Relationships Diagram

```
users (1) ──< (many) [your_entities]
  │
  └──< (many) user_sessions
  │
  └──< (many) [other_entities]
```

---

## Data Classification Summary

| Classification | Table Count | Examples |
|----------------|-------------|----------|
| Public | [count] | [table names] |
| Internal | [count] | [table names] |
| Sensitive | [count] | users, [others] |

---

## Multi-Tenancy Implementation

[If applicable, describe your multi-tenancy approach]

**Strategy**: Row-level security with tenant_id
**Isolation Method**: PostgreSQL Row Level Security (RLS) policies
**Tenant Identifier**: [Column name, e.g., team_id, organization_id]

---

## Compliance Notes

**GDPR**: Users table contains PII. Deletion procedure implemented and tested.
**CCPA**: User data export available via API endpoint /api/user/export
**Data Retention**: [Summary of retention policies]

---

## Change Log

| Date | Change | Author |
|------|--------|--------|
| [YYYY-MM-DD] | Initial data dictionary | [Name] |
| [YYYY-MM-DD] | Added [table_name] | [Name] |
