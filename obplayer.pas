unit obPlayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, tpGame, obGameMechanics, obGameView;

type

  { TPlayer }

  TPlayer = class
  private
    FGameMechanics: TGameMechanics;
    FGameView: TGameView;
    FPlayerTexture: PGameTexture;
    // --- Logical (tile) position ---
    FPosition: TLocation;
    FTarget: TLocation;

    // --- Render (pixel) position ---
    FPixelX: Single;
    FPixelY: Single;

    // --- Movement timing/state ---
    FIsMoving: Boolean;
    FMoveElapsed: Single;   // seconds (or ms if you prefer; keep consistent)
    FMoveDuration: Single;  // seconds


    FPixelHeight: integer;
    FPixelWidth: integer;

    function GetPixelPosition: TLocationDouble;
    procedure SetPosition(AValue: TLocation);
    procedure SetTarget(AValue: TLocation);
  public
    // Tile-space
    property Position: TLocation read FPosition write SetPosition;
    property Target: TLocation read FTarget write SetTarget;

    property PixelPosition: TLocationDouble read GetPixelPosition;

    procedure Move(ADirection: TMoveDirection);

    // Pixel-space (what you draw)
    property PixelX: Single read FPixelX;
    property PixelY: Single read FPixelY;

    // Movement state
    property IsMoving: Boolean read FIsMoving;
    property MoveElapsed: Single read FMoveElapsed;
    property MoveDuration: Single read FMoveDuration write FMoveDuration;


    function GetTileClip: TGameRect;

    procedure Update;

    constructor Create; virtual; overload;
    constructor Create(AGameMechanics: TGameMechanics; AGameView: TGameView); virtual; overload;
    destructor Destroy; override;
  end;

implementation

procedure TPlayer.SetTarget(AValue: TLocation);
begin
  FTarget.X := AValue.X;
  FTarget.Y := AValue.Y;
end;

procedure TPlayer.Move(ADirection: TMoveDirection);
var
  lDst: TGameRect;
begin
  case ADirection of
    mdLeft:  FPosition.X := Position.X - 1;
    mdRight: FPosition.X := Position.X + 1;
    mdUp:    FPosition.Y := Position.Y - 1;
    mdDown:  FPosition.Y := Position.Y + 1;
  end;

  lDst.w := FPixelWidth;
  lDst.h := FPixelHeight;
  lDst.x := Position.X * FGameMechanics.TileWidth;
  lDst.y := Position.Y * FGameMechanics.TileHeight;

  FGameView.CopySprite(FPlayerTexture, GetTileClip, lDst);
end;

function TPlayer.GetTileClip: TGameRect;
begin
  Result.x := 0;
  Result.y := 0;
  Result.w := FPixelWidth;
  Result.h := FPixelHeight;
end;

procedure TPlayer.Update;
begin

end;

procedure TPlayer.SetPosition(AValue: TLocation);
begin
  FPosition.X := AValue.X;
  FPosition.Y := AValue.Y;
end;

function TPlayer.GetPixelPosition: TLocationDouble;
begin
  Result.x := Position.X * FGameMechanics.TileWidth;
  Result.y := Position.Y * FGameMechanics.TileHeight;
end;

constructor TPlayer.Create;
begin
  raise Exception.Create('You need to instantiate TPlayer with GameMechanics');
end;

constructor TPlayer.Create(AGameMechanics: TGameMechanics; AGameView: TGameView);
begin
  Position := Location(0, 0);
  FGameMechanics := AGameMechanics;
  FPixelHeight := 36;
  FPixelWidth := 26;
  FGameView := AGameView;
  FPlayerTexture := FGameView.LoadTexture('sheet_winnersa_1.png');
end;

destructor TPlayer.Destroy;
begin
  inherited Destroy;
end;

end.

