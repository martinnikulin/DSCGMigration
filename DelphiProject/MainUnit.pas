unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, System.RegularExpressions,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid;

type
  TAction = (aRename, aDrop, aDefs);

type
  TObjectType = (otObject, otColumn, otDefs);

type
  TMainForm = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    DBMemo1: TDBMemo;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1ObjectType: TcxGridDBColumn;
    cxGrid1DBTableView1ObjectName: TcxGridDBColumn;
    cxGrid1DBTableView1Id: TcxGridDBColumn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure Migrate;
    procedure MigrateDatabase;
    procedure OpenMigrationTable(ObjectType: TObjectType; Action: TAction);
    procedure ProcessObjects(ObjectType: TObjectType; Action: TAction);
    procedure ReplaceDefinitions;
    procedure MigrateDelphiFiles(Path: String);
    procedure ExecSQL(SQL: String);
    procedure ProcessFile(FileName: TFileName);
    procedure SaveFile(FileName, Text: String);
    procedure DropSchemas;
    function GetSQL(ObjectType: TObjectType; Action: TAction): String;
    function GetRenameSQL(ObjectType: TObjectType): String;
    function GetRenameColumnSQL: String;
    function GetRenameObjectSQL: String;
    function GetDropSQL(ObjectType: TObjectType): String;
    function GetMigrationQuerySQL(ObjectType: TObjectType): String;
    function GetActionCondition(Action: TAction): String;
    function GetObjectCondition(ObjectType: TObjectType): String;
    function ReplaceText(Text, OldName, NewName: String): String;
    function ReadFile(const FileName: String): String;
    function ReplaceWords(Text: String): String;
  public
  end;

var
  MainForm: TMainForm;

implementation
uses
  DMUnit;
var
  mtr: TMigrationTableRecord;

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Migrate;
end;

procedure TMainForm.Migrate;
begin
  DM.Disconnect;
  DM.Connect;
  MigrateDatabase;
  DM.Disconnect;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  DM.Connect;
  DM.ObjectDefsQuery.Active := True;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  MigrateDelphiFiles('C:\Users\Вадим\Documents\MEGA\MEGAsync\Projects\DSCG');
end;

procedure TMainForm.DropSchemas;
begin
  ExecSQL('DROP SCHEMA GDCS');
  ExecSQL('DROP SCHEMA Queries');
  ExecSQL('DROP SCHEMA Reserves');
end;

procedure TMainForm.MigrateDatabase;
begin
  try try
    ProcessObjects(otColumn, aRename);
    ProcessObjects(otObject, aRename);
    ProcessObjects(otObject, aDrop);
    ReplaceDefinitions;
    DropSchemas;
    DM.MigrationConnection.Close;
    ShowMessage('Миграция произведена');
  except
    on E : Exception do
      ShowMessage(E.Message);
  end;
  finally
    DM.GDBConnection.Connected := False;
  end;
end;

procedure TMainForm.ProcessObjects(ObjectType: TObjectType; Action: TAction);
var
  SQL: string;
begin
  OpenMigrationTable(ObjectType, Action);
  while not DM.MigrationQuery.Eof do
  begin
    mtr := DM.GetMTRecord;
    SQL := GetSQL(ObjectType, Action);
    ExecSQL(SQL);
    DM.MigrationQuery.Edit;
    DM.MigrationQuery.FieldByName('Done').Value := 1;
    DM.MigrationQuery.Post;
    DM.MigrationQuery.Next;
  end;
end;

procedure TMainForm.ReplaceDefinitions;
var
  SQL, ObjectType: String;
  DefsQuery: TADOQuery;
begin
  DefsQuery := TADOQuery.Create(nil);
  DefsQuery.Connection := DM.MigrationConnection;
  DefsQuery.SQL.Text := 'select * from ProcessQueue order by N';
  DefsQuery.Active := True;
  while not DefsQuery.Eof do begin
    SQL := DefsQuery.FieldByName('Definition').AsString;
    ExecSQL(SQL);
    DefsQuery.Edit;
    DefsQuery.FieldByName('Done').Value := 1;
    DefsQuery.Post;
    DefsQuery.Next;
  end;
end;

function TMainForm.GetSQL(ObjectType: TObjectType; Action: TAction): String;
begin
  case Action of
    aRename: Result := GetRenameSQL(ObjectType);
    aDrop: Result := GetDropSQL(ObjectType);
  end;
end;

function TMainForm.GetRenameSQL(ObjectType: TObjectType): String;
begin
  case ObjectType of
    otObject: Result := GetRenameObjectSQL;
    otColumn: Result := GetRenameColumnSQL;
  end;
end;

function TMainForm.GetRenameColumnSQL: String;
var
  OldName: string;
