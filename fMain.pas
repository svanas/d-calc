unit fMain;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  System.Notification,
  // FireMonkey,
  FMX.Ani,
  FMX.Edit,
  FMX.Forms,
  FMX.Types,
  FMX.Objects,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Platform,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListView,
  FMX.TabControl,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  // Project
  uLog,
  uSettings,
  uControlMover;

type
  TCalcImage = (ciGlucose, ciCarbs, ciInsulin, ciMorning, ciDay, ciEvening);

  TfrmMain = class(TForm)
    btnGlucose: TButton;
    rctGlucose: TRoundRect;
    TB: TToolBar;
    TabControl: TTabControl;
    tabCalculate: TTabItem;
    tabIOB: TTabItem;
    tabSettings1: TTabItem;
    lblGlucose1: TLabel;
    btnAuto: TSpeedButton;
    btnMorning: TSpeedButton;
    btnDay: TSpeedButton;
    btnEvening: TSpeedButton;
    lblUnits: TLabel;
    Line1: TLine;
    rctCarbs: TRoundRect;
    btnCarbs: TButton;
    lblCarbs1: TLabel;
    lblGlucose2: TLabel;
    lblCarbs2: TLabel;
    chkIOB: TSwitch;
    chkAnimations: TSwitch;
    rctExercise: TRoundRect;
    btnExercise: TButton;
    lblExercise1: TLabel;
    lblExercise2: TLabel;
    cExercise: TCircle;
    pExercise: TPie;
    aniExercise: TFloatAnimation;
    cboInsulin: TComboBox;
    rctInsulin: TRoundRect;
    lblInsulinName: TLabel;
    lblInsulin: TLabel;
    LB: TListBox;
    lbiIOB: TListBoxItem;
    lbiAnimations: TListBoxItem;
    lbiTarget1: TListBoxItem;
    lbiTarget2: TListBoxItem;
    lbiTarget3: TListBoxItem;
    lgbOther: TListBoxGroupHeader;
    edtTarget1: TEdit;
    lbgTarget: TListBoxGroupHeader;
    edtTarget2: TEdit;
    edtTarget3: TEdit;
    lbgCarbF: TListBoxGroupHeader;
    lbiCarb1: TListBoxItem;
    lbiCarb2: TListBoxItem;
    lbiCarb3: TListBoxItem;
    edtCarb1: TEdit;
    edtCarb2: TEdit;
    edtCarb3: TEdit;
    lbgCorrF: TListBoxGroupHeader;
    lbiCorr1: TListBoxItem;
    lbiCorr2: TListBoxItem;
    lbiCorr3: TListBoxItem;
    edtCorr1: TEdit;
    edtCorr2: TEdit;
    edtCorr3: TEdit;
    tabSettings2: TTabControl;
    tabGeneral: TTabItem;
    tabInsulins: TTabItem;
    lbiInsulins: TListBoxItem;
    tbInsulins: TToolBar;
    btnBack1: TSpeedButton;
    lvInsulins: TListView;
    btnAdd: TSpeedButton;
    tabInsulin: TTabItem;
    tbInsulin: TToolBar;
    btnBack2: TSpeedButton;
    edtName: TEdit;
    lblName: TLabel;
    edtDuration: TEdit;
    lblDuration: TLabel;
    rctDiabetesDiary: TRoundRect;
    btnDiabetesDiary: TButton;
    pnlBottom: TPanel;
    imgDiabetesDiary: TImage;
    lblIOB: TLabel;
    Line2: TLine;
    lvIOB: TListView;
    lblEmptyIOB: TLabel;
    tmrClipboard: TTimer;
    NC: TNotificationCenter;
    tmrWarning: TTimer;
    lbiAppBadge: TListBoxItem;
    chkAppBadge: TSwitch;
    procedure btnGlucoseClick(Sender: TObject);
    procedure btnCarbsClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure chkIOBSwitch(Sender: TObject);
    procedure chkAnimationsSwitch(Sender: TObject);
    procedure btnExerciseClick(Sender: TObject);
    procedure cboInsulinChange(Sender: TObject);
    procedure edtKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtTarget1Exit(Sender: TObject);
    procedure edtTarget2Exit(Sender: TObject);
    procedure edtTarget3Exit(Sender: TObject);
    procedure edtCarbExit(Sender: TObject);
    procedure edtCorrExit(Sender: TObject);
    procedure tbClick(Sender: TObject);
    procedure btnBack1Click(Sender: TObject);
    procedure lbiInsulinsClick(Sender: TObject);
    procedure btnBack2Click(Sender: TObject);
    procedure lvInsulinsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvInsulinsDeleteItem(Sender: TObject; AIndex: Integer);
    procedure lvInsulinsDeleteChangeVisible(Sender: TObject; AValue: Boolean);
    procedure btnAddClick(Sender: TObject);
    procedure btnDiabetesDiaryClick(Sender: TObject);
    procedure lvIOBDeleteItem(Sender: TObject; AIndex: Integer);
    procedure btnCarbsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnCarbsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure tmrClipboardTimer(Sender: TObject);
    procedure tmrWarningTimer(Sender: TObject);
    procedure chkAppBadgeSwitch(Sender: TObject);
  private
    FLog: TLog;
    FLock: Integer;
    FIndex: Integer;
    FCanClear: Boolean;
    FEatClick: Boolean;
    FSceneScale: Single;
    FDeleteVisible: Boolean;
    FControlMover: TControlMover;

    procedure Lock;
    procedure UnLock;
    function Locked: Boolean;

    function GetUnits: Integer;
    procedure SetUnits(Value: Integer);

    function GetCarbs: Integer;
    procedure SetCarbs(Value: Integer);

    function GetGlucose: REAL;
    procedure SetGlucose(Value: REAL);

    procedure Clear;
    function GetSceneScale: Single;
    function GetCalcImage(Value: TCalcImage): TImage;
    function GetButtonTime(btn: TSpeedButton): TInsulinTime;
    function ApplicationEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    procedure GetMoveControl(Sender: TObject; FocusedControl: TControl; var MoveControl: TControl);

    procedure UpdateIOB;
    procedure UpdateAppBadge;
    procedure UpdateInsulins;

    function GetLog: TLog;
    procedure LogChange(Sender: TObject);

    function GetIOB: string;
    function Calculate: Integer;
    procedure OnCalculate(Sender: TObject);

    procedure Log(const Value: string); overload;
    procedure Log(Format: string; Params: array of const); overload;

    property SceneScale: Single read GetSceneScale;
    property CalcImage[Value: TCalcImage]: TImage read GetCalcImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Units: Integer read GetUnits write SetUnits;
    property Carbs: Integer read GetCarbs write SetCarbs;
    property Glucose: REAL read GetGlucose write SetGlucose;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.iPhone47in.fmx IOS}
{$R *.iPhone55in.fmx IOS}
{$R *.iPhone.fmx IOS}
{$R *.iPhone4in.fmx IOS}

