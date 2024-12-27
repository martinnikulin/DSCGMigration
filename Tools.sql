use DSCG_001

-- список объектов базы данных
--select		*
--from		sys.objects

-- список столбцов в таблицах
--select	*
--from	INFORMATION_SCHEMA.COLUMNS

-- текст представлений, функции, процедур в виде таблицы
--sp_helptext 'Export_AssayGroups'

-- текст представлений, функции, процедур в одну строчку
--select OBJECT_DEFINITION(OBJECT_ID('Export_Assaygroups')) 
--select [definition]
--from sys.sql_modules

-- полное определение объекта (sp_GetDDL - сторонняя процедура)
--exec sp_GetDDL 'Holes'


--insert into GDCS_System.dbo.MigrationTable (ObjectType, SchemaName, OldName)
--select	'Function' as ObjectType, 
--			SCHEMA_NAME(schema_id) AS [Schema],
--			[name] as OldName
--from		sys.objects
--where		schema_id <> 4 and
--			(type_desc = 'SQL_INLINE_TABLE_VALUED_FUNCTION' or
--			type_desc = 'SQL_TABLE_VALUED_FUNCTION' or
--			type_desc = 'SQL_SCALAR_FUNCTION')
--order by	name

--insert into	GDCS_System.dbo.MigrationTable (ObjectType, SchemaName, TableName, OldName, Action)
--select		'Column' as ObjectType,
--			table_schema as SchemaName,
--			table_name as TableName,
--			column_name as OldName,
--			'Rename' as Action
--from		INFORMATION_SCHEMA.COLUMNS
--order by	SchemaName, TableName, ordinal_position	

-- переименование столбца таблицы
--execute sp_rename N'dbo.Roles.description', N'rolename', 'COLUMN' 