begin
  OldName := mtr.SchemaName + '.' + mtr.TableName + '.' + mtr.OldName;
  Result := 'exec sp_rename ' + QuotedStr(OldName) + ', ' + QuotedStr(mtr.NewName) + ', ' + QuotedStr('Column');
end;

function TMainForm.GetRenameObjectSQL: String;
begin
  Result := 'exec sp_rename ' + QuotedStr(mtr.OldName) + ', ' + QuotedStr(mtr.NewName);
  if mtr.SchemaName <> 'dbo' then
    Result := 'alter schema dbo transfer ' + mtr.SchemaName + '.' + mtr.OldName + ';' + Result;
end;

function TMainForm.GetDropSQL(ObjectType: TObjectType): String;
begin
  Result := 'drop ' + mtr.ObjectType + ' ' + mtr.SchemaName + '.' + mtr.OldName;
end;

function TMainForm.ReplaceWords(Text: string): String;
begin
  DM.MigrationQuery.First;
  while not DM.MigrationQuery.Eof do
  begin
    mtr := DM.GetMTRecord;
    Text := ReplaceText(Text, mtr.OldName, mtr.NewName);
    DM.MigrationQuery.Next;
  end;
  Result := Text;
end;

function TMainForm.ReplaceText(Text, OldName, NewName: String): String;
begin
  Text := TRegEx.Replace(Text, '\b' + mtr.OldName + '\b', mtr.NewName, [roIgnoreCase]);
  Result := Text;
end;

procedure TMainForm.OpenMigrationTable(ObjectType: TObjectType; Action: TAction);
begin
  DM.MigrationQuery.SQL.Text := GetMigrationQuerySQL(ObjectType) +
                                GetActionCondition(Action) + ' and ' +
                                GetObjectCondition(ObjectType) +
                                ' order by Id';
  DM.MigrationQuery.Open;
end;

function TMainForm.GetMigrationQuerySQL(ObjectType: TObjectType): String;
begin
  case ObjectType of
    otObject: Result := 'select * from MigrationTable where Done = 0 and ';
    otColumn: Result := 'select * from MigrationTable where Done = 0 and ';
    otDefs: Result := 'select distinct ' + QuotedStr('Defs') + ' as ObjectType, ' +
          QuotedStr('dbo') + ' as SchemaName, ' +
          QuotedStr('Defs') + ' as TableName, OldName, NewName, ' +
          QuotedStr('Defs') + ' as Action from MigrationTable where Done = 0 and ';
  end;
end;

function TMainForm.GetActionCondition(Action: TAction): String;
begin
  case Action of
    aRename: Result := '(Action = ' + QuotedStr('Rename') + ')';
    aDrop: Result := '(Action = ' + QuotedStr('Drop') + ')';
    aDefs: Result := '(Action <> ' + QuotedStr('Drop') + ')';
  end;
end;

function TMainForm.GetObjectCondition(ObjectType: TObjectType): String;
begin
  case ObjectType of
    otObject: Result := '(ObjectType = ' + QuotedStr('Table') + 
                      ' or ObjectType = ' + QuotedStr('View') + 
                      ' or ObjectType = ' + QuotedStr('Procedure') + 
                      ' or ObjectType = ' + QuotedStr('Function') + ')';
    otColumn: Result := '(ObjectType = ' + QuotedStr('Column') + ')';
    otDefs: Result := '(OldName <> NewName COLLATE Latin1_General_CS_AS)';
  end;
end;

procedure TMainForm.ExecSQL(SQL: String);
begin
  DM.ActionQuery.SQL.Text := SQL;
  DM.ActionQuery.ExecSQL;
end;

procedure TMainForm.MigrateDelphiFiles(Path: String);
var
  Folder, FileName: String;
begin
//  Folder := 'G:\Projects\DSCG1\';
//  DM.ConnectToDB(DM.MigrationConnection, 'DESKTOP-TVT25EU', 'Migration');
//  DM.DelphiFiles.Active := True;
//  OpenMigrationTable(otDefs, aDefs);
//  while not DM.DelphiFiles.Eof do
//  begin
//    FileName := Folder + DM.DelphiFiles.FieldByName('FileName').AsString;
//    ProcessFile(FileName);
//    DM.DelphiFiles.Next;
//  end;
end;

procedure TMainForm.ProcessFile(FileName: TFileName);
var
  Text: String;
begin
  Text := ReadFile(FileName);
  Text := ReplaceWords(Text);
  SaveFile(FileName, ReplaceWords(Text));
end;

function TMainForm.ReadFile(const FileName: String): String;
var
  List: TStringList;
begin
  if (FileExists(FileName)) then
  begin
    List := TStringList.Create;
    List.Loadfromfile(FileName);
    Result := List.Text;
    List.Free;
  end;
end;

procedure TMainForm.SaveFile(FileName, Text: String);
var
  List: TStringList;
begin
  List := TStringList.Create;
  List.Text := Text;
  List.SaveToFile(FileName);
end;

end.
