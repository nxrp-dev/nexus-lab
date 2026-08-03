unit obMusicTimelineControl;

{$mode objfpc}{$H+}

interface

uses
  Math,
  obNXControl,
  tpNXPlatform;

type
  TMusicTimelineControl = class(TNXControl)
  private
    FDurationMs: Int64;
    FPositionMs: Int64;
    function GetPositionRatio: Double;
    procedure SetDurationMs(AValue: Int64);
    procedure SetPositionMs(AValue: Int64);
  protected
    procedure RenderClient; override;
  public
    constructor Create(const AParent: INXControlParent); override;

    property DurationMs: Int64 read FDurationMs write SetDurationMs;
    property PositionMs: Int64 read FPositionMs write SetPositionMs;
  end;

implementation

constructor TMusicTimelineControl.Create(const AParent: INXControlParent);
begin
  inherited Create(AParent);
  Height := 36;
  FillStyle := FS_None;
  BorderStyle := BS_None;
end;

function TMusicTimelineControl.GetPositionRatio: Double;
begin
  if FDurationMs <= 0 then
    Result := 0
  else
    Result := Math.Max(0, Math.Min(1, FPositionMs / FDurationMs));
end;

procedure TMusicTimelineControl.RenderClient;
var
  lBarRect: TNXRect;
  lPlayheadX: Integer;
begin
  lBarRect := MakeNXRect(8, (Height div 2) - 3, Width - 16, 6);
  Canvas.FillRect(lBarRect, MakeNXColor(56, 61, 68, 255));
  Canvas.DrawRect(lBarRect, MakeNXColor(112, 122, 136, 255));

  lPlayheadX := lBarRect.x + Round(lBarRect.w * GetPositionRatio);
  Canvas.DrawLine(lPlayheadX, lBarRect.y - 8, lPlayheadX,
    lBarRect.y + lBarRect.h + 8, MakeNXColor(120, 205, 255, 255));
end;

procedure TMusicTimelineControl.SetDurationMs(AValue: Int64);
begin
  if AValue < 0 then
    FDurationMs := 0
  else
    FDurationMs := AValue;
end;

procedure TMusicTimelineControl.SetPositionMs(AValue: Int64);
begin
  if AValue < 0 then
    FPositionMs := 0
  else
    FPositionMs := AValue;
end;

end.
