unit tpMusicArchiveTypes;

{$mode objfpc}{$H+}

interface

type
  TMusicRecordingId = Int64;

  TMusicPlaybackState = (
    mpsStopped,
    mpsPlaying,
    mpsPaused,
    mpsError
  );

  TMusicImportOptions = record
    SourceFolder: string;
    Recursive: Boolean;
    SupportedExtensions: string;
  end;

  TMusicImportSummary = record
    ScannedCount: Integer;
    ImportedCount: Integer;
    DuplicateCount: Integer;
    SkippedCount: Integer;
    ErrorCount: Integer;
    Cancelled: Boolean;
    StatusText: string;
  end;

  TMusicRecordingSummary = record
    Id: TMusicRecordingId;
    StableId: string;
    Title: string;
    DurationText: string;
    FormatName: string;
    ImportedAtText: string;
    AvailabilityText: string;
  end;

  TMusicRecordingSummaryArray = array of TMusicRecordingSummary;

  TMusicAnnotationRange = record
    StartMs: Int64;
    EndMs: Int64;
  end;

function MusicPlaybackStateText(AState: TMusicPlaybackState): string;

implementation

function MusicPlaybackStateText(AState: TMusicPlaybackState): string;
begin
  case AState of
    mpsPlaying:
      Result := 'Playing';
    mpsPaused:
      Result := 'Paused';
    mpsError:
      Result := 'Error';
  else
    Result := 'Stopped';
  end;
end;

end.
