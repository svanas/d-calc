unit fKeyboard;

interface

uses
  // Delphi
  System.Classes,
  // FireMonkey
  FMX.Ani,
  FMX.Forms,
  FMX.Types,
  FMX.Objects,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TfrmKeyboard = class(TForm)
    pnlCallout: TCalloutPanel;
    aniTop: TFloatAnimation;
    aniHeight: TFloatAnimation;
    aniOpacity: TFloatAnimation;
    rct1: TRoundRect;
    btn1: TButton;
    rct2: TRoundRect;
    btn2: TButton;
    rct3: TRoundRect;
    btn3: TButton;
    rct4: TRoundRect;
    btn4: TButton;
    rct5: TRoundRect;
    btn5: TButton;
    rct6: TRoundRect;
    btn6: TButton;
    rct7: TRoundRect;
    btn7: TButton;
    rct8: TRoundRect;
    btn8: TButton;
    rct9: TRoundRect;
    btn9: TButton;
    rctAC: TRoundRect;
    btnAC: TButton;
    rct0: TRoundRect;
    btn0: TButton;
    rctOK: TRoundRect;
    btnOK: TButton;
    procedure btnNumClick(Sender: TObject);
    procedure btnACClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FButton: TButton;
    FDigits: Integer;
    FDecimals: Integer;
    FAnimations: Boolean;
    FOnCalculate: TNotifyEvent;
    procedure Clear;
    procedure Calculate;
    procedure KeyPress(Value: Integer);
    procedure SetButton(Value: TButton);
  public
    constructor Create(AOwner: TComponent); override;
    property Digits: Integer read FDigits write FDigits;
    property Button: TButton read FButton write SetButton;
    property Decimals: Integer read FDecimals write FDecimals;
    property Animations: Boolean read FAnimations write FAnimations;
    property OnCalculate: TNotifyEvent read FOnCalculate write FOnCalculate;
  end;

var
  frmKeyboard: TfrmKeyboard;

function Keyboard: TfrmKeyboard;

implementation

{$R *.fmx}
{$R *.iPhone47in.fmx IOS}
{$R *.iPhone55in.fmx IOS}
{$R *.iPhone.fmx IOS}
{$R *.iPhone4in.fmx IOS}

uses
  // Delphi
  System.SysUtils,
  // Project
  uSettings;

var
  varKeyboard: TfrmKeyboard = nil;

function Keyboard: TfrmKeyboard;
begin
  if not Assigned(varKeyboard) then
    varKeyboard := TfrmKeyboard.Create(Application);
  Result := varKeyboard;
end;

function GetContainer(AComponent: TFMXObject): TControl;
var
  P: TFMXObject;
begin
  Result := nil;
  P := AComponent;
  while Assigned(P) do
  begin
    if P is TContent then
      EXIT;
    if P is TCommonCustomForm then
      EXIT;
    if P is TControl then
      Result := TControl(P);
    P := P.Parent;
  end;
end;

function GetParentTab(AComponent: TFMXObject): TContent;
var
  P: TFMXObject;
begin
  Result := nil;
  P := AComponent.Parent;
  while Assigned(P) do
  begin
    if P is TContent then
    begin
      Result := TContent(P);
      EXIT;
    end;
    P := P.Parent;
  end;
end;

function GetParentForm(AComponent: TFMXObject): TCommonCustomForm;
var
  P: TFMXObject;
begin
  Result := nil;
  P := AComponent.Parent;
  while Assigned(P) do
  begin
    if P is TCommonCustomForm then
    begin
      Result := TCommonCustomForm(P);
      EXIT;
    end;
    P := P.Parent;
  end;
end;

function GetAnimation(AControl: TControl; const PropertyName: string): TFloatAnimation;
var
  I: Integer;
begin
  for I := 0 to Pred(AControl.ChildrenCount) do
    if AControl.Children[I] is TFloatAnimation then
      if TFloatAnimation(AControl.Children[I]).PropertyName = PropertyName then
      begin
        Result := TFloatAnimation(AControl.Children[I]);
        EXIT;
      end;
  Result := nil;
end;

function GetAnimationTop(AControl: TControl): TFloatAnimation;
begin
  Result := GetAnimation(AControl, 'Position.Y');
end;

function GetAnimationHeight(AControl: TControl): TFloatAnimation;
begin
  Result := GetAnimation(AControl, 'Height');
end;

function GetAnimationOpacity(AControl: TControl): TFloatAnimation;
begin
  Result := GetAnimation(AControl, 'Opacity');
end;

{ TfrmKeyboard}

constructor TfrmKeyboard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAnimations := True;
  FButton := nil;
end;

procedure TfrmKeyboard.Calculate;
begin
  if Assigned(FOnCalculate) then
    FOnCalculate(Self);
end;

procedure TfrmKeyboard.SetButton(Value: TButton);
var
  aTop, aHeight, aOpacity: TFloatAnimation;
