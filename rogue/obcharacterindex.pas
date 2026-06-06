unit obCharacterIndex;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  { Forward declarations }
  TCharacterIndex = class;
  TCharacterDef = class;
  TAnimationDef = class;
  TFrameDef = class;

  { Simple enums stored as strings for JSON friendliness }
  // You can switch these to enums later; strings keep JSON stable and readable.
  // Examples: 'idle', 'walk', 'attack' and 'n','e','s','w' or 'ne','sw', etc.

  { TSheetInfo }
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

  { TFrameDef }
  TFrameDef = class(TCollectionItem)
  private
    FTileX: Integer;
    FTileY: Integer;

    // Optional: for odd-sized sprites or alignment
    FOffsetX: Integer;
    FOffsetY: Integer;

    // Optional: if you want per-frame override (usually you won't)
    FDurationMS: Integer;

    // Optional: tags like 'footstep', 'hit', etc.
    FTag: string;
  published
    property TileX: Integer read FTileX write FTileX;
    property TileY: Integer read FTileY write FTileY;
    property OffsetX: Integer read FOffsetX write FOffsetX;
    property OffsetY: Integer read FOffsetY write FOffsetY;
    property DurationMS: Integer read FDurationMS write FDurationMS;
    property Tag: string read FTag write FTag;
  end;

  { TFrameCollection }
  TFrameCollection = class(TCollection)
  private
    function GetItem(AIndex: Integer): TFrameDef;
    procedure SetItem(AIndex: Integer; AValue: TFrameDef);
  public
    constructor Create;
    function Add: TFrameDef;
    property Items[AIndex: Integer]: TFrameDef read GetItem write SetItem; default;
  end;

  { TAnimationDef }
  TAnimationDef = class(TCollectionItem)
  private
    FState: string;        // 'idle','walk',...
    FDirection: string;    // 'n','e','s','w' (or empty if non-directional)
    FLoopMode: string;     // 'loop','once','pingpong'
    FFPS: Integer;         // default playback rate for frames
    FFrames: TFrameCollection;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property State: string read FState write FState;
    property Direction: string read FDirection write FDirection;
    property LoopMode: string read FLoopMode write FLoopMode;
    property FPS: Integer read FFPS write FFPS;
    property Frames: TFrameCollection read FFrames write FFrames;
  end;

  { TAnimationCollection }
  TAnimationCollection = class(TCollection)
  private
    function GetItem(AIndex: Integer): TAnimationDef;
    procedure SetItem(AIndex: Integer; AValue: TAnimationDef);
  public
    constructor Create;
    function Add: TAnimationDef;

    // Convenience (non-persistent) lookup helpers
    function FindByStateDir(const AState, ADirection: string): TAnimationDef;

    property Items[AIndex: Integer]: TAnimationDef read GetItem write SetItem; default;
  end;

  { TCharacterDef }
  TCharacterDef = class(TCollectionItem)
  private
    FId: string;                 // 'player','goblin',...
    FDefaultState: string;        // 'idle'
    FDefaultDirection: string;    // 's' etc.
    FAnimations: TAnimationCollection;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Id: string read FId write FId;
    property DefaultState: string read FDefaultState write FDefaultState;
    property DefaultDirection: string read FDefaultDirection write FDefaultDirection;
    property Animations: TAnimationCollection read FAnimations write FAnimations;
  end;

  { TCharacterCollection }
  TCharacterCollection = class(TCollection)
  private
    function GetItem(AIndex: Integer): TCharacterDef;
    procedure SetItem(AIndex: Integer; AValue: TCharacterDef);
  public
    constructor Create;
    function Add: TCharacterDef;

    // Convenience (non-persistent) lookup helpers
    function FindById(const AId: string): TCharacterDef;

    property Items[AIndex: Integer]: TCharacterDef read GetItem write SetItem; default;
  end;

  { TCharacterIndex }
  TCharacterIndex = class(TPersistent)
  private
    FFormat: string;
    FVersion: Integer;
    FSheet: TSheetInfo;
    FCharacters: TCharacterCollection;
  public
    constructor Create;
    destructor Destroy; override;

    // Convenience (non-persistent) helpers
    function FindCharacter(const AId: string): TCharacterDef;
  published
    property Format: string read FFormat write FFormat;
    property Version: Integer read FVersion write FVersion;
    property Sheet: TSheetInfo read FSheet write FSheet;
    property Characters: TCharacterCollection read FCharacters write FCharacters;
  end;

