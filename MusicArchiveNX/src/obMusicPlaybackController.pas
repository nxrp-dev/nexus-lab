unit obMusicPlaybackController;

{$mode objfpc}{$H+}

interface

uses
  tpMusicArchiveTypes;

type
  TMusicPlaybackController = class
  private
    FPositionMs: Int64;
    FState: TMusicPlaybackState;
  public
    constructor Create;

    procedure Pause;
    procedure Play;
    procedure Seek(APositionMs: Int64);
    procedure Stop;

    property PositionMs: Int64 read FPositionMs;
    property State: TMusicPlaybackState read FState;
  end;

implementation

constructor TMusicPlaybackController.Create;
begin
  inherited Create;
  FState := mpsStopped;
end;

procedure TMusicPlaybackController.Pause;
begin
  if FState = mpsPlaying then
    FState := mpsPaused;
end;

procedure TMusicPlaybackController.Play;
begin
  FState := mpsPlaying;
end;

procedure TMusicPlaybackController.Seek(APositionMs: Int64);
begin
  if APositionMs < 0 then
    FPositionMs := 0
  else
    FPositionMs := APositionMs;
end;

procedure TMusicPlaybackController.Stop;
begin
  FState := mpsStopped;
  FPositionMs := 0;
end;

end.