begin
  if Value <> FButton then
  begin
    FButton := Value;

    aTop     := nil;
    aHeight  := nil;
    aOpacity := nil;

    if Assigned(FButton) then
    begin
      Clear;

      pnlCallout.Parent := GetParentTab(FButton);

      pnlCallout.Position.Y := GetContainer(FButton).Position.Y + FButton.Height - 6;
      pnlCallout.Height := GetParentTab(FButton).Height - pnlCallout.Position.Y - 3;

      if FAnimations then
      begin
        // get TFloatAnimation for Position.Y
        aTop := GetAnimationTop(pnlCallout);
        if Assigned(aTop) then
        begin
          aTop.StartValue := GetParentTab(FButton).Height - 3;
          aTop.StopValue  := GetContainer(FButton).Position.Y + FButton.Height - 6;
        end;
        // get TFloatAnimation for Height
        aHeight := GetAnimationHeight(pnlCallout);
        if Assigned(aHeight) then
        begin
          aHeight.StartValue := 0;
          aHeight.StopValue  := GetParentTab(FButton).Height - pnlCallout.Position.Y - 3;
        end;
        // get TFloatAnimation for Opacity
        aOpacity := GetAnimationOpacity(pnlCallout);
        if Assigned(aOpacity) then
        begin
          aOpacity.StartValue := 0;
          aOpacity.StopValue  := 1;
        end;
      end
      else
        pnlCallout.Opacity := 1;

      pnlCallout.Visible := True;
    end
    else
      if FAnimations then
      begin
        // get TFloatAnimation for Position.Y
        aTop := GetAnimationTop(pnlCallout);
        if Assigned(aTop) then
        begin
          aTop.StartValue := pnlCallout.Position.Y;
          aTop.StopValue  := GetParentTab(pnlCallout).Height - 3;
        end;
        // get TFloatAnimation for Height
        aHeight := GetAnimationHeight(pnlCallout);
        if Assigned(aHeight) then
        begin
          aHeight.StartValue := pnlCallout.Height;
          aHeight.StopValue  := 0;
        end;
        // get TFloatAnimation for Opacity
        aOpacity := GetAnimationOpacity(pnlCallout);
        if Assigned(aOpacity) then
        begin
          aOpacity.StartValue := 1;
          aOpacity.StopValue  := 0;
        end;
      end
      else
        pnlCallout.Visible := False;

    if Assigned(aTop) then
      aTop.Start;
    if Assigned(aHeight) then
      aHeight.Start;
    if Assigned(aOpacity) then
      aOpacity.Start;
  end;
end;

procedure TfrmKeyboard.Clear;
begin
  if not Assigned(FButton) then
    EXIT;
  FButton.Text := '0';
  if FDecimals > 0 then
    FButton.Text := FButton.Text + '.0';
end;

procedure TfrmKeyboard.KeyPress(Value: Integer);
var
  I: Integer;
  D1, D2: string;
begin
  if not Assigned(FButton) then
    EXIT;

  if (FButton.Text <> '') and (StrToFloat(FButton.Text, FormatSettingsFloat) = 0) then
    FButton.Text := '';

  if FDecimals = 0 then
  begin
    if Length(FButton.Text) < FDigits then
      FButton.Text := FButton.Text + IntToStr(Value);
    EXIT;
  end;

  D1 := '0';
  D2 := '0';

  if FButton.Text <> '' then
  begin
    I := Pos('.', FButton.Text);
    if I > 0 then
    begin
      D1 := Copy(FButton.Text, 1, I - 1);
      D2 := Copy(FButton.Text, I + 1, MaxInt);
    end;
  end;

  if (StrToIntDef(D1, 0) = 0) and ((StrToIntDef(D2, 0) = 0) or (Length(D2) < FDecimals)) then
  begin
    FButton.Text := D1 + '.';
    if StrToIntDef(D2, 0) <> 0 then
      FButton.Text := FButton.Text + D2;
    FButton.Text := FButton.Text + IntToStr(Value);
    EXIT;
  end;

  if (StrToIntDef(D1, 0) = 0) or (Length(D1) < FDigits) then
  begin
    FButton.Text := '';
    if StrToIntDef(D1, 0) <> 0 then
      FButton.Text := D1;
    if D2 <> '' then
      FButton.Text := FButton.Text + D2[Low(D2)];
    FButton.Text := FButton.Text + '.';
    for I := 1 to Pred(Length(D2)) do
      FButton.Text := FButton.Text + D2[I];
    FButton.Text := FButton.Text + IntToStr(Value);
    EXIT;
  end;
end;

procedure TfrmKeyboard.btnNumClick(Sender: TObject);
begin
  if Sender is TButton then
    KeyPress(StrToInt(TButton(Sender).Text));
  Calculate;
end;

procedure TfrmKeyboard.btnACClick(Sender: TObject);
begin
  Clear;
  Calculate;
end;

procedure TfrmKeyboard.btnOKClick(Sender: TObject);
begin
  Button := nil;
end;

end.