uses
  // Delphi
  System.IOUtils,
  System.SysUtils,
  System.DateUtils,
  Generics.Collections,
  // FireMonkey
{$IFDEF MACOS}
  Macapi.Helpers,
{$ENDIF}
{$IFDEF IOS}
  FMX.Helpers.iOS,
  FMX.Platform.iOS,
{$ENDIF}
  FMX.Dialogs,
  FMX.Graphics,
  // Project
  uInsulins,
  fKeyboard;

const
  ImgFileNameList: array[TCalcImage] of string = (
    'glucose64.png',
    'carbs64.png',
    'insulin64.png',
    'morning64.png',
    'day64.png',
    'evening64.png');

var
  CalcImageList: array[TCalcImage] of TImage = (
    nil, nil, nil, nil, nil, nil);

constructor TfrmMain.Create(AOwner: TComponent);

  function GetImgRect(Bitmap: TBitmap; Button: TControl): TRectF;
  var
    L, T, W, H: Single;
  begin
    W := Bitmap.Width  / SceneScale;
    H := Bitmap.Height / SceneScale;

    L := Line1.BoundsRect.Right - W;
    T := Button.Position.Y + ((Button.Height - H) / 2);

    Result := RectF(L, T, L + W, T + H);
  end;

var
  AE: IFMXApplicationEventService;
