unit obGame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, obPlayer, sdl2, tpGame, obGameMechanics, obGameViewSDL2;

type
  TGame = class
  private
    FGameMechanics: TGameMechanics;
    FGameRunning: boolean;
    FPlayer: TPlayer;
    FGameView: TGameViewSDL2;
  protected
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
end;

destructor TGame.Destroy;
begin
  FPlayer.Free;
  FGameMechanics.Free;
  FGameView.Free;
  inherited Destroy;
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

