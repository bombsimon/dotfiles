-- login.sql
-- SQL*Plus user login startup file.
--
-- This script is automatically run after glogin.sql
-- Ensure it lives in ORACLE_PATH
--
-- First set the database date format to show the time.
ALTER SESSION
SET
  nls_date_format = 'HH:MI:SS';

-- SET the SQLPROMPT to include the _USER, _CONNECT_IDENTIFIER
-- and _DATE variables.
SET
  SQLPROMPT "_USER'@'_CONNECT_IDENTIFIER _DATE> "
SET
  PAGESIZE 1000
SET
  LINESIZE 250
SET
  HEADING ON
SET
  WRAP OFF
SET
  COLSEP " | "
SET
  FEEDBACK ON
