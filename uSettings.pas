unit uSettings;

interface

uses
  // Delphi
  System.SysUtils,
  // FireDACE
  FireDAC.Comp.Client,
  // Project
  uDatabase;

type
  TInsulinTime = (itMorning, itDay, itEvening);

  TSettings = class
  private
    FQuery: TFDQuery;
    FFirstTime: Boolean;
    FDatabase: TDatabase;

    function GetIOB: Boolean;
    procedure SetIOB(Value: Boolean);

    function GetAppBadge: Boolean;
    procedure SetAppBadge(Value: Boolean);

    function GetTarget(Time: TInsulinTime): REAL;
    procedure SetTarget(Time: TInsulinTime; Value: REAL);

    function GetAnimations: Boolean;
    procedure SetAnimations(Value: Boolean);

    function GetCarbF(Time: TInsulinTime): Integer;
    procedure SetCarbF(Time: TInsulinTime; Value: Integer);

    function GetCorrF(Time: TInsulinTime): REAL;
    procedure SetCorrF(Time: TInsulinTime; Value: REAL);

    function GetQuery: TFDQuery;
    function GetDatabase: TDatabase;
    procedure AfterConnect(Sender: TObject);

    property Query: TFDQuery read GetQuery;
    property Database: TDatabase read GetDatabase;
  public
    constructor Create;
    destructor Destroy; override;

    property FirstTime: Boolean read FFirstTime;
    property IOB: Boolean read GetIOB write SetIOB;
    property AppBadge: Boolean read GetAppBadge write SetAppBadge;
    property Target[Time: TInsulinTime]: REAL read GetTarget write SetTarget;
    property Animations: Boolean read GetAnimations write SetAnimations;

    property CarbF[Time: TInsulinTime]: Integer read GetCarbF write SetCarbF;
    property CorrF[Time: TInsulinTime]: REAL read GetCorrF write SetCorrF;
  end;

const
  CARB1   = 0;
  CARB2   = 0;
  CARB3   = 0;
  CORR1   = 0.0;
  CORR2   = 0.0;
  CORR3   = 0.0;
  TARGET1 = 5.8;
  TARGET2 = 5.8;
  TARGET3 = 8.0;

function FormatSettingsFloat: TFormatSettings;
function GetInsulinTime: TInsulinTime;
function Settings: TSettings;

implementation

uses
  // Delphi
  Data.DB;

function FormatSettingsFloat: TFormatSettings;
begin
  Result := FormatSettings;
  Result.DecimalSeparator := '.';
end;

function GetInsulinTime: TInsulinTime;
begin
  Result := itMorning;
  if Time > 11/24 then
    if Time > 16/24 then
      Result := itEvening
    else
      Result := itDay;
end;

var
  varSettings: TSettings = nil;

function Settings: TSettings;
begin
  if not Assigned(varSettings) then
    varSettings := TSettings.Create;
  Result := varSettings;
end;

{ TSettings }

constructor TSettings.Create;
begin
  inherited;
  FQuery    := nil;
  FDatabase := nil;
end;

destructor TSettings.Destroy;
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

function TSettings.GetDatabase: TDatabase;
begin
  if not Assigned(FDatabase) then
  begin
    FDatabase := TDatabase.Create;
    FDatabase.Connection.AfterConnect := AfterConnect;
  end;
  Result := FDatabase;
end;

function TSettings.GetQuery: TFDQuery;
begin
  if not Assigned(FQuery) then
  begin
    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := Database.Connection;
  end;
  Result := FQuery;
  if not Result.Active then
    Result.Open('SELECT * FROM SETTINGS');
end;

procedure TSettings.AfterConnect;
begin
  FFirstTime := not Database.TableExists('SETTINGS');
  if FirstTime then
    if Database.Execute('CREATE TABLE SETTINGS (' +
                        'ID INTEGER PRIMARY KEY, TARGET1 REAL, TARGET2 REAL, TARGET3 REAL, IOB INTEGER, ANIMATIONS INTEGER' +
                        ', CARB1 INTEGER, CARB2 INTEGER, CARB3 INTEGER' +
                        ', CORR1 REAL, CORR2 REAL, CORR3 REAL);') > -1 then
      Database.Execute(Format('INSERT INTO SETTINGS (' +
                              'TARGET1, TARGET2, TARGET3, IOB, ANIMATIONS, CARB1, CARB2, CARB3, CORR1, CORR2, CORR3) ' +
                              'VALUES(%.2f, %.2f, %.2f, 1, 1, %d, %d, %d, %.2f, %.2f, %.2f);',
                              [TARGET1, TARGET2, TARGET3, CARB1, CARB2, CARB3, CORR1, CORR2, CORR3], FormatSettingsFloat));
