unit tpGridArray;

{$mode ObjFPC}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, Graphics;

type
  generic TGridArray<T> = record
  private
    FData: array of T;          // flat 1D storage for best performance
    FWidth: Integer;
    FHeight: Integer;

    function GetItem(X, Y: Integer): T; inline;
    procedure SetItem(X, Y: Integer; const Value: T); inline;
  public
    procedure Init(AWidth, AHeight: Integer);
    procedure Resize(NewWidth, NewHeight: Integer);
    function IsValid(X, Y: Integer): Boolean; inline;

    property Items[X, Y: Integer]: T read GetItem write SetItem; default;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
  end;

type
  TIntegerGrid = specialize TGridArray<Integer>;
  TByteGrid   = specialize TGridArray<Byte>;
  TSingleGrid = specialize TGridArray<Single>;
  TPointGrid  = specialize TGridArray<TPoint>;
  TColorGrid  = specialize TGridArray<TColor>;

implementation

uses Math;

procedure TGridArray.Init(AWidth, AHeight: Integer);
begin
  FWidth := AWidth;
  FHeight := AHeight;
  SetLength(FData, FWidth * FHeight);
end;

procedure TGridArray.Resize(NewWidth, NewHeight: Integer);
var
  lNewData: array of T;
  x, y: Integer;
begin
  if ((NewWidth = FWidth) and (NewHeight = FHeight)) or ((NewWidth = 0) or (NewHeight = 0)) then
    Exit;

  SetLength(lNewData, NewWidth * NewHeight);

  // Copy old data (with clipping if shrinking)
  for y := 0 to Pred(Min(FHeight, NewHeight)) do
    for x := 0 to Pred(Min(FWidth, NewWidth)) do
      lNewData[y * NewWidth + x] := FData[y * FWidth + x];

  FData := lNewData;
  FWidth := NewWidth;
  FHeight := NewHeight;
end;

function TGridArray.GetItem(X, Y: Integer): T; inline;
begin
  Result := FData[Y * FWidth + X];
end;

procedure TGridArray.SetItem(X, Y: Integer; const Value: T); inline;
begin
  FData[Y * FWidth + X] := Value;
end;

function TGridArray.IsValid(X, Y: Integer): Boolean; inline;
begin
  Result := (X >= 0) and (X < FWidth) and (Y >= 0) and (Y < FHeight);
end;

end.

