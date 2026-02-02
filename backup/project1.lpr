program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
//  Interfaces, // this includes the LCL widgetset
//  Forms,
  obTileMap, tpTileMap, csTileMap, obGame, obGameView, obTilesetIndex, obPlayer,
  tpGame, obGameMechanics, obGameViewSDL2, obCharacterIndex, obHashRefCache
  { you can add units after this };

{$R *.res}
var
  lGame: TGame;

begin
  lGame := TGame.Create;
  try
    lGame.Run;
  finally
    lGame.Free;
  end;
end.

