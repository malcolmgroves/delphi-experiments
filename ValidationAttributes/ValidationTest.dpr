program ValidationTest;

uses
  Forms,
  fMain in 'fMain.pas' {Form7},
  Validation in 'Validation.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