begin
  inherited Create(AOwner);

  FLock := 0;
  FLog := nil;
  FIndex := -1;
  FSceneScale := 0;
  FCanClear := True;
  FEatClick := False;
  FDeleteVisible := False;

  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService) then
  begin
    AE := IFMXApplicationEventService(TPlatformServices.Current.GetPlatformService(IFMXApplicationEventService));
    AE.SetApplicationEventHandler(ApplicationEvent);
  end;

  CalcImage[ciGlucose].Parent     := tabCalculate;
  CalcImage[ciGlucose].BoundsRect := GetImgRect(CalcImage[ciGlucose].Bitmap, rctGlucose);

  CalcImage[ciCarbs].Parent     := tabCalculate;
  CalcImage[ciCarbs].BoundsRect := GetImgRect(CalcImage[ciCarbs].Bitmap, rctCarbs);

  CalcImage[ciInsulin].Parent     := tabCalculate;
  CalcImage[ciInsulin].BoundsRect := GetImgRect(CalcImage[ciInsulin].Bitmap, rctInsulin);

  imgDiabetesDiary.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath, 'DD.png'));

  FControlMover := TControlMover.Create(Self);
  FControlMover.OnGetMoveControl := GetMoveControl;

  tabSettings2.ActiveTab := tabGeneral;
  if TabControl.ActiveTab = tabCalculate then
    TabControlChange(Self)
  else
    TabControl.ActiveTab := tabCalculate;

  tmrWarning.Enabled := Settings.FirstTime;
end;

destructor TfrmMain.Destroy;
begin
  if Assigned(FControlMover) then FControlMover.Free;
  if Assigned(FLog) then FLog.Free;
  inherited Destroy;
end;

function TfrmMain.GetUnits: Integer;
begin
  Result := StrToIntDef(lblUnits.Text, 0);
end;

procedure TfrmMain.SetUnits(Value: Integer);
begin
  lblUnits.Text := IntToStr(Value);
end;

function TfrmMain.GetCarbs: Integer;
begin
  Result := StrToIntDef(btnCarbs.Text, 0);
end;

procedure TfrmMain.SetCarbs(Value: Integer);
begin
  btnCarbs.Text := IntToStr(Value);
end;

function TfrmMain.GetGlucose: REAL;
begin
  Result := StrToFloat(btnGlucose.Text, FormatSettingsFloat);
end;

procedure TFrmMain.SetGlucose(Value: REAL);
begin
  btnGlucose.Text := Format('%.1f', [Value], FormatSettingsFloat);
end;

procedure TfrmMain.Clear;
begin
  Glucose := 0;

  if FCanClear then
    Carbs := 0;
  FCanClear := True;

  if btnExercise.Text <> '0' then
  begin
    btnExercise.Text := '';
    btnExerciseClick(btnExercise);
  end;
end;

function TfrmMain.ApplicationEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
var
  S: string;
  I: Integer;
begin
  if AAppEvent in [TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground] then
    UpdateAppBadge
  else
  if AAppEvent = TApplicationEvent.BecameActive then
  begin
    Clear;
    Calculate;
    UpdateIOB;
    lblIOB.Text := GetIOB;
  end
  else if AAppEvent = TApplicationEvent.OpenURL then
  begin
{$IFDEF IOS}
    if Assigned(AContext) then
      if AContext is TiOSOpenApplicationContext then
      begin
        S := TiOSOpenApplicationContext(AContext).URL;
        I := Pos('carbs=', S);
        if I > 0 then
        begin
          Delete(S, 1, I + 5);
          // delete non-numeric characters
          I := 0;
          while I < Length(S) do
            if S[I] in ['0'..'9'] then
              Inc(I)
            else
              Delete(S, I + 1, MaxInt);
          // do we have carbs?
          if S <> '' then
          begin
            btnCarbs.Text := S;
            FCanClear := False;
            Calculate;
          end;
        end;
      end;
{$ENDIF}
  end;
  Result := True;
end;

procedure TfrmMain.GetMoveControl(Sender: TObject; FocusedControl: TControl; var MoveControl: TControl);
var
  P: TFMXObject;
