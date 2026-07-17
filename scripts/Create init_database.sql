/* ====================================================================
   Script Name: 01_Initialize_Datawarehouse.sql
   
   Purpose:     
   Initializes the core MS SQL Data Warehouse database and establishes 
   the Medallion Architecture schemas. This structure separates data 
   into distinct logical layers to support the end-to-end ETL/ELT 
   pipeline from raw ingestion to business-ready reporting.

   Architecture Layers:
   - Bronze Layer : Stores raw, untransformed source data.
   - Silver Layer : Stores cleansed, validated, and integrated data.
   - Gold Layer   : Stores dimensional models (Facts & Dimensions) 
                    optimized for BI, analytics, and reporting.
   ==================================================================== */

-- Switch to system master database to execute server-level commands
USE master;
GO

-- Create the central Data Warehouse database
CREATE DATABASE Datawarehouse;
GO

-- Switch context to the newly created database
USE Datawarehouse;
GO

-- ====================================================================
-- Schema Creation (Medallion Architecture Layers)
-- Note: In MS SQL Server, CREATE SCHEMA must be the first statement 
-- in a query batch, requiring GO separators between them.
-- ====================================================================

-- Bronze Layer: Raw, untransformed data ingestion
CREATE SCHEMA Bronze;
GO

-- Silver Layer: Cleansed, validated, and integrated data
CREATE SCHEMA Silver;
GO

-- Gold Layer: Business-ready, aggregated data optimized for reporting
CREATE SCHEMA Gold;
GO
