unit merkezform;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FMX.Effects, math;

type
  TForm1 = class(TForm)
    Layoutbox: TLayout;
    PaintBoxgame: TPaintBox;
    Circlegamer: TCircle;
    FloatAnimationgame: TFloatAnimation;
    Button1: TButton;
    StyleBook1: TStyleBook;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Text1: TText;
    GlowEffect1: TGlowEffect;
    Timer1: TTimer;
    procedure PaintBoxgamePaint(Sender: TObject; Canvas: TCanvas);
    procedure CirclegamerPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure LayoutboxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure FloatAnimationgameProcess(Sender: TObject);
    procedure LayoutboxResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FloatAnimationgameFinish(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CirclegamerDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure LayoutboxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function center(const am, aC: tcontrol): tpointf;
    function newpos(s: Single): tpointf;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  a: integer;
  c: TCircle;

begin
  Button1.Visible := false;
  LayoutboxResize(nil);
  Circlegamer.TagFloat := 0;
  for a := PaintBoxgame.ChildrenCount - 1 downto 0 do
  begin
    if not(PaintBoxgame.Children[a] is TCircle) then
      Continue;
    c := TCircle(PaintBoxgame.Children[a]);

    case c.tag of
      1:
        c.Position.Point := newpos(c.Width);
      2:
        begin
          c.TagFloat := random * 10;
          c.Position.Point := newpos(c.Width);
          c.RotationCenter.Point := newpos(c.Width);
          c.Fill.Color := talphacolorf.Create(random,random,random, 0.8)
            .toalphacolor;
        end;

    end;

  end;

  FloatAnimationgame.Start;
end;

function TForm1.center(const am, aC: tcontrol): tpointf;
begin
  result := (pointf(am.Width, am.Height) - pointf(aC.Width, aC.Height)) * 0.5;
end;

procedure TForm1.CirclegamerDblClick(Sender: TObject);
begin
if form1.FullScreen=true then
begin
form1.FullScreen:= false;

end else

form1.FullScreen:= true;
end;

procedure TForm1.CirclegamerPainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  s: string;
begin
//  s := floattostrf(TCircle(Sender).TagFloat, tfloatformat.fffixed, 8, 0);
//  Canvas.FillText(ARect, s, false, 1, [], ttextalign.center);
end;

procedure TForm1.FloatAnimationgameFinish(Sender: TObject);
begin
  if (Circlegamer.width > screen.Width) then
    Button1.Text := 'Kazandýn'
  else
    Button1.Text := 'Kaybettin';
  Button1.Visible := true;

end;

procedure TForm1.FloatAnimationgameProcess(Sender: TObject);
var
  a: integer;
  c: TCircle;
  p1, p2, r: tpointf;

begin

  for a := PaintBoxgame.ChildrenCount - 1 downto 0 do
  begin
    if not(PaintBoxgame.Children[a] is TCircle) then
      Continue;
    c := TCircle(PaintBoxgame.Children[a]);

    if c.tag = 1 then
      Continue;
    if c.tag = 2 then
    begin
      p1 := c.BoundsRect.location;
      p2 := c.RotationCenter.Point;
      r := p1 - p2;
      if r.Length <= c.Width * 0.5 then
        c.RotationCenter.Point := newpos(c.Width);
      r := p1 - r.Normalize * (2.5 * 50 / c.Width);
      c.Position.Point := r;

    end;

    if c = Circlegamer then
    begin
      p1 := center(Layoutbox, Circlegamer);
      c.Position.Point := PaintBoxgame.AbsoluteToLocal(p1);
      p1 := Layoutbox.AbsoluteToLocal(c.RotationCenter.Point);
      p2 := Layoutbox.AbsoluteToLocal(pointf(Layoutbox.Width,
        Layoutbox.Height) * 0.5);
      r := p1 - p2;
      p1 := PaintBoxgame.Position.Point - r.Normalize * (r.Length / 25);
      p2 := p1 + pointf(PaintBoxgame.Width, PaintBoxgame.Height);
      if TRectF.Create(p1, p2)
        .contains(Layoutbox.AbsoluteToLocal(pointf(Layoutbox.Width,
        Layoutbox.Height) * 0.5)) then
        PaintBoxgame.Position.Point := p1;

    end;

  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  a: integer;
  c: TCircle;
begin
  Button1.Visible := false;
  RandSeed := 382712;
  a := 2000;
  PaintBoxgame.Width := a;
  PaintBoxgame.Height := a;

  for a := 1 to 1000 do
  begin
    c := TCircle(Circlegamer.clone(nil));
    c.tag := 1;
    c.Fill.Color := talphacolorf.Create(random, random, random).toalphacolor;
    c.Parent := PaintBoxgame;
    c.Width := 10;
    c.Height := 10;
    c.Position.Point := newpos(c.Width);
  end;

  for a := 1 to 100 do
  begin
    c := TCircle(Circlegamer.clone(nil));
    c.tag := 2;
    c.Fill.Color := talphacolorf.Create(random, random, random,0.8).toalphacolor;
    c.Parent := PaintBoxgame;
    c.Width := 50;
    c.Height := 50;
    c.TagFloat:= random *100;
    c.Position.Point := newpos(c.Width);
    c.RotationCenter.Point := newpos(c.Width);
    c.OnPaint := CirclegamerPainting;
  end;



  FloatAnimationgame.Start;
  Circlegamer.BringToFront;
end;

procedure TForm1.LayoutboxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
if FloatAnimationgame.Running
 then Circlegamer.RotationCenter.Point := Layoutbox.LocalToAbsolute(pointf(X, Y));
end;

procedure TForm1.LayoutboxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
//layoutbox.height:= layoutbox.Height- wheeldelta*100;
//layoutbox.Width:= layoutbox.Width- wheeldelta*100;
end;

procedure TForm1.LayoutboxResize(Sender: TObject);
begin
  PaintBoxgame.Position.Point := center(Layoutbox, PaintBoxgame);
  Circlegamer.Position.Point := center(Layoutbox, Circlegamer);
  Circlegamer.RotationCenter.Point := Circlegamer.Position.Point;
end;

function TForm1.newpos(s: Single): tpointf;
begin
  result := pointf(random * PaintBoxgame.Width - s * 0.5,
    random * PaintBoxgame.Height - s * 0.5);
end;

procedure TForm1.PaintBoxgamePaint(Sender: TObject; Canvas: TCanvas);
var
  T: TStrokebrush;
  a, s: integer;
  c, h: TCircle;
  f1, f2: tpointf;
  q: TRectF;
begin

  T := TStrokebrush.Create(tbrushkind.solid, talphacolors.Black);
  T.Thickness := 1;

  try

    f1 := pointf(PaintBoxgame.Width, PaintBoxgame.Height);
    s := trunc(f1.Length / 20);

    for a := 0 to s do
    begin
      Canvas.drawline(pointf(0, a * 20), pointf(f1.X, a * 20), 0.1, T);
      Canvas.drawline(pointf(a * 20, 0), pointf(a * 20, f1.Y), 0.1, T);
    end;

    for a := PaintBoxgame.ChildrenCount - 1 downto 0 do
    begin
      if not(PaintBoxgame.Children[a] is TCircle) then
        Continue;
      c := TCircle(PaintBoxgame.Children[a]);
      if c.tag = 1 then
        Continue;

      q := c.BoundsRect;

      for s := PaintBoxgame.ChildrenCount - 1 downto 0 do
      begin
        if not(PaintBoxgame.Children[s] is TCircle) then
          Continue;
        h := TCircle(PaintBoxgame.Children[s]);
        if h = c then
          Continue;
        if (h.tag = 1) and (q.contains(h.BoundsRect)) then
        begin
          c.TagFloat := c.TagFloat + 1;
          h.Position.Point := newpos(h.Width);
        end;

        if h.tag = 1 then
          Continue;

        if h.TagFloat >= c.TagFloat then
          Continue;
        if (q.CenterPoint - h.BoundsRect.CenterPoint).Length - c.Width * 0.5 <
          h.Width * 0.1 then
        begin
          c.TagFloat := c.TagFloat + h.TagFloat;
          h.TagFloat := 0;
          h.Position.Point := newpos(h.Width);

          if h = Circlegamer then
          begin
            FloatAnimationgame.Stop;
            break;
          end;
          h.RotationCenter.Point := newpos(h.Width);

        end;

      end;

      if (c.localrect.Width >= screen.Width) then

      begin
        if c = Circlegamer then
          FloatAnimationgame.Stop;
        c.TagFloat := 0;

      end;

      c.Width := 50 + (c.TagFloat / 5);
      c.Height := c.Width;

//      Canvas.drawrect(q, 0, 0, allcorners, 0.5, T);
//      f1 := PaintBoxgame.AbsoluteToLocal(c.AbsoluteRect.CenterPoint);
//      f2 := c.RotationCenter.Point + pointf(c.Width, c.Height) * 0.5;
//      if c = Circlegamer then
//        f2 := PaintBoxgame.AbsoluteToLocal(c.RotationCenter.Point);

//      Canvas.drawline(f1, f2, 0.3, T);
      // c.TagFloat:=(f1-f2).Length;
    end;

  finally
    freeandnil(T);
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
text1.Text:='puan: '+ trunc(circlegamer.Height/25).ToString;
end;

end.
