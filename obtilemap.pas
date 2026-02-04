unit obTileMap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, tpTileMap, csTileMap;

type
  TMapHeader = record
    Width: integer;
    Height: integer;
  end;
  { TMap }

  TMap = class
  private
    FTiles: TMapField;
    FWidth: integer;
    FHeight: integer;
  private
    function GetIndex(AX, AY: integer): integer;
  protected
    // no object oriented behavior.
  public
    function HasTrait(ATile: TMapTile; ATrait: TTileTrait): boolean;

    function GetTileType(ATile: TMapTile): Byte;
    procedure SetTileType(var ATile: TMapTile; ATileType: Byte);

    function GetSpriteIndex(ATile: TMapTile): Byte;
    procedure SetSpriteIndex(var ATile: TMapTile; ASpriteIndex: Byte);

    function HasStateFlag(ATile: TMapTile; AState: TTileState): boolean;
    procedure SetStateFlag(var ATile: TMapTile; AState: TTileState; AValue: boolean);

    function HasTraitFlag(ATile: TMapTile; ATrait: TTileTrait): boolean;
    procedure SetTraitFlag(var ATile: TMapTile; ATrait: TTileTrait; AValue: boolean);

    function GetTile(AX, AY: integer): TMapTile;
    function HasStateMask(ATile: TMapTile; AStateMask: TTileStateMask): boolean;
    function HasState(ATile: TMapTile; AState: TTileState): boolean;
    procedure ResizeMap(AWidth, AHeight: integer);

    procedure SaveToStream(AStream: TStream);
    procedure LoadFromStream(AStream: TStream);

    procedure LoadFromFile(const AFilename: string);
    procedure SaveToFile(const AFilename: string);

    constructor Create; overload;
    constructor Create(AWidth, AHeight: integer); overload;
    constructor Create(const AFilename: string); overload;
    constructor Create(const AStream: TStream); overload;
  published
    // no storage/IDE behavior.
  end;

implementation

constructor TMap.Create;
begin
  inherited Create;
  FWidth := 0;
  FHeight := 0;
  SetLength(FTiles, 0);
end;

constructor TMap.Create(AWidth, AHeight: integer);
begin
  Create;
  ResizeMap(AWidth, AHeight);
end;

constructor TMap.Create(const AFilename: string);
begin
  Create;              // calls inherited Create, zeroes fields (your default ctor)
  LoadFromFile(AFilename);
end;

constructor TMap.Create(const AStream: TStream);
begin
  Create;
  LoadFromStream(AStream);
end;

procedure TMap.ResizeMap(AWidth, AHeight: integer);
var
  lCount: Integer;
begin
  FWidth := AWidth;
  FHeight := AHeight;

  if (FWidth <= 0) or (FHeight <= 0) then
  begin
    FWidth := 0;
    FHeight := 0;
    SetLength(FTiles, 0);
    Exit;
  end;

  lCount := FWidth * FHeight;
  SetLength(FTiles, lCount);

  // Baseline init: all tiles = 0 (no flags set)
  // If you want "OOB behaves like wall", you'll likely treat 0 as wall/non-walkable.
  FillChar(FTiles[0], SizeOf(TMapTile) * lCount, 0);
end;

function TMap.GetIndex(AX, AY: integer): integer;
begin
  // Unchecked by contract
  Result := (AY * FWidth) + AX;
end;

function TMap.GetTile(AX, AY: integer): TMapTile;
begin
  // Unchecked by contract (your stated philosophy)
  Result := FTiles[GetIndex(AX, AY)];
end;

function TMap.HasStateMask(ATile: TMapTile; AStateMask: TTileStateMask): boolean;
begin
  Result := (ATile and AStateMask) <> 0;
end;

function TMap.HasState(ATile: TMapTile; AState: TTileState): boolean;
var
  lMask: TMapTile;
begin
  lMask := TMapTile(1) shl (cStateShift + Ord(AState));
  Result := (ATile and lMask) <> 0;
