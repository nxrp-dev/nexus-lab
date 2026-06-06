unit obTerrain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TTileVariant = class(TCollectionItem)
  private
    FX: Integer;        // block-local tile offset X
    FY: Integer;        // block-local tile offset Y
    FWeight: Integer;   // optional (default 0 or 1 depending on your selector)
    FTag: string;       // optional
  published
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Weight: Integer read FWeight write FWeight;
    property Tag: string read FTag write FTag;
  end;

//  TTerrainDescriptor: string[25];

//  TTerrainSetRecord // A collection of related tiles for a map
 //   Name // Outside, Inside, Dungeon, Cave, Hell, Heaven, etc
 //   FileName //
  //  TileWidth //
  //  TileHeight //
//  end;

//  TTerrainType = record
  //  Name: TTerrainDescriptor;
    //
//  end;

  //TTerrainTypeTile = record
//    TerrainType: TTerrainDescriptor;
  //  TileX: integer;
    //TileY: integer;
//    NW: TTerrainDescriptor;
  //  N: TTerrainDescriptor;
    //NE: TTerrainDescriptor;
//    W: TTerrainDescriptor;
  //  C: TTerrainDescriptor;
    //E: TTerrainDescriptor;
//    SW: TTerrainDescriptor;
  //  S: TTerrainDescriptor;
    //SE: TTerrainDescriptor;
//  end

  TTerrainSet = record
    Name: string[20];

  end;

  TTerrainType = class(TObject)
  private
  protected
  public
    // sheet
    // image reference
    // walkable + more
  published
  end;

  { TGameMap }

  TGameMap = class(TObject)
  private
    FHeight: integer;
    FWidth: integer;

    function GetHeight: integer;
    function GetWidth: integer;
    procedure SetHeight(AValue: integer);
    procedure SetWidth(AValue: integer);
  protected
  public
    property Height: integer read GetHeight write SetHeight;
    property Width: integer read GetWidth write SetWidth;
  published
  end;

implementation

{ TGameMap }


function TGameMap.GetHeight: integer;
begin
  Result := FHeight;
end;

function TGameMap.GetWidth: integer;
begin
  Result := FWidth;
end;

procedure TGameMap.SetHeight(AValue: integer);
begin
  FHeight := AValue;
end;

procedure TGameMap.SetWidth(AValue: integer);
begin
  FWidth := AValue;
end;

end.

