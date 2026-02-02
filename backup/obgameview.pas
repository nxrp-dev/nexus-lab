unit obGameView;

{$mode ObjFPC}{$H+}
{$modeswitch advancedrecords}

interface

uses
  Classes, SysUtils, obGameMechanics, fgl, obRecordCache, tpGame;

type
  { Generic roguelike "view":
    - Knows the pixel size of the viewport (PixelWidth/PixelHeight)
    - Knows the sprite/tile size (SpriteWidth/SpriteHeight)
    - Converts Cell(X,Y) -> Pixel(X,Y)
    - Exposes high-level draw calls in *cell space*
    - Leaves the actual low-level drawing of a sprite at pixel coords to descendants
  }
  { TGameView }
  TTextureHandle = integer;
  TGameTexture = record
    Handle: integer;
    Data: pointer; // up to the engine to case accordingly;
    class operator =(const A, B: TGameTexture): Boolean;
  end;
  PGameTexture = ^TGameTexture;

  TTextureCache = specialize TRecordCache<TGameTexture>;
  { TTextureMap }

  TGameView = class(TObject)
  private
    FTextureCache: TTextureCache;

    FPixelWidth: Integer;
    FPixelHeight: Integer;

    FSpriteWidth: Integer;
    FSpriteHeight: Integer;

    FOriginX: Integer;
    FOriginY: Integer;

    function GetColumns: Integer; inline;
    function GetRows: Integer; inline;

    // --- Coordinate conversion ---
    procedure CellToPixel(const ACellX, ACellY: Integer; out APixelX, APixelY: Integer); inline;
    // (Sometimes useful) draw directly at pixel coords through the same abstraction.
//    procedure DrawSpriteAtPixel(const ASprite: TSprite; const APixelX, APixelY: Integer); inline;
  protected
    FGameMechanics: TGameMechanics;
    // Descendants implement this: "draw ASprite with its top-left corner at (APixelX, APixelY)"
//    procedure DrawSpritePixels(const ASprite: TSprite; const APixelX, APixelY: Integer); virtual; abstract;

    // Hook if a backend needs to react to size changes (optional).
    procedure OnMetricsChanged; virtual;

    procedure SetPixelSize(const APixelWidth, APixelHeight: Integer);
    procedure SetSpriteSize(const ASpriteWidth, ASpriteHeight: Integer);
    procedure SetOrigin(const AOriginX, AOriginY: Integer);

    procedure InitGraphics; virtual; abstract;
    procedure ReleaseGraphics; virtual; abstract;

    procedure GenerateTexture(const AFilename: string; var AGameTexture: TGameTexture); virtual; abstract;
    procedure ReleaseTexture(var AGameTexture: TGameTexture); virtual; abstract;

    procedure DoAfterCreate(const AKey: ShortString; var AValue: TGameTexture);
    procedure DoBeforeFree(const AKey: ShortString; var AValue: TGameTexture);
  public
    constructor Create(AGameMechanics: TGameMechanics); virtual; overload;
    constructor Create;
    destructor Destroy; override;
    // --- Metrics ---

    function LoadTexture(const AFilename: string): PGameTexture;
    procedure FreeTexture(const AFilename: string);

    property TextureCache: TTextureCache read FTextureCache;
    property PixelWidth: Integer read FPixelWidth;
    property PixelHeight: Integer read FPixelHeight;

    property SpriteWidth: Integer read FSpriteWidth;
    property SpriteHeight: Integer read FSpriteHeight;

    // Pixel offset for where cell (0,0) begins inside the view.
    property OriginX: Integer read FOriginX;
    property OriginY: Integer read FOriginY;

    // Derived grid dimensions based on PixelSize/SpriteSize (integer fit).
    property Columns: Integer read GetColumns;
    property Rows: Integer read GetRows;

    procedure CopySprite(ATexture: PGameTexture; ASource, ADestination: TGameRect); virtual; abstract;

    // --- High-level roguelike draw call ---
//    procedure DrawSpriteAtCell(const ASprite: TSprite; const ACellX, ACellY: Integer); inline;

  end;