end;

function TSettings.GetIOB: Boolean;
begin
  Result := Query.FieldByName('IOB').AsInteger <> 0;
end;

procedure TSettings.SetIOB(Value: Boolean);
begin
  Query.Edit;
  try
    Query.FieldByName('IOB').AsInteger := Ord(Value);
  finally
    Query.Post;
  end;
end;

function TSettings.GetAppBadge: Boolean;
var
  F: TField;
begin
  Result := True;
  F := Query.FindField('AppBadge');
  if Assigned(F) then
    Result := F.AsInteger <> 0;
end;

procedure TSettings.SetAppBadge(Value: Boolean);
var
  F: TField;
begin
  F := Query.FindField('AppBadge');

  if not Assigned(F) then
    if Database.Execute('ALTER TABLE SETTINGS ADD COLUMN AppBadge INTEGER') > 0 then
    begin
      Database.Execute(Format('UPDATE SETTINGS SET AppBadge = %d', [Ord(Value)]));
      Database.Connection.Close;
      EXIT;
    end;

  if Assigned(F) then
  begin
    Query.Edit;
    try
      F.AsInteger := Ord(Value);
    finally
      Query.Post;
    end;
  end;
end;

function TSettings.GetTarget(Time: TInsulinTime): REAL;
begin
  if Time = itEvening then
    Result := Query.FieldByName('TARGET3').AsFloat
  else if Time = itDay then
    Result := Query.FieldByName('TARGET2').AsFloat
  else
    Result := Query.FieldByName('TARGET1').AsFloat;
end;

procedure TSettings.SetTarget(Time: TInsulinTime; Value: REAL);
begin
  Query.Edit;
  try
    case Time of
      itMorning: Query.FieldByName('TARGET1').AsFloat := Value;
      itDay    : Query.FieldByName('TARGET2').AsFloat := Value;
      itEvening: Query.FieldByName('TARGET3').AsFloat := Value;
    end;
  finally
    Query.Post;
  end;
end;

function TSettings.GetAnimations: Boolean;
begin
  Result := Query.FieldByName('ANIMATIONS').AsInteger <> 0;
end;

procedure TSettings.SetAnimations(Value: Boolean);
begin
  Query.Edit;
  try
    Query.FieldByName('ANIMATIONS').AsInteger := Ord(Value);
  finally
    Query.Post;
  end;
end;

function TSettings.GetCarbF(Time: TInsulinTime): Integer;
begin
  if Time = itMorning then
    Result := Query.FieldByName('CARB1').AsInteger
  else if Time = itDay then
    Result := Query.FieldByName('CARB2').AsInteger
  else
    Result := Query.FieldByName('CARB3').AsInteger;
end;

procedure TSettings.SetCarbF(Time: TInsulinTime; Value: Integer);
begin
  Query.Edit;
  try
    if Time = itMorning then
      Query.FieldByName('CARB1').AsInteger := Value
    else if Time = itDay then
      Query.FieldByName('CARB2').AsInteger := Value
    else
      Query.FieldByName('CARB3').AsInteger := Value;
  finally
    Query.Post;
  end;
end;

function TSettings.GetCorrF(Time: TInsulinTime): REAL;
begin
  if Time = itMorning then
    Result := Query.FieldByName('CORR1').AsFloat
  else if Time = itDay then
    Result := Query.FieldByName('CORR2').AsFloat
  else
    Result := Query.FieldByName('CORR3').AsFloat;
end;

procedure TSettings.SetCorrF(Time: TInsulinTime; Value: REAL);
begin
  Query.Edit;
  try
    if Time = itMorning then
      Query.FieldByName('CORR1').AsFloat := Value
    else if Time = itDay then
      Query.FieldByName('CORR2').AsFloat := Value
    else
      Query.FieldByName('CORR3').AsFloat := Value;
  finally
    Query.Post;
  end;
end;

end.
