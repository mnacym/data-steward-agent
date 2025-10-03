-- Data Validation Queries
-- Run these regularly to ensure data integrity

-- ========================================
-- GATE 1: DATA INTEGRITY CHECKS
-- ========================================

-- Check for NULL values in required fields
-- Replace [table_name] and [required_column] with your actual tables/columns

SELECT 'users.email has nulls' as check_name, COUNT(*) as violations
FROM users WHERE email IS NULL
UNION ALL
SELECT 'users.name has nulls', COUNT(*)
FROM users WHERE name IS NULL
UNION ALL
SELECT '[table].[field] has nulls', COUNT(*)
FROM [table] WHERE [required_field] IS NULL;

-- Expected result: 0 violations for all checks

-- ========================================
-- Check for orphaned records (referential integrity)
-- ========================================

-- Example: Check for orphaned records in child table
SELECT 'Orphaned [child_table] records' as check_name, COUNT(*) as violations
FROM [child_table] c
LEFT JOIN [parent_table] p ON c.parent_id = p.id
WHERE p.id IS NULL;

-- Add more orphan checks for your foreign key relationships

-- Expected result: 0 violations

-- ========================================
-- Check for invalid email formats
-- ========================================

SELECT 'Invalid email formats' as check_name, COUNT(*) as violations
FROM users
WHERE email NOT LIKE '%_@__%.__%';

-- Expected result: 0 violations

-- ========================================
-- Check for duplicate records (if unique constraint missing)
-- ========================================

SELECT 'Duplicate emails' as check_name, COUNT(*) as violations
FROM (
  SELECT email, COUNT(*) as count
  FROM users
  GROUP BY email
  HAVING COUNT(*) > 1
) duplicates;

-- Expected result: 0 violations

-- ========================================
-- GATE 2: PRIVACY & SECURITY CHECKS
-- ========================================

-- Check that all users have valid consent/legal basis documented
-- (Assuming you have a consent tracking table)

SELECT 'Users without consent record' as check_name, COUNT(*) as violations
FROM users u
LEFT JOIN user_consents c ON u.id = c.user_id
WHERE c.id IS NULL;

-- Expected result: 0 violations (or adjust if consent is implicit)

-- ========================================
-- Check for PII in non-production environments
-- WARNING: Do NOT run this in production with actual PII values
-- ========================================

-- In staging/dev, check if real emails are present (they shouldn't be)
SELECT 'Real emails in non-prod' as check_name, COUNT(*) as violations
FROM users
WHERE email NOT LIKE '%test%'
  AND email NOT LIKE '%example%'
  AND email NOT LIKE '%@staging.%'
  AND email NOT LIKE '%@dev.%';

-- Expected result in non-prod: 0 violations

-- ========================================
-- GATE 3: CHANGE MANAGEMENT CHECKS
-- ========================================

-- Verify all tables have expected columns (detect unauthorized schema changes)
-- PostgreSQL version:

SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('users', '[your_table]', '[another_table]')
ORDER BY table_name, ordinal_position;

-- Compare output to your documented schema in data-dictionary.md

-- ========================================
-- Check for missing indexes on foreign keys
-- PostgreSQL version:
-- ========================================

SELECT 
  'Missing index on ' || t.relname || '.' || a.attname as check_name,
  1 as violations
FROM pg_constraint c
JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
JOIN pg_class t ON t.oid = c.conrelid
LEFT JOIN pg_index i ON i.indrelid = c.conrelid 
  AND a.attnum = ANY(i.indkey)
WHERE c.contype = 'f'
  AND i.indexrelid IS NULL
  AND t.relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');

-- Expected result: Empty result set (all FKs should have indexes)

-- ========================================
-- DATA QUALITY SUMMARY REPORT
-- ========================================

-- Run all checks and summarize
WITH all_checks AS (
  -- Required field checks
  SELECT 'required_fields' as category, COUNT(*) as total_violations
  FROM (
    SELECT COUNT(*) FROM users WHERE email IS NULL
    UNION ALL
    SELECT COUNT(*) FROM users WHERE name IS NULL
    -- Add your other required field checks
  ) t
  
  UNION ALL
  
  -- Orphaned records check
  SELECT 'referential_integrity', COUNT(*)
  FROM [child_table] c
  LEFT JOIN [parent_table] p ON c.parent_id = p.id
  WHERE p.id IS NULL
  
  UNION ALL
  
  -- Format validation check
  SELECT 'format_validation', COUNT(*)
  FROM users
  WHERE email NOT LIKE '%_@__%.__%'
)
SELECT 
  category,
  total_violations,
  CASE WHEN total_violations = 0 THEN '✅ PASS' ELSE '❌ FAIL' END as status
FROM all_checks;

-- Expected result: All categories show 0 violations and PASS status
