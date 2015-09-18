unit uInsulins;

interface

uses
  // Delphi
  Generics.Collections,
  // FireDACE
  FireDAC.Comp.Client,
  // Project
  uDatabase;

type
  TInsulin = class
  private
    FIdent   : Integer;
    FName    : string;
    FDuration: Integer;
  public
    constructor Create(AIdent: Integer; const AName: string; ADuration: Integer);
    property Ident   : Integer read FIdent;
    property Name    : string  read FName;
    property Duration: Integer read FDuration;
  end;

  TInsulins = class
  private
    FQuery: TFDQuery;
    FDatabase: TDatabase;

    function GetQuery: TFDQuery;
    function GetDatabase: TDatabase;
    procedure AfterConnect(Sender: TObject);

    property Query: TFDQuery read GetQuery;
    property Database: TDatabase read GetDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Delete(AIndex: Integer);
    function GetItems: TObjectList<TInsulin>;
    function GetItemByIndex(Value: Integer): TInsulin;
    function GetItemByIdent(Value: Integer): TInsulin;
    procedure Add(const AName: string; ADuration: Integer);
    procedure Edit(AIndex: Integer; const AName: string; ADuration: Integer);
  end;

function Insulins: TInsulins;

implementation

uses
  System.SysUtils;

var
  varInsulins: TInsulins = nil;

function Insulins: TInsulins;
begin
  if not Assigned(varInsulins) then
    varInsulins := TInsulins.Create;
  Result := varInsulins;
end;

{ TInsulin }

constructor TInsulin.Create(AIdent: Integer; const AName: string; ADuration: Integer);
begin
  inherited Create;
  FIdent    := AIdent;
  FName     := AName;
  FDuration := ADuration;
end;

{ TInsulins }

constructor TInsulins.Create;
begin
  inherited;
  FQuery    := nil;
  FDatabase := nil;
end;

destructor TInsulins.Destroy;
begin
  if Assigned(FQuery) then
  try
    if FQuery.Active then
      FQuery.Close;
  finally
    FQuery.Free;
  end;

  if Assigned(FDatabase) then
    FDatabase.Free;

  inherited Destroy;
end;

function TInsulins.GetDatabase: TDatabase;
begin
  if not Assigned(FDatabase) then
  begin
    FDatabase := TDatabase.Create;
    FDatabase.Connection.AfterConnect := AfterConnect;
  end;
  Result := FDatabase;
end;

function TInsulins.GetQuery: TFDQuery;
begin
  if not Assigned(FQuery) then
  begin
    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := Database.Connection;
    FQuery.Open('SELECT * FROM INSULINS');
  end;
  Result := FQuery;
end;

procedure TInsulins.AfterConnect;
begin
  if not Database.TableExists('INSULINS') then
    if Database.Execute('CREATE TABLE INSULINS (ID INTEGER PRIMARY KEY, NAME TEXT, DURATION INTEGER);') > -1 then
    begin
      Database.Execute('INSERT INTO INSULINS (NAME, DURATION) VALUES(''NovoRapid'', 180);');
      Database.Execute('INSERT INTO INSULINS (NAME, DURATION) VALUES(''Actrapid'',  300);');
    end;
end;

function TInsulins.GetItems: TObjectList<TInsulin>;
begin
  Result := TObjectList<TInsulin>.Create;
  Query.First;
  while not Query.EOF do
  begin
    Result.Add(TInsulin.Create(Query.FieldByName('ID').AsInteger, Query.FieldByName('NAME').AsString, Query.FieldByName('DURATION').AsInteger));
    Query.Next;
  end;
end;

procedure TInsulins.Delete(AIndex: Integer);
var
  IL: TObjectList<TInsulin>;
begin
  if AIndex > -1 then
  begin
    IL := GetItems;
    try
      if AIndex < IL.Count then
        if Database.Execute(Format('DELETE FROM INSULINS WHERE ID = %d;', [IL[AIndex].Ident])) > 0 then
          Query.Refresh;
    finally
      IL.Free;
    end;
  end;
end;

function TInsulins.GetItemByIndex(Value: Integer): TInsulin;
var
  IL: TObjectList<TInsulin>;
begin
  if Value > -1 then
  begin
    IL := GetItems;
    try
      if Value < IL.Count then
        Result := TInsulin.Create(IL[Value].Ident, IL[Value].Name, IL[Value].Duration);
    finally
      IL.Free;
    end;
  end;
end;

function TInsulins.GetItemByIdent(Value: Integer): TInsulin;
begin
  Result := nil;
  if Query.Locate('ID', Value) then
    Result := TInsulin.Create(Query.FieldByName('ID').AsInteger, Query.FieldByName('NAME').AsString, Query.FieldByName('DURATION').AsInteger);
end;

procedure TInsulins.Add(const AName: string; ADuration: Integer);
begin
  if Database.Execute(Format('INSERT INTO INSULINS (NAME, DURATION) VALUES(''%s'', %d);', [AName, ADuration])) > 0 then
    Query.Refresh;
end;

procedure TInsulins.Edit(AIndex: Integer; const AName: string; ADuration: Integer);
var
  IL: TObjectList<TInsulin>;
begin
  if AIndex > -1 then
  begin
    IL := GetItems;
    try
      if AIndex < IL.Count then
        if Query.Locate('ID', IL[AIndex].Ident, []) then
        begin
          Query.Edit;
          try
            Query.FieldByName('NAME').AsString      := AName;
            Query.FieldByName('DURATION').AsInteger := ADuration;
          finally
            Query.Post;
          end;
        end;
    finally
      IL.Free;
    end;
  end;
end;

end.
