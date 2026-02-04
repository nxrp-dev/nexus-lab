unit obPlayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, tpGame, obGameMechanics, obGameView;

type

  // Minimal animation state for the player.
  // (We can later replace/augment this with your obCharacterIndex-driven system.)
  TPlayerAnimState = (pasIdle, pasWalk);

  // RPG-Maker style row order: Down, Left, Right, Up
  TPlayerFacing = (pfDown, pfLeft, pfRight, pfUp);

  { TPlayer }

  TPlayer = class
  private
    FGameMechanics: TGameMechanics;
    FGameView: TGameView;
    FPlayerTexture: PGameTexture;
    // --- Logical (tile) position ---
    FPosition: TLocation;
    FTarget: TLocation;

    // --- Render (pixel) position (sub-tile precision) ---
    FPixelX: Double;
    FPixelY: Double;

    // --- Animation ---
    FAnimState: TPlayerAnimState;
    FFacing: TPlayerFacing;
    FAnimAccumMS: UInt32;
    FWalkPhase: Integer; // 0..3 (0,1,2,1)

    // --- Movement interpolation ---
    FMoveStartPixelX: Double;
    FMoveStartPixelY: Double;

    // --- Movement timing/state ---
    FIsMoving: Boolean;
    FMoveElapsed: Double;   // milliseconds
    FMoveDuration: Double;  // milliseconds


    FPixelHeight: integer;
    FPixelWidth: integer;

    function GetPixelPosition: TLocationDouble;
    function FacingToRow: Integer; inline;
    function GetDrawX: Integer; inline;
    function GetDrawY: Integer; inline;
    procedure SetPosition(AValue: TLocation);
    procedure SetTarget(AValue: TLocation);
    procedure StartMoveToTarget;
    procedure SetFacingFromMove(ADirection: TMoveDirection);
  public
    // Tile-space
    property Position: TLocation read FPosition write SetPosition;
    property Target: TLocation read FTarget write SetTarget;

    property PixelPosition: TLocationDouble read GetPixelPosition;

    // Request a move. If we're already moving, it will be ignored for now.
    procedure Move(ADirection: TMoveDirection);

    // Pixel-space (what you draw)
    property PixelX: Double read FPixelX;
    property PixelY: Double read FPixelY;

    // Movement state
    property IsMoving: Boolean read FIsMoving;
    property MoveElapsed: Double read FMoveElapsed;
    property MoveDuration: Double read FMoveDuration write FMoveDuration;


    function GetTileClip: TGameRect;

    // Animation + movement update. Delta is in milliseconds.
    procedure Update(ADeltaMS: UInt32); overload;
    procedure Update; overload; // legacy no-arg calls Update(0)

    procedure Draw;

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
begin
  // Original immediate-draw move (kept for comparison):
  //
  // var
  //   lDst: TGameRect;
  // begin
  //   case ADirection of
  //     mdLeft:  FPosition.X := Position.X - 1;
  //     mdRight: FPosition.X := Position.X + 1;
  //     mdUp:    FPosition.Y := Position.Y - 1;
  //     mdDown:  FPosition.Y := Position.Y + 1;
  //   end;
  //
  //   lDst.w := FPixelWidth;
  //   lDst.h := FPixelHeight;
  //   lDst.x := Position.X * FGameMechanics.TileWidth;
  //   lDst.y := Position.Y * FGameMechanics.TileHeight;
  //
  //   FGameView.CopySprite(FPlayerTexture, GetTileClip, lDst);
  // end;

  if FIsMoving then
    Exit;

  if ADirection = mdNone then
    Exit;

  SetFacingFromMove(ADirection);

  // Compute target tile (logical destination). We don't commit Position until movement completes.
  FTarget := FPosition;
  case ADirection of
    mdLeft:  Dec(FTarget.X);
    mdRight: Inc(FTarget.X);
    mdUp:    Dec(FTarget.Y);
    mdDown:  Inc(FTarget.Y);
  else
    ;
  end;

  StartMoveToTarget;
end;

procedure TPlayer.StartMoveToTarget;
begin
  // Set up movement interpolation in pixel-space (tile anchor).
  FMoveStartPixelX := FPixelX;
  FMoveStartPixelY := FPixelY;

  FIsMoving := True;
  FMoveElapsed := 0;

  // Walking animation starts immediately.
  FAnimState := pasWalk;
  FAnimAccumMS := 0;
  FWalkPhase := 0;
end;

procedure TPlayer.SetFacingFromMove(ADirection: TMoveDirection);
begin
  case ADirection of
    mdLeft:  FFacing := pfLeft;
    mdRight: FFacing := pfRight;
    mdUp:    FFacing := pfUp;
    mdDown:  FFacing := pfDown;
  else
    ;
  end;
end;

