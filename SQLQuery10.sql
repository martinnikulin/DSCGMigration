use DSCG_001

drop view GDCS.[OrderedSeams]
;
with q1 as (
select schema_name(tab.schema_id) as schema_name,
    tab.name as table_name, 
    col.column_id,
    col.name as column_name, 
    t.name as data_type,    
    col.max_length,
    col.precision
from sys.tables as tab
    inner join sys.columns as col
        on tab.object_id = col.object_id
    left join sys.types as t
    on col.user_type_id = t.user_type_id
where not (	tab.name = 'dtproperties' or  
			tab.name = 'sysdiagrams' or 
			tab.name = 'Parameters' or 
			tab.name = 'GroundWater' or 
			tab.name = 'Grade' or
			tab.name = 'Roles' or
			tab.name = 'Modelgeoms' or
			tab.name = 'Users' or
			tab.name = 'Modelgeoms' or
			tab.name = 'Drawings' or
			tab.name = 'Holegroups')
)

--insert into GDCS_System.dbo.MigrationTable (ObjectType, OldName)
select		distinct 'Table' as ObjectType, schema_name + '.' + table_name as OldName--, column_name
from		q1

--select * from GDCS_System.dbo.MigrationTable
update GDCS_System.dbo.MigrationTable set OldName = Substring(OldName, 5, 100) where Left(OldName, 3) = 'dbo'
--exec sp_rename 'GDCS.ChangedRecords', 'ChangedRecords'
--alter schema dbo transfer Reserves.Parameters