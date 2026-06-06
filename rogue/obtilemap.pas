unit obTileMap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, tpTileMap, csTileMap, fpjson, fpjsonrtti;

type

  { TTerrainType }

  TTerrainType = class(TPersistent)
  private
    FCode: char;
    FName: string;
  protected
  public
  published
    property Name: string read FName write FName;
    property Code: char read FCode write FCode;
  end;

  { TMap }
  TMap = class(TPersistent)
  private
    FTiles: TMapTileGrid;
  private
    function GetHeight: integer;
    function GetWidth: integer;
    procedure SetHeight(AValue: integer);
    procedure SetWidth(AValue: integer);
  protected
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
    property Height: integer read GetHeight write SetHeight;
    property Width: integer read GetWidth write SetWidth;
    // no storage/IDE behavior.
  end;

implementation

constructor TMap.Create;
begin
  inherited Create;
end;

constructor TMap.Create(AWidth, AHeight: integer);
begin
  Create;
  ResizeMap(AWidth, AHeight);
end;

constructor TMap.Create(const AFilename: string);
begin
  Create;
  LoadFromFile(AFilename);
end;

constructor TMap.Create(const AStream: TStream);
begin
  Create;
  LoadFromStream(AStream);
end;

procedure TMap.ResizeMap(AWidth, AHeight: integer);
begin
  FTiles.Resize(AWidth, AHeight);
end;

function TMap.GetHeight: integer;
begin
  Result := FTiles.Height;
end;

function TMap.GetWidth: integer;
begin
  Result := FTiles.Width;
end;

procedure TMap.SetHeight(AValue: integer);
begin
  FTiles.Resize(FTiles.Width, AValue);
end;

procedure TMap.SetWidth(AValue: integer);
begin
  FTiles.Resize(AValue, FTiles.Height);
end;

function TMap.GetTile(AX, AY: integer): TMapTile;
begin
  Result := FTiles[AX, AY];
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
  Streamer: TJSONStreamer;
  JSONData: TJSONData;
  JSONStr: string;
begin
  Streamer := TJSONStreamer.Create(nil);
  try
    Streamer.Options := Streamer.Options + [jsoEnumeratedAsInteger];

    JSONData := Streamer.ObjectToJSON(Self);
    try
      if JSONData.JSONType = jtObject then
      begin
        JSONStr := JSONData.FormatJSON([foUseTabChar, foSingleLineArray, foSkipWhiteSpace]);  // Pretty-print
        AStream.WriteAnsiString(JSONStr);
      end
    finally
      JSONData.Free;
    end;
  finally
    Streamer.Free;
  end;
end;

procedure TMap.LoadFromStream(AStream: TStream);
var
  DeStreamer: TJSONDeStreamer;
  lStr: string;
begin
  lStr := AStream.ReadAnsiString;
  DeStreamer := TJSONDeStreamer.Create(nil);
  try
    DeStreamer.JSONToObject(lStr, self);
  finally
    DeStreamer.Free;
  end;
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