function TPlayer.GetTileClip: TGameRect;
const
  // RPG-Maker 3-frame walk, with a 4-phase loop for nicer stepping.
  cWalkFrame: array[0..3] of Integer = (0, 1, 2, 1);
var
  lCol: Integer;
  lRow: Integer;
begin
  if FAnimState = pasIdle then
    lCol := 1
  else
    lCol := cWalkFrame[FWalkPhase and 3];

  lRow := FacingToRow;

  Result.x := lCol * FPixelWidth;
  Result.y := lRow * FPixelHeight;
  Result.w := FPixelWidth;
  Result.h := FPixelHeight;
end;

procedure TPlayer.Update(ADeltaMS: UInt32);
var
  lT: Double;
  lDestX: Double;
  lDestY: Double;
  lFrameMS: UInt32;
begin
  // 1) Movement interpolation
  if FIsMoving then
  begin
    FMoveElapsed := FMoveElapsed + ADeltaMS;
    if FMoveDuration <= 0 then
      FMoveDuration := 1;

    lT := FMoveElapsed / FMoveDuration;
    if lT > 1 then
      lT := 1;

    lDestX := FTarget.X * FGameMechanics.TileWidth;
    lDestY := FTarget.Y * FGameMechanics.TileHeight;

    FPixelX := FMoveStartPixelX + (lDestX - FMoveStartPixelX) * lT;
    FPixelY := FMoveStartPixelY + (lDestY - FMoveStartPixelY) * lT;

    if lT >= 1 then
    begin
      // Commit logical position at the end of the move.
      FPosition := FTarget;
      FPixelX := lDestX;
      FPixelY := lDestY;
      FIsMoving := False;
      FAnimState := pasIdle;
      FWalkPhase := 0;
      FAnimAccumMS := 0;
    end;
  end;

  // 2) Animation stepping
  if FAnimState = pasWalk then
  begin
    // Default walk speed: 8 fps => 125ms per phase step.
    lFrameMS := 125;
    FAnimAccumMS := FAnimAccumMS + ADeltaMS;
    while FAnimAccumMS >= lFrameMS do
    begin
      Dec(FAnimAccumMS, lFrameMS);
      Inc(FWalkPhase);
      if FWalkPhase > 3 then
        FWalkPhase := 0;
    end;
  end;
end;

procedure TPlayer.Update;
begin
  Update(0);
end;

procedure TPlayer.SetPosition(AValue: TLocation);
begin
  FPosition.X := AValue.X;
  FPosition.Y := AValue.Y;

  // Keep the render anchor consistent with the logical position.
  FPixelX := FPosition.X * FGameMechanics.TileWidth;
  FPixelY := FPosition.Y * FGameMechanics.TileHeight;
end;

function TPlayer.GetPixelPosition: TLocationDouble;
begin
  Result.x := FPixelX;
  Result.y := FPixelY;
end;

function TPlayer.FacingToRow: Integer;
begin
  Result := Ord(FFacing);
end;

function TPlayer.GetDrawX: Integer;
var
  lOffsetX: Integer;
begin
  // Center the sprite horizontally on the tile.
  lOffsetX := (FGameMechanics.TileWidth - FPixelWidth) div 2;
  Result := Round(FPixelX) + lOffsetX;
end;

function TPlayer.GetDrawY: Integer;
var
  lOffsetY: Integer;
begin
  // Bottom-align the sprite to the tile.
  lOffsetY := FGameMechanics.TileHeight - FPixelHeight;
  Result := Round(FPixelY) + lOffsetY;
end;

procedure TPlayer.Draw;
var
  lDst: TGameRect;
begin
  lDst.w := FPixelWidth;
  lDst.h := FPixelHeight;
  lDst.x := GetDrawX;
  lDst.y := GetDrawY;

  FGameView.CopySprite(FPlayerTexture, GetTileClip, lDst);
end;

constructor TPlayer.Create;
begin
  raise Exception.Create('You need to instantiate TPlayer with GameMechanics');
end;

constructor TPlayer.Create(AGameMechanics: TGameMechanics; AGameView: TGameView);
begin
  FGameMechanics := AGameMechanics;
  FPosition := Location(0, 0);
  FTarget := FPosition;
  FPixelHeight := 36;
  FPixelWidth := 26;
  FGameView := AGameView;
  FPlayerTexture := FGameView.LoadTexture('sheet_winnersa_1.png');

  FFacing := pfDown;
  FAnimState := pasIdle;
  FWalkPhase := 0;
  FAnimAccumMS := 0;

  // Default move time per tile (ms). Tweak to taste.
  FMoveDuration := 150;

  // Ensure pixel anchor is initialized.
  FPixelX := FPosition.X * FGameMechanics.TileWidth;
  FPixelY := FPosition.Y * FGameMechanics.TileHeight;
end;

destructor TPlayer.Destroy;
begin
  inherited Destroy;
end;

end.

