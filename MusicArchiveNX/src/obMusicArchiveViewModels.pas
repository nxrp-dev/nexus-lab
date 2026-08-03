unit obMusicArchiveViewModels;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  tpMusicArchiveTypes;

type
  TMusicArchiveViewModel = class
  private
    FArchiveName: string;
    FImportStatus: string;
    FPlaybackPositionMs: Int64;
    FPlaybackState: TMusicPlaybackState;
    FRecordings: TMusicRecordingSummaryArray;
    FSearchText: string;
    FSelectedRecordingId: TMusicRecordingId;
    function GetRecording(AIndex: Integer): TMusicRecordingSummary;
    function GetRecordingCount: Integer;
    function GetPlaybackStateText: string;
  public
    constructor Create;

    procedure AddRecording(const ARecording: TMusicRecordingSummary);
    procedure ClearRecordings;

    property ArchiveName: string read FArchiveName write FArchiveName;
    property ImportStatus: string read FImportStatus write FImportStatus;
    property PlaybackPositionMs: Int64 read FPlaybackPositionMs write FPlaybackPositionMs;
    property PlaybackState: TMusicPlaybackState read FPlaybackState write FPlaybackState;
    property PlaybackStateText: string read GetPlaybackStateText;
    property RecordingCount: Integer read GetRecordingCount;
    property Recordings[AIndex: Integer]: TMusicRecordingSummary read GetRecording;
    property SearchText: string read FSearchText write FSearchText;
    property SelectedRecordingId: TMusicRecordingId read FSelectedRecordingId
      write FSelectedRecordingId;
  end;

implementation

constructor TMusicArchiveViewModel.Create;
begin
  inherited Create;
  FArchiveName := 'MusicArchiveNX';
  FImportStatus := 'Ready';
  FPlaybackState := mpsStopped;
end;

procedure TMusicArchiveViewModel.AddRecording(
  const ARecording: TMusicRecordingSummary);
var
  lIndex: Integer;
begin
  lIndex := Length(FRecordings);
  SetLength(FRecordings, lIndex + 1);
  FRecordings[lIndex] := ARecording;
end;

procedure TMusicArchiveViewModel.ClearRecordings;
begin
  SetLength(FRecordings, 0);
end;

function TMusicArchiveViewModel.GetPlaybackStateText: string;
begin
  Result := MusicPlaybackStateText(FPlaybackState);
end;

function TMusicArchiveViewModel.GetRecording(
  AIndex: Integer): TMusicRecordingSummary;
begin
  if (AIndex < 0) or (AIndex >= Length(FRecordings)) then
    raise ERangeError.Create('Recording index out of range.');

  Result := FRecordings[AIndex];
end;

function TMusicArchiveViewModel.GetRecordingCount: Integer;
begin
  Result := Length(FRecordings);
end;

end.
