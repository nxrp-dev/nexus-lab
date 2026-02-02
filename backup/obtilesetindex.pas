unit obTilesetIndex;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  { --- Leaf items --- }

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

  TMaskEntry = class(TCollectionItem)
  private
    FMask: Integer;       // 0..15
    FVariants: TCollection; // of TTileVariant
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Mask: Integer read FMask write FMask;
    property Variants: TCollection read FVariants write FVariants;
  end;

  { --- Small nested objects --- }

  TSheetInfo = class(TPersistent)
  private
    FFilename: string;
    FTileWidth: Integer;
    FTileHeight: Integer;
  published
    property Filename: string read FFilename write FFilename;
    property TileWidth: Integer read FTileWidth write FTileWidth;
    property TileHeight: Integer read FTileHeight write FTileHeight;
  end;

  TAutoTileInfo = class(TPersistent)
  private
    FMode: string;              // "corner"
    FMaskBits: string;          // "NW=1,NE=2,SE=4,SW=8"
    FMissingMaskPolicy: string; // "fixDiagonals"
  published
    property Mode: string read FMode write FMode;
    property MaskBits: string read FMaskBits write FMaskBits;
    property MissingMaskPolicy: string read FMissingMaskPolicy write FMissingMaskPolicy;
  end;

  TBlockInfo = class(TPersistent)
  private
    FBaseTileX: Integer;
    FBaseTileY: Integer;
    FWidth: Integer;
    FHeight: Integer;
  published
    property BaseTileX: Integer read FBaseTileX write FBaseTileX;
    property BaseTileY: Integer read FBaseTileY write FBaseTileY;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
  end;

  TOutsideInfo = class(TPersistent)
  private
    FIsTransparent: Boolean;
  published
    property IsTransparent: Boolean read FIsTransparent write FIsTransparent;
  end;

  { --- Terrain set --- }

  TTerrainSet = class(TCollectionItem)
  private
    FId: string;
    FBlock: TBlockInfo;
    FOutside: TOutsideInfo;
    FMasks: TCollection; // of TMaskEntry
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Id: string read FId write FId;
    property Block: TBlockInfo read FBlock write FBlock;
    property Outside: TOutsideInfo read FOutside write FOutside;
    property Masks: TCollection read FMasks write FMasks;
  end;

  { --- Variant selection (optional) --- }

  TVariantSelectionInfo = class(TPersistent)
  private
    FType: string;     // "seeded"
    FSeedKey: string;  // keep it simple; store as a single string, e.g. "mapSeed,terrainId,cellX,cellY,mask"
  published
    property Type_: string read FType write FType;  // Type is a reserved word in some contexts; safer as Type_
    property SeedKey: string read FSeedKey write FSeedKey;
  end;

  { --- Root --- }

  TTilesetIndex = class(TPersistent)
  private
    FFormat: string;
    FVersion: Integer;
    FSheet: TSheetInfo;
    FAutotile: TAutoTileInfo;
    FTerrains: TCollection; // of TTerrainSet
    FVariantSelection: TVariantSelectionInfo;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Format: string read FFormat write FFormat;
    property Version: Integer read FVersion write FVersion;
    property Sheet: TSheetInfo read FSheet write FSheet;
    property Autotile: TAutoTileInfo read FAutotile write FAutotile;
    property Terrains: TCollection read FTerrains write FTerrains;
    property VariantSelection: TVariantSelectionInfo read FVariantSelection write FVariantSelection;
  end;

implementation

{ TMaskEntry }

constructor TMaskEntry.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FVariants := TCollection.Create(TTileVariant);
end;

destructor TMaskEntry.Destroy;
begin
  FreeAndNil(FVariants);
  inherited Destroy;
end;

{ TTerrainSet }

constructor TTerrainSet.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FBlock := TBlockInfo.Create;
  FOutside := TOutsideInfo.Create;
  FMasks := TCollection.Create(TMaskEntry);
end;

destructor TTerrainSet.Destroy;
begin
  FreeAndNil(FMasks);
  FreeAndNil(FOutside);
  FreeAndNil(FBlock);
  inherited Destroy;
end;

{ TTilesetIndex }

constructor TTilesetIndex.Create;
begin
  inherited Create;

  FSheet := TSheetInfo.Create;
  FAutotile := TAutoTileInfo.Create;
  FTerrains := TCollection.Create(TTerrainSet);
  FVariantSelection := TVariantSelectionInfo.Create;
end;

destructor TTilesetIndex.Destroy;
begin
  FreeAndNil(FVariantSelection);
  FreeAndNil(FTerrains);
  FreeAndNil(FAutotile);
  FreeAndNil(FSheet);
  inherited Destroy;
end;

end.

