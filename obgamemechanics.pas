unit obGameMechanics;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TGameMechanics = class
  private
    FResolutionHeight: integer;
    FResolutionWidth: integer;
    FTileHeight: integer;
    FTileWidth: integer;
    procedure SetResolutionHeight(AValue: integer);
    procedure SetResolutionWidth(AValue: integer);
    procedure SetTileHeight(AValue: integer);
    procedure SetTileWidth(AValue: integer);
  protected
  public
    property TileWidth: integer read FTileWidth write SetTileWidth;
    property TileHeight: integer read FTileHeight write SetTileHeight;
    property ResolutionWidth: integer read FResolutionWidth write SetResolutionWidth ;
    property ResolutionHeight: integer read FResolutionHeight write SetResolutionHeight;
    constructor Create; virtual;
  published
  end;

implementation

procedure TGameMechanics.SetTileHeight(AValue: integer);
begin
  if FTileHeight=AValue then Exit;
  FTileHeight:=AValue;
end;

procedure TGameMechanics.SetResolutionWidth(AValue: integer);
begin
  if FResolutionWidth=AValue then Exit;
  FResolutionWidth:=AValue;
end;

procedure TGameMechanics.SetResolutionHeight(AValue: integer);
begin
  if FResolutionHeight=AValue then Exit;
  FResolutionHeight:=AValue;
end;

procedure TGameMechanics.SetTileWidth(AValue: integer);
begin
  if FTileWidth=AValue then Exit;
  FTileWidth:=AValue;
end;

constructor TGameMechanics.Create;
begin
  FTileWidth := 16;
  FTileHeight := 16;
  ResolutionHeight := 480;
  ResolutionWidth := 640;
end;

end.

