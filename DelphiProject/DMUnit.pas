unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TAuthType = (atWindows, atSQLServer);

type
  TNetType = (stLocal, stInternet);

type
  TConnectionAttributes = record
    ServerAddr: String;
    Database: String;
    Login: String;
    Password: String;
    AuthType: TAuthType;
  end;

type
  TMigrationTableRecord = record
    ObjectType: String;
    SchemaName: String;
    TableName: String;
    OldName: String;
    NewName: String;
    Action: String;
  end;

type
  TDM = class(TDataModule)
    MigrationConnection: TADOConnection;
    GDBConnection: TADOConnection;
    MigrationQuery: TADOQuery;
    ObjectDefsQuery: TADOQuery;
    dsObjectDefsQuery: TDataSource;
    DelphiFiles: TADOQuery;
    ActionQuery: TADOQuery;
  private
  public
    procedure Connect;
    procedure Disconnect;
    function GetMTRecord: TMigrationTableRecord;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.Connect;
begin
  DM.MigrationConnection.Connected := True;
  DM.GDBConnection.Connected := True;
end;

procedure TDM.Disconnect;
begin
  DM.MigrationConnection.Connected := False;
  DM.GDBConnection.Connected := False;
end;

function TDM.GetMTRecord: TMigrationTableRecord;
begin
  with Result do
  begin
    ObjectType := MigrationQuery.FieldByName('ObjectType').AsString;
    SchemaName := MigrationQuery.FieldByName('SchemaName').AsString;
    TableName := MigrationQuery.FieldByName('TableName').AsString;
    OldName := MigrationQuery.FieldByName('OldName').AsString;
    NewName := MigrationQuery.FieldByName('NewName').AsString;
    Action := MigrationQuery.FieldByName('Action').AsString;
  end;
end;

end.
