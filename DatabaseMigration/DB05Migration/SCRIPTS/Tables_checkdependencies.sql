SELECT top 10
    referencing_object_name = OBJECT_NAME(sed.referencing_id),
    sed.referencing_class_desc,
    sed.is_schema_bound_reference,
    sed.referenced_class_desc,
    sed.referenced_schema_name,
    sed.referenced_entity_name
FROM sys.sql_expression_dependencies AS sed
WHERE  sed.referenced_id = OBJECT_ID('dbo.WriteLog_UserLog') 
	AND OBJECT_NAME(sed.referencing_id) not like '%xtest'
	And OBJECT_NAME(sed.referencing_id) not like '%xpre'
	AND OBJECT_NAME(sed.referencing_id) not like '%uat'
	AND OBJECT_NAME(sed.referencing_id) not like 'sp_MS%'
