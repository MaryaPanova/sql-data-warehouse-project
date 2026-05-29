/*
====================================================================
Quality Checks
====================================================================
Script Purpose:
  This script performs various quality checks for data consistency, 
  accuracy, and standartization across 'silver' schemas. It includes
  checks for:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standartization and consistency.
  - Invalid data ranges and orders.
  - Data consistency between related fields.

Usage Notes:
  - Run these checks after data loading Silver Layer.
  - Investigate and resolve any discrepancies found during the checks.
====================================================================
*/