begin
  if Assigned(FocusedControl) then
    if Assigned(FocusedControl.Parent) then
      if FocusedControl.Parent is TListBoxItem then
      begin
        P := TListBoxItem(FocusedControl.Parent).Parent;
        while Assigned(P) and not(P is TListBox) do
          P := P.Parent;
        if Assigned(P) and (P is TListBox) then
          MoveControl := TListBox(P);
      end;
end;

function TfrmMain.GetCalcImage(Value: TCalcImage): TImage;
var
  BMP: TBitmap;
begin
  if CalcImageList[Value] = nil then
  begin
    CalcImageList[Value] := TImage.Create(Self);
    BMP := TBitmap.Create(64, 64);
    try
      BMP.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath, ImgFileNameList[Value]));
      CalcImageList[Value].Bitmap.Assign(BMP);
    finally
      BMP.Free;
    end;
  end;
  Result := CalcImageList[Value];
end;

function TfrmMain.GetButtonTime(btn: TSpeedButton): TInsulinTime;
begin
  Result := itMorning;
  if btn = btnDay then
    Result := itDay
  else if btn = btnEvening then
    Result := itEvening;
end;

function TfrmMain.GetLog: TLog;
begin
  if not Assigned(FLog) then
  begin
    FLog := TLog.Create;
    FLog.OnChange := LogChange;
  end;
  Result := FLog;
end;

procedure TfrmMain.UpdateAppBadge;
var
  I: Integer;
begin
  I := 0;
  if Settings.AppBadge then
    I := Round(GetLog.IOB);
  NC.ApplicationIconBadgeNumber := I;
end;

procedure TfrmMain.LogChange(Sender: TObject);
begin
  UpdateAppBadge;
end;

function TfrmMain.GetIOB: string;
const
  IOB = 'Insulin On Board: %.2f units (%.2d:%.2d hrs remaining)';
var
  Remaining: TDateTime;
begin
  GetLog.DeleteExpired;
  Remaining := GetLog.Remaining;
  if Remaining = 0 then
    Result := Format(IOB, [0.0, 0, 0], FormatSettingsFloat)
  else
    Result := Format(IOB, [GetLog.IOB, HourOf(Remaining), MinuteOf(Remaining)], FormatSettingsFloat);
end;

function TfrmMain.Calculate: Integer;
var
  R: REAL;
  I: Integer;
  CorrF: REAL;
  CarbF: Integer;
  IT: TInsulinTime;
  nGluco, nCorr: REAL;
begin
  Result := 0;

  R := Glucose;
  if (R < 4) or (R > 10) then
    btnGlucose.TextSettings.FontColor := TAlphaColorRec.Darkred
  else
    btnGlucose.TextSettings.FontColor := TAlphaColorRec.Null;

  R := 0;
  try
    IT := GetInsulinTime;

    if not btnAuto.IsPressed then
      for I := 0 to Pred(TB.ChildrenCount) do
        if TB.Children[I] is TSpeedButton then
          if TSpeedButton(TB.Children[I]) <> btnAuto then
            if TSpeedButton(TB.Children[I]).IsPressed then
            begin
              IT := GetButtonTime(TSpeedButton(TB.Children[I]));
              BREAK;
            end;

    CarbF := Settings.CarbF[IT];
    if CarbF = 0 then
      EXIT;

    R := Carbs / CarbF;

    CorrF := Settings.CorrF[IT];
    if CorrF = 0 then
      EXIT;

    nGluco := Glucose;
    if nGluco > 0 then
    begin
      nCorr := (nGluco - Settings.Target[IT]) / CorrF;
      if nCorr > 0 then
        if Settings.IOB then
        begin
          GetLog.DeleteExpired;
          nCorr := nCorr - GetLog.IOB;
          if nCorr < 0 then
            nCorr := 0;
        end;
      R := R + nCorr;
    end;

    I := StrToInt(btnExercise.Text);
    if I > 0 then
      R := R - ((R / 100) * I);
  finally
    if R < 0 then
      Result := 0
    else
      Result := Round(R);

    Units := Result;
  end;
end;

procedure TfrmMain.OnCalculate(Sender: TObject);
begin
  Calculate;
end;

procedure TfrmMain.TabControlChange(Sender: TObject);

  procedure InitBitmap(ABitmap: TBitmap; Value: TCalcImage);
  begin
    if ABitmap.IsEmpty then
      ABitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath, ImgFileNameList[Value]));
  end;

