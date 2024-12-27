use DSCG_001

--sp_helptext 'Holes'

----SELECT OBJECT_DEFINITION(OBJECT_ID('Export_Assaygroups')) 

--SELECT [definition]
--FROM sys.sql_modules

SELECT		SCHEMA_NAME(schema_id) AS [Schema], *
FROM		sys.objects
where		schema_id <> 4 and
			(type_desc = 'SQL_STORED_PROCEDURE' or 
			type_desc = 'SQL_TABLE_VALUED_FUNCTION' or
			type_desc = 'SQL_INLINE_TABLE_VALUED_FUNCTION' or
			type_desc = 'SQL_SCALAR_FUNCTION' or
			type_desc = 'VIEW' or
			type_desc = 'SQL_TRIGGER')

--select distinct [type_desc] from sys.objects where schema_id <> 4

exec sp_GetDDL 'Holes'

BEGIN TRANSACTION
GO
EXECUTE sp_rename N'dbo.Roles.description', N'rolename', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Roles.Tmp_rolename_2', N'rolename', 'COLUMN' 
GO
ALTER TABLE dbo.Roles SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