implementation

class operator TGameTexture.=(const A, B: TGameTexture): Boolean;
begin
  Result := (A.Data = B.Data);
end;

{ TTextureMap }

constructor TGameView.Create(AGameMechanics: TGameMechanics);
begin
  inherited Create;

  FTextureCache := TTextureCache.Create;
  FTextureCache.OnAfterCreate := @DoAfterCreate;
  FTextureCache.OnBeforeFree := @DoBeforeFree;
  FGameMechanics := AGameMechanics;
  InitGraphics;
end;

constructor TGameView.Create;
begin
  inherited Create;
  raise Exception.Create('You must call the constructor with TGameMechanics.');
end;

destructor TGameView.Destroy;
begin
  ReleaseGraphics;
  FTextureCache.Free;
  inherited Destroy;
end;

procedure TGameView.OnMetricsChanged;
begin
  // default no-op
end;

procedure TGameView.SetPixelSize(const APixelWidth, APixelHeight: Integer);
begin
  if (APixelWidth < 0) or (APixelHeight < 0) then
    raise Exception.Create('Pixel size must be >= 0.');

  FPixelWidth := APixelWidth;
  FPixelHeight := APixelHeight;

  OnMetricsChanged;
end;

procedure TGameView.SetSpriteSize(const ASpriteWidth, ASpriteHeight: Integer);
begin
  if (ASpriteWidth <= 0) or (ASpriteHeight <= 0) then
    raise Exception.Create('Sprite size must be > 0.');

  FSpriteWidth := ASpriteWidth;
  FSpriteHeight := ASpriteHeight;

  OnMetricsChanged;
end;

procedure TGameView.SetOrigin(const AOriginX, AOriginY: Integer);
begin
  FOriginX := AOriginX;
  FOriginY := AOriginY;

  OnMetricsChanged;
end;

procedure TGameView.DoAfterCreate(const AKey: ShortString; var AValue: TGameTexture);
begin
  GenerateTexture(AKey, AValue);
end;

procedure TGameView.DoBeforeFree(const AKey: ShortString; var AValue: TGameTexture);
begin
  ReleaseTexture(AValue);
end;

function TGameView.LoadTexture(const AFilename: string): PGameTexture;
var
  lCreated: boolean;
begin
  Result := @FTextureCache.Acquire(AFilename, lCreated)^.Value;
  if lCreated then
  begin
    GenerateTexture(AFilename, Result^);
  end;
end;

procedure TGameView.FreeTexture(const AFilename: string);
begin

end;

function TGameView.GetColumns: Integer;
var
  lUsable: Integer;
begin
  if FSpriteWidth <= 0 then
    Exit(0);

  lUsable := FPixelWidth - FOriginX;
  if lUsable <= 0 then
    Exit(0);

  Result := lUsable div FSpriteWidth;
end;

function TGameView.GetRows: Integer;
var
  lUsable: Integer;
begin
  if FSpriteHeight <= 0 then
    Exit(0);

  lUsable := FPixelHeight - FOriginY;
  if lUsable <= 0 then
    Exit(0);

  Result := lUsable div FSpriteHeight;
end;

procedure TGameView.CellToPixel(const ACellX, ACellY: Integer; out APixelX, APixelY: Integer);
begin
  APixelX := FOriginX + (ACellX * FSpriteWidth);
  APixelY := FOriginY + (ACellY * FSpriteHeight);
end;

(*procedure TGameView.DrawSpriteAtCell(const ASprite: TSprite; const ACellX, ACellY: Integer);
var
  lPixelX: Integer;
  lPixelY: Integer;
begin
  CellToPixel(ACellX, ACellY, lPixelX, lPixelY);
  DrawSpritePixels(ASprite, lPixelX, lPixelY);
end;

procedure TGameView.DrawSpriteAtPixel(const ASprite: TSprite; const APixelX, APixelY: Integer);
begin
  DrawSpritePixels(ASprite, APixelX, APixelY);
end;
*)
end.

