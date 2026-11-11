CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN 
    DECLARE @start_time DATETIME, @end_time DATETIME,@batch_starttime DATETIME,@batch_endtime DATETIME
BEGIN TRY
  PRINT '======================================================================================================'
  PRINT 'Loading Bronze Layer';
  PRINT '======================================================================================================'

  PRINT '-------------------------------------------------------------------------------------------------------'
  PRINT 'Loading CRM Tables';
  PRINT '-------------------------------------------------------------------------------------------------------'

  SET @start_time = GETDATE();
  PRINT '>>>>> Truncating Table: bronze.crm_cust_info; '
  TRUNCATE TABLE bronze.crm_cust_info;

  PRINT '>>>>> Inserting Data into: bronze.crm_cust_info; '
  BULK INSERT bronze.crm_cust_info
  FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\cust_info.csv'
  WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
  
);
  SET @end_time = GETDATE() 
  PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'


  SET @start_time = GETDATE();
  PRINT '>>> Trunctating table crm_prd_info;' 
  TRUNCATE TABLE bronze.crm_prd_info;

  PRINT '>> Inserting Data into crm_prd_info'
  BULK INSERT bronze.crm_prd_info
  FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\prd_info.csv'
  WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = GETDATE() 
PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'

  SET @start_time = GETDATE();
  PRINT '>>>> Trunctating Table crm_sales_details '
  TRUNCATE TABLE bronze.crm_sales_details;

  PRINT'Inserting Data into crm_sales_details'
  BULK INSERT bronze.crm_sales_details
  FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\sales_details.csv'
  WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
  SET @end_time = GETDATE() 
  PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'

  PRINT '----------------------------------------------------------------------------------------------------------------------'
  PRINT 'Loading ERP Tables';
  PRINT '----------------------------------------------------------------------------------------------------------------------'

  SET @start_time = GETDATE();
  PRINT'Trunctating Table loc_a101 '
  TRUNCATE TABLE bronze.erp_loc_a101;

  PRINT'Insert into Table loc_a101 '
  BULK INSERT bronze.erp_loc_a101
  FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\loc_a101.csv'
  WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

SET @end_time = GETDATE() 
PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'
  SET @start_time = GETDATE();
  PRINT'Trunctating Table cust_az12 '
  TRUNCATE TABLE bronze.erp_cust_az12;

  PRINT'Inserting Data into cust_az12'
  BULK INSERT bronze.erp_cust_az12
  FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\cust_az12.csv'
  WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

SET @end_time = GETDATE() 
PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'

SET @start_time = GETDATE();
PRINT'Trunctating Data into cat_g1v2 '
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

PRINT'Inserting Data into cat_g1v2'
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\DELL\Desktop\Data Warehouse Load\px_cat_g1v2.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
SET @end_time = GETDATE() 
 PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds'

 SET @batch_endtime = GETDATE();
 PRINT '============================================================================================'
 PRINT 'Loading Bronze Layer is completed'
 PRINT 'Total load Duration ' + CAST(DATEDIFF(SECOND,@batch_starttime,@batch_endtime) AS NVARCHAR) + 'seconds';
 PRINT '============================================================================================'

END TRY
BEGIN CATCH
    PRINT '==========================================================================================='
    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
    PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
    PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR);
    PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
    PRINT '=========================================================================================='
END CATCH
END 


 



