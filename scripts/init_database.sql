/*
================================================================
Create Database and Schemas
================================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse'
    after checking whether it already exists.

    If the database already exists, it will be dropped and
    recreated to ensure a clean environment.

    Additionally, the script creates three schemas within
    the database to support the Medallion Architecture:

        - bronze: Stores raw data ingested from source systems.
        - silver: Stores cleaned, transformed and validated data.
        - gold: Stores business-ready data for reporting and analytics.

WARNING:
    Running this script will drop the entire 'DataWarehouse'
    database if it already exists.

    All existing data and database objects will be permanently
    deleted.

    Proceed with caution and ensure that you have proper
    backups before executing this script.

================================================================
*/


-------- Create Database DataWarehouse----
USE master;

----Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP DATABASE DataWarehouse;
END;
GO


  -----Create the 'DataWarehouse' database
  
CREATE DATABASE DataWarehouse;
GO

USE [DataWarehouse];
GO

--Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
