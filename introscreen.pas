unit introscreen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, merkezform,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FMX.Colors;

type
  TForm2 = class(TForm)
    Text1: TText;
    Button1: TButton;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    FloatAnimation1: TFloatAnimation;
    StyleBook1: TStyleBook;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ComboColorBox1: TComboColorBox;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
merkezform.Form1.Show;
merkezform.form1.circlegamer.fill.color:= combocolorbox1.color;
end;

end.