implementation

{ TFrameCollection }

constructor TFrameCollection.Create;
begin
  inherited Create(TFrameDef);
end;

function TFrameCollection.Add: TFrameDef;
begin
  Result := TFrameDef(inherited Add);
end;

function TFrameCollection.GetItem(AIndex: Integer): TFrameDef;
begin
  Result := TFrameDef(inherited Items[AIndex]);
end;

procedure TFrameCollection.SetItem(AIndex: Integer; AValue: TFrameDef);
begin
  inherited Items[AIndex] := AValue;
end;

{ TAnimationCollection }

constructor TAnimationCollection.Create;
begin
  inherited Create(TAnimationDef);
end;

function TAnimationCollection.Add: TAnimationDef;
begin
  Result := TAnimationDef(inherited Add);
end;

function TAnimationCollection.GetItem(AIndex: Integer): TAnimationDef;
begin
  Result := TAnimationDef(inherited Items[AIndex]);
end;

procedure TAnimationCollection.SetItem(AIndex: Integer; AValue: TAnimationDef);
begin
  inherited Items[AIndex] := AValue;
end;

function TAnimationCollection.FindByStateDir(const AState, ADirection: string): TAnimationDef;
var
  lI: Integer;
  lAnim: TAnimationDef;
begin
  Result := nil;
  for lI := 0 to Count - 1 do
  begin
    lAnim := Items[lI];
    if SameText(lAnim.State, AState) and SameText(lAnim.Direction, ADirection) then
      Exit(lAnim);
  end;
end;

{ TAnimationDef }

constructor TAnimationDef.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FLoopMode := 'loop';
  FFPS := 8;
  FFrames := TFrameCollection.Create;
end;

destructor TAnimationDef.Destroy;
begin
  FreeAndNil(FFrames);
  inherited Destroy;
end;

{ TCharacterCollection }

constructor TCharacterCollection.Create;
begin
  inherited Create(TCharacterDef);
end;

function TCharacterCollection.Add: TCharacterDef;
begin
  Result := TCharacterDef(inherited Add);
end;

function TCharacterCollection.GetItem(AIndex: Integer): TCharacterDef;
begin
  Result := TCharacterDef(inherited Items[AIndex]);
end;

procedure TCharacterCollection.SetItem(AIndex: Integer; AValue: TCharacterDef);
begin
  inherited Items[AIndex] := AValue;
end;

function TCharacterCollection.FindById(const AId: string): TCharacterDef;
var
  lI: Integer;
  lChar: TCharacterDef;
begin
  Result := nil;
  for lI := 0 to Count - 1 do
  begin
    lChar := Items[lI];
    if SameText(lChar.Id, AId) then
      Exit(lChar);
  end;
end;

{ TCharacterDef }

constructor TCharacterDef.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FDefaultState := 'idle';
  FDefaultDirection := 's';
  FAnimations := TAnimationCollection.Create;
end;

destructor TCharacterDef.Destroy;
begin
  FreeAndNil(FAnimations);
  inherited Destroy;
end;

{ TCharacterIndex }

constructor TCharacterIndex.Create;
begin
  inherited Create;
  FFormat := 'character-index';
  FVersion := 1;
  FSheet := TSheetInfo.Create;
  FCharacters := TCharacterCollection.Create;
end;

destructor TCharacterIndex.Destroy;
begin
  FreeAndNil(FCharacters);
  FreeAndNil(FSheet);
  inherited Destroy;
end;

function TCharacterIndex.FindCharacter(const AId: string): TCharacterDef;
begin
  Result := FCharacters.FindById(AId);
end;

end.

