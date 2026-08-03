unit obMusicArchiveController;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  tpMusicArchiveTypes,
  obMusicArchiveBlobStore,
  obMusicArchiveCatalog,
  obMusicArchiveImporter,
  obMusicArchiveViewModels,
  obMusicPlaybackController;

type
  TMusicArchiveController = class
  private
    FBlobStore: TMusicArchiveBlobStore;
    FCatalog: TMusicArchiveCatalog;
    FImporter: TMusicArchiveImporter;
    FImportStatus: string;
    FPlayback: TMusicPlaybackController;
    FSearchText: string;
    FSelectedRecordingId: TMusicRecordingId;
    procedure AddSampleRows(AViewModel: TMusicArchiveViewModel);
    function DefaultArchiveName: string;
  public
    constructor Create(ACatalog: TMusicArchiveCatalog;
      ABlobStore: TMusicArchiveBlobStore; AImporter: TMusicArchiveImporter;
      APlayback: TMusicPlaybackController);

    function BuildViewModel: TMusicArchiveViewModel;
    procedure OpenDefaultArchive;
    procedure Pause;
    procedure Play;
    procedure SelectRecording(AId: TMusicRecordingId);
    procedure SetSearchText(const AValue: string);
    procedure StartImportPreview(const ASourceFolder: string);
    procedure Stop;
  end;

implementation

constructor TMusicArchiveController.Create(ACatalog: TMusicArchiveCatalog;
  ABlobStore: TMusicArchiveBlobStore; AImporter: TMusicArchiveImporter;
  APlayback: TMusicPlaybackController);
begin
  inherited Create;
  if not Assigned(ACatalog) then
    raise EArgumentNilException.Create('ACatalog');
  if not Assigned(ABlobStore) then
    raise EArgumentNilException.Create('ABlobStore');
  if not Assigned(AImporter) then
    raise EArgumentNilException.Create('AImporter');
  if not Assigned(APlayback) then
    raise EArgumentNilException.Create('APlayback');

  FCatalog := ACatalog;
  FBlobStore := ABlobStore;
  FImporter := AImporter;
  FPlayback := APlayback;
  FImportStatus := 'Ready';
end;

procedure TMusicArchiveController.AddSampleRows(AViewModel: TMusicArchiveViewModel);
var
  lRecording: TMusicRecordingSummary;
begin
  lRecording.Id := 1;
  lRecording.StableId := 'sample-intro';
  lRecording.Title := 'Archive shell ready';
  lRecording.DurationText := '00:00';
  lRecording.FormatName := 'SQLite BLOB';
  lRecording.ImportedAtText := 'Not imported';
  lRecording.AvailabilityText := 'Schema ready';
  AViewModel.AddRecording(lRecording);

  lRecording.Id := 2;
  lRecording.StableId := 'sample-import';
  lRecording.Title := 'Import pipeline placeholder';
  lRecording.DurationText := '00:00';
  lRecording.FormatName := 'Pending';
  lRecording.ImportedAtText := 'Not imported';
  lRecording.AvailabilityText := 'Waiting';
  AViewModel.AddRecording(lRecording);
end;

function TMusicArchiveController.BuildViewModel: TMusicArchiveViewModel;
begin
  Result := TMusicArchiveViewModel.Create;
  Result.ArchiveName := ExtractFileName(FCatalog.DatabaseName);
  if Result.ArchiveName = '' then
    Result.ArchiveName := 'MusicArchiveNX';
  Result.ImportStatus := FImportStatus;
  Result.PlaybackState := FPlayback.State;
  Result.PlaybackPositionMs := FPlayback.PositionMs;
  Result.SearchText := FSearchText;
  Result.SelectedRecordingId := FSelectedRecordingId;
  AddSampleRows(Result);
end;

function TMusicArchiveController.DefaultArchiveName: string;
begin
  Result := IncludeTrailingPathDelimiter(GetCurrentDir) + 'data' +
    DirectorySeparator + 'archive.sqlite';
end;

procedure TMusicArchiveController.OpenDefaultArchive;
begin
  FCatalog.Open(DefaultArchiveName);
  FCatalog.CreateSchema;
  FImportStatus := 'Archive database ready';
end;

procedure TMusicArchiveController.Pause;
begin
  FPlayback.Pause;
end;

procedure TMusicArchiveController.Play;
begin
  FPlayback.Play;
end;

procedure TMusicArchiveController.SelectRecording(AId: TMusicRecordingId);
begin
  FSelectedRecordingId := AId;
end;

procedure TMusicArchiveController.SetSearchText(const AValue: string);
begin
  FSearchText := AValue;
end;

procedure TMusicArchiveController.StartImportPreview(const ASourceFolder: string);
var
  lOptions: TMusicImportOptions;
  lSummary: TMusicImportSummary;
begin
  lOptions.SourceFolder := ASourceFolder;
  lOptions.Recursive := True;
  lOptions.SupportedExtensions := '.wav;.mp3;.flac;.ogg;.m4a';
  lSummary := FImporter.PreviewImport(lOptions);
  FImportStatus := lSummary.StatusText;
end;

procedure TMusicArchiveController.Stop;
begin
  FPlayback.Stop;
end;

end.