end;

function TMap.HasTrait(ATile: TMapTile; ATrait: TTileTrait): boolean;
var
  lMask: TMapTile;
begin
  lMask := TMapTile(1) shl (cTraitShift + Ord(ATrait));
  Result := (ATile and lMask) <> 0;
end;

function TMap.GetTileType(ATile: TMapTile): Byte;
begin
  Result := Byte((ATile and cTileTypeFieldMask) shr cTileTypeShift);
end;

procedure TMap.SetTileType(var ATile: TMapTile; ATileType: Byte);
var
  lValue: TMapTile;
begin
  lValue := TMapTile(ATileType) shl cTileTypeShift;
  ATile := (ATile and (not cTileTypeFieldMask)) or lValue;
end;

function TMap.GetSpriteIndex(ATile: TMapTile): Byte;
begin
  Result := Byte((ATile and cSpriteFieldMask) shr cSpriteShift);
end;

procedure TMap.SetSpriteIndex(var ATile: TMapTile; ASpriteIndex: Byte);
var
  lValue: TMapTile;
begin
  lValue := TMapTile(ASpriteIndex) shl cSpriteShift;
  ATile := (ATile and (not cSpriteFieldMask)) or lValue;
end;

function TMap.HasStateFlag(ATile: TMapTile; AState: TTileState): boolean;
begin
  Result := HasState(ATile, AState);
end;

procedure TMap.SetStateFlag(var ATile: TMapTile; AState: TTileState; AValue: boolean);
var
  lMask: TMapTile;
begin
  lMask := TMapTile(1) shl (cStateShift + Ord(AState));
  if AValue then
    ATile := ATile or lMask
  else
    ATile := ATile and (not lMask);
end;

function TMap.HasTraitFlag(ATile: TMapTile; ATrait: TTileTrait): boolean;
begin
  Result := HasTrait(ATile, ATrait);
end;

procedure TMap.SetTraitFlag(var ATile: TMapTile; ATrait: TTileTrait; AValue: boolean);
var
  lMask: TMapTile;
begin
  lMask := TMapTile(1) shl (cTraitShift + Ord(ATrait));
  if AValue then
    ATile := ATile or lMask
  else
    ATile := ATile and (not lMask);
end;

procedure TMap.SaveToStream(AStream: TStream);
var
  lHeader: TMapHeader;
  lCount: Int64;
begin
  // Header comes from current object state
  lHeader.Width := FWidth;
  lHeader.Height := FHeight;

  // Write header
  AStream.WriteBuffer(lHeader, SizeOf(lHeader));

  // Write tiles
  lCount := Int64(FWidth) * Int64(FHeight);
  if lCount > 0 then
    AStream.WriteBuffer(FTiles[0], lCount * SizeOf(TMapTile));
end;

procedure TMap.LoadFromStream(AStream: TStream);
var
  lHeader: TMapHeader;
  lCount: Int64;
  lBytesNeeded: Int64;
begin
  // Read header
  AStream.ReadBuffer(lHeader, SizeOf(lHeader));

  // Resize to header dimensions
  ResizeMap(lHeader.Width, lHeader.Height);

  // Read tiles
  lCount := Int64(FWidth) * Int64(FHeight);
  lBytesNeeded := lCount * SizeOf(TMapTile);

  if lBytesNeeded > 0 then
    AStream.ReadBuffer(FTiles[0], lBytesNeeded);
end;

procedure TMap.SaveToFile(const AFilename: string);
var
  lFS: TFileStream;
begin
  lFS := TFileStream.Create(AFilename, fmCreate or fmShareDenyWrite);
  try
    SaveToStream(lFS);
  finally
    lFS.Free;
  end;
end;

procedure TMap.LoadFromFile(const AFilename: string);
var
  lFS: TFileStream;
begin
  lFS := TFileStream.Create(AFilename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(lFS);
  finally
    lFS.Free;
  end;
end;

end.

