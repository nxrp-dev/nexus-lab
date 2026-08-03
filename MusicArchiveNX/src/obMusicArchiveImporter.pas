unit obMusicArchiveImporter;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  tpMusicArchiveTypes,
  obMusicArchiveBlobStore,
  obMusicDuplicateDetector,
  obMusicMetadataReader;

type
  TMusicArchiveImporter = class
  private
    FBlobStore: TMusicArchiveBlobStore;
    FDuplicateDetector: TMusicDuplicateDetector;
    FMetadataReader: TMusicMetadataReader;
  public
    constructor Create(ABlobStore: TMusicArchiveBlobStore;
      ADuplicateDetector: TMusicDuplicateDetector;
      AMetadataReader: TMusicMetadataReader);

    function PreviewImport(const AOptions: TMusicImportOptions): TMusicImportSummary;
  end;

implementation

constructor TMusicArchiveImporter.Create(ABlobStore: TMusicArchiveBlobStore;
  ADuplicateDetector: TMusicDuplicateDetector; AMetadataReader: TMusicMetadataReader);
begin
  inherited Create;
  if not Assigned(ABlobStore) then
    raise EArgumentNilException.Create('ABlobStore');
  if not Assigned(ADuplicateDetector) then
    raise EArgumentNilException.Create('ADuplicateDetector');
  if not Assigned(AMetadataReader) then
    raise EArgumentNilException.Create('AMetadataReader');

  FBlobStore := ABlobStore;
  FDuplicateDetector := ADuplicateDetector;
  FMetadataReader := AMetadataReader;
end;

function TMusicArchiveImporter.PreviewImport(
  const AOptions: TMusicImportOptions): TMusicImportSummary;
begin
  FBlobStore.EnsureReady;
  Result.ScannedCount := 0;
  Result.ImportedCount := 0;
  Result.DuplicateCount := 0;
  Result.SkippedCount := 0;
  Result.ErrorCount := 0;
  Result.Cancelled := False;
  if AOptions.SourceFolder = '' then
    Result.StatusText := 'No source folder selected.'
  else if DirectoryExists(AOptions.SourceFolder) then
    Result.StatusText := 'Import pipeline ready for ' + AOptions.SourceFolder
  else
  begin
    Result.ErrorCount := 1;
    Result.StatusText := 'Source folder does not exist: ' + AOptions.SourceFolder;
  end;
end;

end.
