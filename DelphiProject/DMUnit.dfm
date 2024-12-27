object DM: TDM
  OldCreateOrder = False
  Height = 234
  Width = 400
  object MigrationQuery: TADOQuery
    Connection = MigrationConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 128
    Top = 16
  end
  object MigrationConnection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL.1;Integrated Security=SSPI;Persist Security ' +
      'Info=False;User ID="";Initial Catalog=Migration;Data Source="";I' +
      'nitial File Name="";Server SPN="";Authentication="";Access Token' +
      '=""'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL.1'
    Left = 40
    Top = 16
  end
  object GDBConnection: TADOConnection
    ConnectionString = 
      'Provider=MSOLEDBSQL.1;Integrated Security=SSPI;Persist Security ' +
      'Info=False;User ID="";Initial Catalog=GDB_46_005;Data Source=loc' +
      'alhost;Initial File Name="";Server SPN="";Authentication="";Acce' +
      'ss Token=""'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL.1'
    Left = 40
    Top = 88
  end
  object ObjectDefsQuery: TADOQuery
    Connection = GDBConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select'#9#9'pq.Id, mt.ObjectType, pq.ObjectName, m.Definition, pq.De' +
        'finition as Def, pq.Done'
      'from'#9#9'Migration.dbo.ProcessQueue pq'
      
        'inner join'#9'Migration.dbo.MigrationTable mt on pq.ObjectName = mt' +
        '.NewName'
      'inner join'#9'sys.objects o on o.Name = pq.ObjectName'
      'inner join'#9'sys.sql_modules as m on o.object_id = m.object_id'
      '--where pq.Done = 0'
      'order by'#9'pq.N')
    Left = 128
    Top = 152
  end
  object dsObjectDefsQuery: TDataSource
    DataSet = ObjectDefsQuery
    Left = 232
    Top = 152
  end
  object DelphiFiles: TADOQuery
    Connection = MigrationConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select FileName from DelphiFiles'
      'order by FileName')
    Left = 224
    Top = 16
  end
  object ActionQuery: TADOQuery
    Connection = GDBConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'exec sp_rename '#39'dbo.Calcunits.ad_avg'#39', '#39'AdAvg'#39', '#39'Column'#39)
    Left = 129
    Top = 88
  end
end
