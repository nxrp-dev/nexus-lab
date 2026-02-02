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
begin
  FGameRunning := true;

  while FGameRunning do
  begin
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

    FPlayer.Update;
    FGameView.Paint;
  end;
end;

end.

