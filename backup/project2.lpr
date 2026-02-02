program project2;

uses SDL2, SDL2_IMage;

const
  cTileW = 16;
  cTileH = 16;

var
  lWindow: PSDL_Window;
  lRenderer: PSDL_Renderer;
  lSheet: PSDL_Texture;
  lEvent: TSDL_Event;
  lSrc, lDst: TSDL_Rect;
  lRunning: Boolean;

  lX: Integer;
  lY: Integer;

begin
  SDL_Init(SDL_INIT_VIDEO);
  IMG_Init(IMG_INIT_PNG);

  lWindow := SDL_CreateWindow('Tile', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 480, SDL_WINDOW_SHOWN);
  lRenderer := SDL_CreateRenderer(lWindow, -1, SDL_RENDERER_ACCELERATED);

  lSheet := IMG_LoadTexture(lRenderer, PChar('floors_tiles.png'));

  // tile (0,1) in 0-based tile coordinates
  lSrc.x := 0 * cTileW;
  lSrc.y := 1 * cTileH;
  lSrc.w := cTileW;
  lSrc.h := cTileH;

  lX := 100;
  lY := 100;

  lDst.w := cTileW;
  lDst.h := cTileH;

  lRunning := True;
  while lRunning do
  begin
    while SDL_PollEvent(@lEvent) = 1 do
    begin
      if lEvent.type_ = SDL_QUITEV then
        lRunning := False;

      if lEvent.type_ = SDL_KEYDOWN then
      begin
        case lEvent.key.keysym.sym of
          SDLK_LEFT:  lX := lX - cTileW;
          SDLK_RIGHT: lX := lX + cTileW;
          SDLK_UP:    lY := lY - cTileH;
          SDLK_DOWN:  lY := lY + cTileH;
        end;
      end;
    end;

    lDst.x := lX;
    lDst.y := lY;

    SDL_SetRenderDrawColor(lRenderer, 0, 0, 0, 255);
    SDL_RenderClear(lRenderer);

    SDL_RenderCopy(lRenderer, lSheet, @lSrc, @lDst);

    SDL_RenderPresent(lRenderer);
  end;

  SDL_DestroyTexture(lSheet);
  SDL_DestroyRenderer(lRenderer);
  SDL_DestroyWindow(lWindow);

  IMG_Quit;
  SDL_Quit;
end.

