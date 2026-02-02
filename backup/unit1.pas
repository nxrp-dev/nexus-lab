unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  obTileMap, csTileMap, obGame, obGameView;

type

  { TGame }
  TPlayer = class
  private
  protected
  public
  published
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TGame }

{ TMap }

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMap.Create;
end;

end.

