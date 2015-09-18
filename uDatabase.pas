unit uDatabase;

interface

uses
  // FireDAC
  FireDAC.DApt,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys.SQLite,
  FireDAC.Comp.Client;

type
  TDatabase = class
  private
    FConnection: TFDConnection;
    class function GetFileName: string;
    function GetConnection: TFDConnection;
    property FileName: string read GetFileName;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(const SQL: string): LongInt;
    function TableExists(const TableName: string): Boolean;
    property Connection: TFDConnection read GetConnection;
  end;

implementation

uses
  // Delphi
  Data.DB,
  System.IOUtils,
  System.SysUtils;

constructor TDatabase.Create;
begin
  inherited Create;
  FConnection := nil;
end;

destructor TDatabase.Destroy;
begin
  if Assigned(FConnection) then
  try
    if FConnection.Connected then
      FConnection.Close;
  finally
    FConnection.Free;
  end;
  inherited Destroy;
end;

class function TDatabase.GetFileName: string;
begin
  Result := TPath.Combine(TPath.GetDocumentsPath, 'settings.sqlite');
end;

function TDatabase.GetConnection: TFDConnection;
begin
  if not Assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    FConnection.Params.Values['DriverID'] := 'SQLite';
    FConnection.Params.Values['Database'] := FileName;
  end;
  Result := FConnection;
end;

function TDatabase.Execute(const SQL: string): LongInt;
begin
  Result := Connection.ExecSQL(SQL);
end;

function TDatabase.TableExists(const TableName: string): Boolean;
var
  F: TField;
  Q: TFDQuery;
begin
  Result := False;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := Connection;
    Q.Open(Format('SELECT name FROM sqlite_master WHERE type=''table'' AND name=''%s''', [TableName]));
    if Q.Active then
    begin
      Q.First;
      F := Q.FindField('name');
      if Assigned(F) then
        Result := F.AsString <> '';
    end;
  finally
    Q.Free;
  end;
end;

end.
