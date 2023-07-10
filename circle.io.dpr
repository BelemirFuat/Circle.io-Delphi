program circle.io;

uses
  System.StartUpCopy,
  FMX.Forms,
  introscreen in 'introscreen.pas' {Form2},
  merkezform in 'merkezform.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
