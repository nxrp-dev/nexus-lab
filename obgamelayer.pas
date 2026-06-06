unit obGameLayer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, obContainers, obGameView;

type

  { TGameLayer }

  TGameLayer = class(TObject)
  private
    FTileHeight: integer;
    FTileWidth: integer;
  protected
  public
    procedure InitializeLayer; virtual; abstract;
    procedure ReleaseLayer; virtual; abstract;

    procedure Update; virtual; abstract;
    procedure Draw; virtual; abstract;

    property TileWidth: integer read FTileWidth;
    property TileHeight: integer read FTileHeight;
    constructor Create(ATileWidth, ATileHeight: integer);// init layer metrics
  published
  end;

  { TGameLayerList }
type
  TGameLayerList = class(specialize TGenericList<TGameLayer>)
  private
    FGameView: TGameView;
  protected
    property GameView: TGameView read FGameView;

    procedure UpdateLayer(const AItem: TGameLayer); virtual;
    procedure DrawLayer(const AItem: TGameLayer); virtual;
    procedure ReleaseLayer(const AItem: TGameLayer); virtual;
    procedure InitializeLayer(const AItem: TGameLayer); virtual;
  public
    procedure InitializeLayers; virtual;
    procedure ReleaseLayers; virtual;

    procedure UpdateLayers; virtual;
    procedure DrawLayers; virtual;

    constructor Create(AGameView: TGameView); virtual; overload;
  published
  end;

implementation

{ TGameLayer }

constructor TGameLayer.Create(ATileWidth, ATileHeight: integer);
begin
  FTileWidth := ATileWidth;
  FTileHeight := ATileHeight;
end;

{ TGameLayerList }

procedure TGameLayerList.UpdateLayer(const AItem: TGameLayer);
begin
  AItem.Update;
end;

procedure TGameLayerList.DrawLayer(const AItem: TGameLayer);
begin
  AItem.Draw;
end;

procedure TGameLayerList.ReleaseLayer(const AItem: TGameLayer);
begin
  AItem.ReleaseLayer;
end;

procedure TGameLayerList.InitializeLayer(const AItem: TGameLayer);
begin
  AItem.InitializeLayer;
end;

procedure TGameLayerList.InitializeLayers;
begin
  ForEach(@InitializeLayer);
end;

procedure TGameLayerList.ReleaseLayers;
begin
  ForEach(@ReleaseLayer);
end;

procedure TGameLayerList.UpdateLayers;
begin
  ForEach(@UpdateLayer);
end;

procedure TGameLayerList.DrawLayers;
begin
  ForEach(@DrawLayer);
end;

constructor TGameLayerList.Create(AGameView: TGameView);
begin
  FGameView := AGameView;
end;

end.

