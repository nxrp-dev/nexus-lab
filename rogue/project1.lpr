program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  obTileMap, tpTileMap, csTileMap, obGame, obGameView, obTilesetIndex, obPlayer,
  tpGame, obGameMechanics, obGameViewSDL2, obCharacterIndex, obRecordCache,
  obTerrain, tpGridArray, obGameLayer, obContainers
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

