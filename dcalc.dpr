program dcalc;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  uLog in 'uLog.pas',
  uDatabase in 'uDatabase.pas',
  uSettings in 'uSettings.pas',
  uInsulins in 'uInsulins.pas',
  uControlMover in 'uControlMover.pas',
  fMain in 'fMain.pas' {frmMain},
  fKeyboard in 'fKeyboard.pas' {frmKeyboard};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
