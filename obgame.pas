unit obGame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, obPlayer, sdl2, tpGame, obGameMechanics, obGameViewSDL2, obTileMap;

type
  TGame = class
  private
    FGameMechanics: TGameMechanics;
    FGameRunning: boolean;
    FPlayer: TPlayer;
    FMap: TMap;
    FGameView: TGameViewSDL2;
  protected
    procedure BuildTestMap;

  public
    property GameMechanics: TGameMechanics read FGameMechanics write FGameMechanics;

    constructor Create;
    destructor Destroy; override;
    procedure Run;
  published
  end;


implementation

constructor TGame.Create;
begin
  FGameMechanics := TGameMechanics.Create;
  FGameView := TGameViewSDL2.Create(FGameMechanics);
  FPlayer := TPlayer.Create(FGameMechanics, FGameView);
  FMap := TMap.Create;
end;

destructor TGame.Destroy;
begin
  FPlayer.Free;
  FGameMechanics.Free;
  FGameView.Free;
  FMap.Free;
  inherited Destroy;
end;

procedure TGame.BuildTestMap;
//var
//  x, y: Integer;
  //Tile: TMapTile;  // assuming TMapTile is your packed record type
begin
(*  FMap := TMap.Create(40, 30);  // or whatever size fits your view

  for y := 0 to FMap.Height - 1 do
  begin
    for x := 0 to FMap.Width - 1 do
    begin
      Tile := FMap.GetTile(x, y);

      // Default to floor
      FMap.SetTileType(Tile, 1);               // adjust number to your actual floor type
      FMap.SetSpriteIndex(Tile, 0);            // default sprite index – change as needed

      // Simple border walls (example)
      if (x = 0) or (x = FMap.Width - 1) or
         (y = 0) or (y = FMap.Height - 1) then
      begin
        FMap.SetTileType(Tile, 0);             // wall type
        FMap.SetSpriteIndex(Tile, 16);         // wall sprite index – adjust to your sheet
        // Optional: set traits/states
        // FMap.SetTrait(Tile, TRAIT_BLOCKS_MOVEMENT, True);
        // FMap.SetState(Tile, STATE_SOLID, True);
      end;

      // Optional: add some inner features
      if (x = 10) and (y = 10) then
      begin
        FMap.SetTileType(Tile, 2);             // e.g. door, pillar, water, etc.
        FMap.SetSpriteIndex(Tile, 32);
      end;

      // Write back the modified tile
      FMap.SetTile(x, y, Tile);
    end;
  end;*)
end;

procedure TGame.Run;
var
  lEvent: TSDL_Event;
  lTickPrev: UInt32;
  lTickNow: UInt32;
  lDelta: UInt32;
begin
  FGameRunning := true;

  lTickPrev := SDL_GetTicks;

  while FGameRunning do
  begin
    // Basic fixed-ish timestep: delay to ~60fps, then use the *actual* dt.
    lTickNow := SDL_GetTicks;
    lDelta := lTickNow - lTickPrev;
//    if lDelta < 16 then
//    begin
//      SDL_Delay(16 - lDelta);
//      lTickNow := SDL_GetTicks;
//      lDelta := lTickNow - lTickPrev;
//    end;
    lTickPrev := lTickNow;

    while SDL_PollEvent(@lEvent) = 1 do
    begin
      if lEvent.type_ = SDL_QUITEV then
        FGameRunning := False;

      if lEvent.type_ = SDL_KEYDOWN then
      begin
        case lEvent.key.keysym.sym of
          SDLK_LEFT:  FPlayer.Move(mdLeft);
          SDLK_RIGHT: FPlayer.Move(mdRight);
          SDLK_UP:    FPlayer.Move(mdUp);
          SDLK_DOWN:  FPlayer.Move(mdDown);
        end;
      end;
    end;

    FPlayer.Update(lDelta);

    FGameView.BeginFrame;
    FPlayer.Draw;
    FGameView.EndFrame;
  end;
end;

end.