var
  I : Integer;
  IL: TObjectList<TInsulin>;
begin
  Lock;
  try
    if TabControl.ActiveTab = tabCalculate then
    begin
      Keyboard.Animations := Settings.Animations;

      cboInsulin.BeginUpdate;
      try
        cboInsulin.Clear;
        IL := Insulins.GetItems;
        try
          for I := 0 to Pred(IL.Count) do
            cboInsulin.Items.Add(IL[I].Name);
        finally
          IL.Free;
        end;
      finally
        cboInsulin.EndUpdate;
      end;
      cboInsulin.ItemIndex := 0;

      lblIOB.Text := GetIOB;
    end
    else if TabControl.ActiveTab = tabIOB then
    begin
      GetLog.DeleteExpired;
      UpdateIOB;
    end
    else if TabControl.ActiveTab = tabSettings1 then
    begin
      InitBitmap(lbiTarget1.ItemData.Bitmap, ciMorning);
      InitBitmap(lbiTarget2.ItemData.Bitmap, ciDay);
      InitBitmap(lbiTarget3.ItemData.Bitmap, ciEvening);

      edtTarget1.Text := Format('%.1f', [Settings.Target[itMorning]], FormatSettingsFloat);
      edtTarget2.Text := Format('%.1f', [Settings.Target[itDay]], FormatSettingsFloat);
      edtTarget3.Text := Format('%.1f', [Settings.Target[itEvening]], FormatSettingsFloat);

      InitBitmap(lbiCarb1.ItemData.Bitmap, ciMorning);
      InitBitmap(lbiCarb2.ItemData.Bitmap, ciDay);
      InitBitmap(lbiCarb3.ItemData.Bitmap, ciEvening);

      edtCarb1.Text := IntToStr(Settings.CarbF[itMorning]);
      edtCarb2.Text := IntToStr(Settings.CarbF[itDay]);
      edtCarb3.Text := IntToStr(Settings.CarbF[itEvening]);

      InitBitmap(lbiCorr1.ItemData.Bitmap, ciMorning);
      InitBitmap(lbiCorr2.ItemData.Bitmap, ciDay);
      InitBitmap(lbiCorr3.ItemData.Bitmap, ciEvening);

      edtCorr1.Text := Format('%.1f', [Settings.CorrF[itMorning]], FormatSettingsFloat);
      edtCorr2.Text := Format('%.1f', [Settings.CorrF[itDay]], FormatSettingsFloat);
      edtCorr3.Text := Format('%.1f', [Settings.CorrF[itEvening]], FormatSettingsFloat);

      chkIOB.IsChecked        := Settings.IOB;
      chkAppBadge.IsChecked   := Settings.AppBadge;
      chkAnimations.IsChecked := Settings.Animations;

      UpdateInsulins;
    end;
  finally
    UnLock;
  end;
end;

function TfrmMain.GetSceneScale: Single;
begin
  if FSceneScale = 0 then
    FSceneScale := TabControl.Scene.GetSceneScale;
  Result := FSceneScale;
end;

procedure TfrmMain.Log(const Value: string);
begin
  Log(Value, []);
end;

procedure TfrmMain.Log(Format: string; Params: array of const);
var
  LS: IFMXLoggingService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXLoggingService) then
  begin
    LS := IFMXLoggingService(TPlatformServices.Current.GetPlatformService(IFMXLoggingService));
    LS.Log(Format, Params);
  end;
end;

procedure TfrmMain.Lock;
begin
  Inc(FLock);
end;

procedure TfrmMain.UnLock;
begin
  if FLock > 0 then
    Dec(FLock);
end;

function TfrmMain.Locked: Boolean;
begin
  Result := FLock > 0;
end;

{ TfrmMain.tabCalculate }

procedure TfrmMain.tbClick(Sender: TObject);
begin
  Calculate;
end;

procedure TfrmMain.tmrClipboardTimer(Sender: TObject);
var
  S : string;
  I : Integer;
  E : Extended;
  CB: IFMXClipboardService;
