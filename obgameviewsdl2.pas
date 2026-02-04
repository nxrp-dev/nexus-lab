unit obGameViewSDL2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, obGameView, SDL2, SDL2_IMage, tpGame;

type

  { TGameViewSDL2 }

  TGameViewSDL2 = class(TGameView)
  private
    FWindow: PSDL_Window;
    FRenderer: PSDL_Renderer;
//    FSheet: PSDL_Texture;
    FTicks: integer;
  protected
    procedure InitGraphics; override;
    procedure ReleaseGraphics; override;
    procedure GenerateTexture(const AFilename: string; var AGameTexture: TGameTexture); override;
    procedure ReleaseTexture(var ATexture: TGameTexture); override;

    function ConvertClip(const ASource: TGameRect) : TSDL_Rect;
  public
    procedure BeginFrame; override;
    procedure EndFrame; override;
    procedure Paint; // kept for compatibility; calls EndFrame
    procedure CopySprite(ATexture: PGameTexture; ASource, ADestination: TGameRect); override;
  published
  end;

const
  cFrameMS = 16; // legacy; frame limiting now handled in the game loop

implementation

{ TGameViewSDL2 }

procedure TGameViewSDL2.InitGraphics;
begin
  SDL_Init(SDL_INIT_VIDEO);
  IMG_Init(IMG_INIT_PNG);

  FWindow := SDL_CreateWindow('Tile', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, FGameMechanics.ResolutionWidth, FGameMechanics.ResolutionHeight, SDL_WINDOW_SHOWN);
  FRenderer := SDL_CreateRenderer(FWindow, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  FTicks := SDL_GetTicks;
end;

procedure TGameViewSDL2.ReleaseGraphics;
begin
  SDL_DestroyRenderer(FRenderer);
  SDL_DestroyWindow(FWindow);
  IMG_Quit;
  SDL_Quit;
end;

procedure TGameViewSDL2.GenerateTexture(const AFilename: string;
  var AGameTexture: TGameTexture);
begin
  AGameTexture.Data := IMG_LoadTexture(FRenderer, PChar(AFilename));
end;

procedure TGameViewSDL2.ReleaseTexture(var ATexture: TGameTexture);
begin
  SDL_DestroyTexture(ATexture.Data);
end;

function TGameViewSDL2.ConvertClip(const ASource: TGameRect): TSDL_Rect;
begin
  Result.x := ASource.x;
  Result.y := ASource.y;
  Result.h := ASource.h;
  Result.w := ASource.w;
end;

procedure TGameViewSDL2.BeginFrame;
begin
  SDL_SetRenderDrawColor(FRenderer, 0, 0, 0, 255);
  SDL_RenderClear(FRenderer);
end;

procedure TGameViewSDL2.EndFrame;
begin
  SDL_RenderPresent(FRenderer);
  FTicks := SDL_GetTicks;
end;

procedure TGameViewSDL2.Paint;
begin
  EndFrame;
end;

procedure TGameViewSDL2.CopySprite(ATexture: PGameTexture; ASource, ADestination: TGameRect);
var
  lSrcClip, lDestClip: TSDL_Rect;
begin
  lSrcClip := ConvertClip(ASource);
  lDestClip := ConvertClip(ADestination);
  SDL_RenderCopy(FRenderer, ATexture^.Data, @lSrcClip, @lDestClip);
end;

end.

