unit uLog;

interface

uses
  // Delphi
  System.Classes,
  Generics.Collections,
  // FireDACE
  FireDAC.Comp.Client,
  // Project
  uDatabase;

type
  TLogItem = class
  private
    FIdent   : Integer;
    FUnits   : Integer;
    FInsulin : Integer;
    FDateTime: TDateTime;
  public
    constructor Create(AIdent, AUnits, AInsulin: Integer; ADateTime: TDateTime);
    property Ident   : Integer read FIdent;
    property Units   : Integer read FUnits;
    property Insulin : Integer read FInsulin;
    property DateTime: TDateTime read FDateTime;
  end;

  TLog = class
  private
    FQuery: TFDQuery;
    FDatabase: TDatabase;
    FOnChange: TNotifyEvent;

    procedure Change;
    function GetQuery: TFDQuery;
    function GetDatabase: TDatabase;
    procedure AfterConnect(Sender: TObject);

    property Query: TFDQuery read GetQuery;
    property Database: TDatabase read GetDatabase;
  public
    constructor Create;
    destructor Destroy; override;

    function GetItems: TObjectList<TLogItem>;
    procedure Add(nUnits, InsulinIdent: Integer);

    procedure Delete(AIndex: Integer);
    procedure DeleteExpired;

    function IOB: REAL;
    function Remaining: TDateTime;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  // Delphi
  System.SysUtils,
  System.DateUtils,
  // Project
  uSettings,
  uInsulins;

{ TLogItem }

constructor TLogItem.Create(AIdent, AUnits, AInsulin: Integer; ADateTime: TDateTime);
begin
  inherited Create;
  FIdent    := AIdent;
  FUnits    := AUnits;
  FInsulin  := AInsulin;
  FDateTime := ADateTime;
end;

{ TLog }

constructor TLog.Create;
begin
  inherited;
  FQuery    := nil;
  FDatabase := nil;
end;

destructor TLog.Destroy;
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

function TLog.GetDatabase: TDatabase;
begin
  if not Assigned(FDatabase) then
  begin
    FDatabase := TDatabase.Create;
    FDatabase.Connection.AfterConnect := AfterConnect;
  end;
  Result := FDatabase;
end;

function TLog.GetQuery: TFDQuery;
begin
  if not Assigned(FQuery) then
  begin
    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := Database.Connection;
    FQuery.Open('SELECT * FROM LOG');
  end;
  Result := FQuery;
end;

procedure TLog.AfterConnect;
begin
  if not Database.TableExists('LOG') then
    Database.Execute('CREATE TABLE LOG (ID INTEGER PRIMARY KEY, DATETIME REAL, UNITS INTEGER, TYPE INTEGER);');
end;

function TLog.GetItems: TObjectList<TLogItem>;
begin
  Result := TObjectList<TLogItem>.Create;
  Query.First;
  while not Query.EOF do
  begin
    Result.Add(TLogItem.Create(
      Query.FieldByName('ID').AsInteger,
      Query.FieldByName('UNITS').AsInteger,
      Query.FieldByName('TYPE').AsInteger,
      Query.FieldByName('DATETIME').AsFloat
    ));
    Query.Next;
  end;
end;

procedure TLog.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TLog.Add(nUnits, InsulinIdent: Integer);
begin
  if Database.Execute(Format('INSERT INTO LOG (DATETIME, UNITS, TYPE) VALUES (%s, %d, %d);', [FloatToStr(Now, FormatSettingsFloat), nUnits, InsulinIdent])) > 0 then
  begin
    Query.Refresh;
    Change;
  end;
end;

procedure TLog.Delete(AIndex: Integer);
var
  LL: TObjectList<TLogItem>;
begin
  if AIndex > -1 then
  begin
    LL := GetItems;
    try
      if AIndex < LL.Count then
        if Database.Execute(Format('DELETE FROM LOG WHERE ID = %d;', [LL[AIndex].Ident])) > 0 then
        begin
          Query.Refresh;
          Change;
        end;
    finally
      LL.Free;
    end;
  end;
end;

procedure TLog.DeleteExpired;
var
  B : Boolean;
  ID: Integer;
  I : TInsulin;
  DT: TDateTime;
begin
  B := False;

  Query.First;

  while not Query.EOF do
  begin
    ID := Query.FieldByName('TYPE').AsInteger;
    if ID > 0 then
    begin
      I := Insulins.GetItemByIdent(ID);
      if Assigned(I) then
      try
        DT := IncMinute(Query.FieldByName('DATETIME').AsFloat, I.Duration);
        if Now > DT then
        begin
          Query.Delete;
          B := True;
          CONTINUE;
        end;
      finally
        I.Free;
      end;
    end;
    Query.Next;
  end;

  if B then
    Change;
end;

function TLog.IOB: REAL;
var
  I: TInsulin;
  DT1, DT2: TDateTime;
  nUnits, nID: Integer;
  nDelta1, nDelta2: Integer;
begin
  Result := 0;
  Query.First;
  while not Query.EOF do
  begin
    nUnits := Query.FieldByName('UNITS').AsInteger;
    if nUnits > 0 then
    begin
      nID := Query.FieldByName('TYPE').AsInteger;
      if nID > 0 then
      begin
        I := Insulins.GetItemByIdent(nID);
        if Assigned(I) then
        try
          DT1 := Query.FieldByName('DATETIME').AsFloat;
          DT2 := IncMinute(DT1, I.Duration);

          nDelta1 := MinutesBetween(DT2, DT1);
          nDelta2 := MinutesBetween(DT2, Now) + 1;

          Result := Result + ((nUnits / nDelta1) * nDelta2);
        finally
          I.Free;
        end;
      end;
    end;
    Query.Next;
  end;
end;

function TLog.Remaining: TDateTime;
var
  I: TInsulin;
  Delta: Double;
  DT1, DT2: TDateTime;
  nUnits, nID: Integer;
begin
  Result := 0;
  Query.First;
  while not Query.EOF do
  begin
    nUnits := Query.FieldByName('UNITS').AsInteger;
    if nUnits > 0 then
    begin
      nID := Query.FieldByName('TYPE').AsInteger;
      if nID > 0 then
      begin
        I := Insulins.GetItemByIdent(nID);
        if Assigned(I) then
        try
          DT1 := Query.FieldByName('DATETIME').AsFloat;
          DT2 := IncMinute(DT1, I.Duration);

          Delta := IncMinute(DT2 - Now, 1);

          if Delta > Result then
            Result := Delta;
        finally
          I.Free;
        end;
      end;
    end;
    Query.Next;
  end;
end;

end.