begin
  tmrClipboard.Enabled := False;

  S := '';
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    CB := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    if not CB.GetClipboard.IsEmpty then
      S := CB.GetClipboard.ToString;
  end;

  if S <> '' then
  begin
    // if we have a comma decimal separator, replace this with a dot
    I := Pos(#44, S);
    while I > 0 do
    begin
      Delete(S, I, 1);
      Insert('.', S, I);
      I := Pos(#44, S);
    end;
    // delete non-numeric characters
    I := 0;
    while I < Length(S) do
      if S[I] in ['0'..'9', '.'] then
        Inc(I)
      else
        Delete(S, I + 1, 1);
    // if we have a number, round this to the next integer and paste into carbs
    if TextToFloat(S, E, FormatSettingsFloat) then
    begin
      Carbs := Round(E);
      FEatClick := True;
      Calculate;
    end;
  end;
end;

procedure TfrmMain.tmrWarningTimer(Sender: TObject);
resourcestring
  RS_FIRST_TIME = 'Always consult your physician or diabetes clinic before use and please adjust the settings before using the calculator for the first time.';
begin
  tmrWarning.Enabled := False;
  MessageDlg(RS_FIRST_TIME, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
end;

procedure TfrmMain.btnGlucoseClick(Sender: TObject);
begin
  if Sender is TButton then
    if Keyboard.Button = TButton(Sender) then
      Keyboard.Button := nil
    else
    begin
      Keyboard.Digits      := 2;
      Keyboard.Decimals    := 1;
      Keyboard.OnCalculate := OnCalculate;
      Keyboard.Button      := TButton(Sender);
      Calculate;
    end;
end;

procedure TfrmMain.btnCarbsClick(Sender: TObject);
begin
  if Sender is TButton then
    if Keyboard.Button = TButton(Sender) then
    begin
      Keyboard.Button := nil;
      FEatClick := False;
    end
    else
      if FEatClick then
        FEatClick := False
      else
      begin
        Keyboard.Digits      := 3;
        Keyboard.Decimals    := 0;
        Keyboard.OnCalculate := OnCalculate;
        Keyboard.Button      := TButton(Sender);
        Calculate;
      end;
end;

procedure TfrmMain.btnCarbsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  tmrClipboard.Enabled := True;
end;

procedure TfrmMain.btnCarbsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  tmrClipboard.Enabled := False;
end;

procedure TfrmMain.btnExerciseClick(Sender: TObject);
var
  I: Integer;
begin
  I := 0;

  if not(Sender is TButton) then
    EXIT;

  case StrToIntDef(TButton(Sender).Text, -1) of
    0 : I := 10;
    10: I := 25;
    25: I := 50;
  end;

  TButton(Sender).Text := IntToStr(I);

  if not Settings.Animations then
    pExercise.EndAngle := ((I / 100) * 360) - 90
  else
  begin
    aniExercise.StartValue := pExercise.EndAngle;
    aniExercise.StopValue  := ((I / 100) * 360) - 90;
    aniExercise.Start;
  end;

  Calculate;
end;

procedure TfrmMain.cboInsulinChange(Sender: TObject);
begin
  if cboInsulin.ItemIndex > -1 then
    lblInsulinName.Text := cboInsulin.Items[cboInsulin.ItemIndex];
end;

procedure TfrmMain.btnDiabetesDiaryClick(Sender: TObject);

  function GetInsulinIdent(AIndex: Integer): Integer;
  var
    I: TInsulin;
  begin
    Result := 0;
    I := Insulins.GetItemByIndex(AIndex);
    if Assigned(I) then
    try
      Result := I.Ident;
    finally
      I.Free;
    end;
  end;

var
  nUnits: Integer;
begin
  // insert new record into LOG
  nUnits := Units;
  if nUnits > 0 then
    GetLog.Add(nUnits, GetInsulinIdent(cboInsulin.ItemIndex));

{$IFDEF IOS}
  SharedApplication.openURL(StrToNSURL(
    Format('diabetesdiary://add/version/1/glucose:%s/carbs:%d/insulin:%d/insulin_type:%s',
    [IntToStr(Round(Glucose * 18.0182)), Carbs, nUnits, lblInsulinName.Text])
  ));
{$ENDIF}

  Clear;
  Calculate;
  lblIOB.Text := GetIOB;
end;

{ TfrmMain.tabIOB }

procedure TfrmMain.UpdateIOB;
var
  I: Integer;
  Insulin: TInsulin;
  DT1, DT2: TDateTime;
  LL: TObjectList<TLogItem>;
  nDelta1, nDelta2: Integer;
begin
  lvIOB.BeginUpdate;
  try
    lvIOB.Items.Clear;

    LL := GetLog.GetItems;
    try
      for I := 0 to Pred(LL.Count) do
        if LL[I].Units > 0 then
          if LL[I].Insulin > 0 then
          begin
            Insulin := Insulins.GetItemByIdent(LL[I].Insulin);
            if Assigned(Insulin) then
            try
              DT1 := LL[I].DateTime;
              DT2 := IncMinute(DT1, Insulin.Duration);

              nDelta1 := MinutesBetween(DT2, DT1);
              nDelta2 := MinutesBetween(DT2, Now) + 1;

              with lvIOB.Items.Add do
              begin
                Tag    := LL[I].Ident;
                Text   := Format('%.2d:%.2d', [HourOf(DT1), MinuteOf(DT1)]);
                Detail := Format('%.2f units %s ', [(LL[I].Units / nDelta1) * nDelta2, Insulin.Name], FormatSettingsFloat);
              end;
            finally
              Insulin.Free;
            end;
          end;
    finally
      LL.Free;
    end;
  finally
    lvIOB.EndUpdate;
  end;
  lvIOB.Visible := lvIOB.Items.Count > 0;
end;

procedure TfrmMain.lvIOBDeleteItem(Sender: TObject; AIndex: Integer);
begin
  GetLog.Delete(AIndex);
  lvIOB.Visible := lvIOB.Items.Count > 0;
end;

{ TfrmMain.tabSettings.tabGeneral }

procedure TfrmMain.edtKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (KeyChar = '.') and (TComponent(Sender).Tag = 0) then
    KeyChar := #0
  else
    if not(KeyChar in ['0'..'9', '.']) then
      KeyChar := #0;
end;

procedure TfrmMain.edtTarget1Exit(Sender: TObject);
var
  T: REAL;
begin
  T := StrToFloatDef(edtTarget1.Text, TARGET1, FormatSettingsFloat);
  edtTarget1.Text := Format('%.1f', [T], FormatSettingsFloat);
  Settings.Target[itMorning] := StrToFloat(edtTarget1.Text, FormatSettingsFloat);
end;

procedure TfrmMain.edtTarget2Exit(Sender: TObject);
var
  T: REAL;
begin
  T := StrToFloatDef(edtTarget2.Text, TARGET2, FormatSettingsFloat);
  edtTarget2.Text := Format('%.1f', [T], FormatSettingsFloat);
  Settings.Target[itDay] := StrToFloat(edtTarget2.Text, FormatSettingsFloat);
end;

procedure TfrmMain.edtTarget3Exit(Sender: TObject);
var
  T: REAL;
begin
  T := StrToFloatDef(edtTarget3.Text, TARGET3, FormatSettingsFloat);
  edtTarget3.Text := Format('%.1f', [T], FormatSettingsFloat);
  Settings.Target[itEvening] := StrToFloat(edtTarget3.Text, FormatSettingsFloat);
end;

procedure TfrmMain.edtCarbExit(Sender: TObject);
begin
  if Sender = edtCarb1 then
  begin
    edtCarb1.Text := IntToStr(StrToIntDef(edtCarb1.Text, CARB1));
    Settings.CarbF[itMorning] := StrToInt(edtCarb1.Text);
  end
  else if Sender = edtCarb2 then
  begin
    edtCarb2.Text := IntToStr(StrToIntDef(edtCarb2.Text, CARB2));
    Settings.CarbF[itDay] := StrToInt(edtCarb2.Text);
  end
  else if Sender = edtCarb3 then
  begin
    edtCarb3.Text := IntToStr(StrToIntDef(edtCarb3.Text, CARB3));
    Settings.CarbF[itEvening] := StrToInt(edtCarb3.Text);
  end;
end;

procedure TfrmMain.edtCorrExit(Sender: TObject);

  function GetDefault: Extended;
  begin
    if Sender = edtCorr1 then
      Result := CORR1
    else if Sender = edtCorr2 then
      Result := CORR2
    else
      Result := CORR3;
  end;

var
  T: REAL;
begin
  T := StrToFloatDef(TCustomEdit(Sender).Text, GetDefault, FormatSettingsFloat);
  TCustomEdit(Sender).Text := Format('%.1f', [T], FormatSettingsFloat);
  if Sender = edtCorr1 then
    Settings.CorrF[itMorning] := StrToFloat(edtCorr1.Text, FormatSettingsFloat)
  else if Sender = edtCorr2 then
    Settings.CorrF[itDay] := StrToFloat(edtCorr2.Text, FormatSettingsFloat)
  else if Sender = edtCorr3 then
    Settings.CorrF[itEvening] := StrToFloat(edtCorr3.Text, FormatSettingsFloat);
end;

procedure TfrmMain.lbiInsulinsClick(Sender: TObject);
begin
  tabSettings2.SetActiveTabWithTransition(tabInsulins,
    TTabTransition.Slide, TTabTransitionDirection.Normal);
end;

procedure TfrmMain.chkIOBSwitch(Sender: TObject);
begin
  if not Locked then
    Settings.IOB := chkIOB.IsChecked;
end;

procedure TfrmMain.chkAppBadgeSwitch(Sender: TObject);
begin
  if not Locked then
    Settings.AppBadge := chkAppBadge.IsChecked;
end;

procedure TfrmMain.chkAnimationsSwitch(Sender: TObject);
begin
  if not Locked then
    Settings.Animations := chkAnimations.IsChecked;
end;

{ TfrmMain.tabSettings.tabInsulins }

procedure TfrmMain.UpdateInsulins;
var
  I : Integer;
  IL: TObjectList<TInsulin>;
resourcestring
  RS_HOURS = 'Duration: %.1f hours';
begin
  lvInsulins.BeginUpdate;
  try
    lvInsulins.Items.Clear;
    IL := Insulins.GetItems;
    try
      for I := 0 to Pred(IL.Count) do
        with lvInsulins.Items.Add do
        begin
          Tag := IL[I].Ident;
          Text := IL[I].Name;
          Bitmap.Assign(CalcImageList[ciInsulin].Bitmap);
          Detail := Format(RS_HOURS, [IL[I].Duration / 60], FormatSettingsFloat);
        end;
    finally
      IL.Free;
    end;
  finally
    lvInsulins.EndUpdate;
  end;
end;

procedure TfrmMain.btnBack1Click(Sender: TObject);
begin
  tabSettings2.SetActiveTabWithTransition(tabGeneral,
    TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
begin
  edtName.Text     := '';
  edtDuration.Text := '';

  FIndex := -1;
  tabSettings2.SetActiveTabWithTransition(tabInsulin,
    TTabTransition.Slide, TTabTransitionDirection.Normal);
end;

procedure TfrmMain.lvInsulinsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  I: TInsulin;
begin
  if FDeleteVisible then
    EXIT;

  I := Insulins.GetItemByIdent(AItem.Tag);
  if Assigned(I) then
  try
    edtName.Text     := I.Name;
    edtDuration.Text := IntToStr(I.Duration);
  finally
    I.Free;
  end;

  FIndex := AItem.Index;
  tabSettings2.SetActiveTabWithTransition(tabInsulin,
    TTabTransition.Slide, TTabTransitionDirection.Normal);
end;

procedure TfrmMain.lvInsulinsDeleteChangeVisible(Sender: TObject;
  AValue: Boolean);
begin
  FDeleteVisible := not AValue;
end;

procedure TfrmMain.lvInsulinsDeleteItem(Sender: TObject; AIndex: Integer);
begin
  Insulins.Delete(AIndex);
end;

{ TfrmMain.tabSettings.tabInsulin }

procedure TfrmMain.btnBack2Click(Sender: TObject);
begin
  if  (edtName.Text <> '')
  and (edtDuration.Text <> '') then
    if FIndex = -1 then
      Insulins.Add(edtName.Text, StrToInt(edtDuration.Text))
    else
      Insulins.Edit(FIndex, edtName.Text, StrToInt(edtDuration.Text));

  UpdateInsulins;

  tabSettings2.SetActiveTabWithTransition(tabInsulins,
    TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

end.
