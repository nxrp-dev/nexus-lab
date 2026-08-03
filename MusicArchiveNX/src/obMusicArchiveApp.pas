unit obMusicArchiveApp;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  obNXApplication,
  obMusicArchiveBlobStore,
  obMusicArchiveCatalog,
  obMusicArchiveController,
  obMusicArchiveImporter,
  obMusicDuplicateDetector,
  obMusicMainWindow,
  obMusicMetadataReader,
  obMusicPlaybackController;

type
  TMusicArchiveApp = class
  private
    FBlobStore: TMusicArchiveBlobStore;
    FCatalog: TMusicArchiveCatalog;
    FController: TMusicArchiveController;
    FDuplicateDetector: TMusicDuplicateDetector;
    FImporter: TMusicArchiveImporter;
    FMainWindow: TMusicMainWindow;
    FMetadataReader: TMusicMetadataReader;
    FPlayback: TMusicPlaybackController;
    procedure CopyDirectory(const ASourceDir, ADestDir: string);
    procedure CopyFileBytes(const ASourceFile, ADestFile: string);
    procedure EnsureRuntimeAssets;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run;
  end;

implementation

constructor TMusicArchiveApp.Create;
begin
  inherited Create;
  FCatalog := TMusicArchiveCatalog.Create;
  FBlobStore := TMusicArchiveBlobStore.Create(FCatalog);
  FDuplicateDetector := TMusicDuplicateDetector.Create;
  FMetadataReader := TMusicMetadataReader.Create;
  FImporter := TMusicArchiveImporter.Create(FBlobStore, FDuplicateDetector,
    FMetadataReader);
  FPlayback := TMusicPlaybackController.Create;
  FController := TMusicArchiveController.Create(FCatalog, FBlobStore, FImporter,
    FPlayback);
end;

destructor TMusicArchiveApp.Destroy;
begin
  FMainWindow.Free;
  FController.Free;
  FPlayback.Free;
  FImporter.Free;
  FMetadataReader.Free;
  FDuplicateDetector.Free;
  FBlobStore.Free;
  FCatalog.Free;
  inherited Destroy;
end;

procedure TMusicArchiveApp.CopyDirectory(const ASourceDir, ADestDir: string);
var
  lDestName: string;
  lItem: TSearchRec;
  lSourceName: string;
begin
  if not DirectoryExists(ASourceDir) then
    Exit;

  ForceDirectories(ADestDir);
  if FindFirst(IncludeTrailingPathDelimiter(ASourceDir) + '*',
    faAnyFile, lItem) <> 0 then
    Exit;
  try
    repeat
      if (lItem.Name = '.') or (lItem.Name = '..') then
        Continue;

      lSourceName := IncludeTrailingPathDelimiter(ASourceDir) + lItem.Name;
      lDestName := IncludeTrailingPathDelimiter(ADestDir) + lItem.Name;
      if (lItem.Attr and faDirectory) <> 0 then
        CopyDirectory(lSourceName, lDestName)
      else
        CopyFileBytes(lSourceName, lDestName);
    until FindNext(lItem) <> 0;
  finally
    FindClose(lItem);
  end;
end;

procedure TMusicArchiveApp.CopyFileBytes(const ASourceFile, ADestFile: string);
var
  lDest: TFileStream;
  lSource: TFileStream;
begin
  lSource := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
  try
    lDest := TFileStream.Create(ADestFile, fmCreate);
    try
      lDest.CopyFrom(lSource, 0);
    finally
      lDest.Free;
    end;
  finally
    lSource.Free;
  end;
end;

procedure TMusicArchiveApp.EnsureRuntimeAssets;
var
  lExeDir: string;
  lProjectDir: string;
begin
  lExeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  lProjectDir := IncludeTrailingPathDelimiter(GetCurrentDir);

  CopyDirectory(lProjectDir + 'resources', lExeDir + 'resources');
  CopyDirectory(lProjectDir + 'skins', lExeDir + 'skins');
end;

procedure TMusicArchiveApp.Run;
begin
  EnsureRuntimeAssets;
  Application.Initialize('MusicArchiveNX', 1024, 720);
  Application.Skin.LoadNamedSkin('default', Application.Canvas);
  FMainWindow := TMusicMainWindow.Create(Application.RootWindow, FController);
  FMainWindow.Build;
  Application.Run;
end;

end.
