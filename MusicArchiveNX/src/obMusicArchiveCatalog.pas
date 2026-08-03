unit obMusicArchiveCatalog;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  SQLDB,
  SQLite3Conn;

type
  EMusicArchiveCatalog = class(Exception);

  TMusicArchiveCatalog = class
  private
    FConnection: TSQLite3Connection;
    FDatabaseName: string;
    FOpen: Boolean;
    FTransaction: TSQLTransaction;
    procedure EnsureOpen;
    procedure ExecuteSQL(const ASQL: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Close;
    procedure CreateSchema;
    procedure Open(const ADatabaseName: string);

    property Connection: TSQLite3Connection read FConnection;
    property DatabaseName: string read FDatabaseName;
    property IsOpen: Boolean read FOpen;
    property Transaction: TSQLTransaction read FTransaction;
  end;

implementation

uses
  obMusicArchiveSchema;

constructor TMusicArchiveCatalog.Create;
begin
  inherited Create;
  FConnection := TSQLite3Connection.Create(nil);
  FTransaction := TSQLTransaction.Create(nil);
  FConnection.Transaction := FTransaction;
  FTransaction.DataBase := FConnection;
end;

destructor TMusicArchiveCatalog.Destroy;
begin
  Close;
  FreeAndNil(FTransaction);
  FreeAndNil(FConnection);
  inherited Destroy;
end;

procedure TMusicArchiveCatalog.Close;
begin
  if FTransaction.Active then
    FTransaction.Rollback;
  if FConnection.Connected then
    FConnection.Close;
  FOpen := False;
end;

procedure TMusicArchiveCatalog.CreateSchema;
begin
  EnsureOpen;
  FTransaction.StartTransaction;
  try
    ExecuteSQL('pragma foreign_keys = on');
    ExecuteSQL(cSQLCreateArchiveMeta);
    ExecuteSQL(cSQLCreateRecording);
    ExecuteSQL(cSQLCreateRecordingHashIndex);
    ExecuteSQL(cSQLCreateRecordingContent);
    ExecuteSQL(cSQLCreateRecordingContentChunk);
    ExecuteSQL(cSQLCreateRecordingSource);
    ExecuteSQL(cSQLCreateCategory);
    ExecuteSQL(cSQLCreateRecordingCategory);
    ExecuteSQL(cSQLCreateTag);
    ExecuteSQL(cSQLCreateRecordingTag);
    ExecuteSQL(cSQLCreateAnnotation);
    ExecuteSQL(cSQLCreateAnnotationRangeIndex);
    ExecuteSQL('insert or replace into archive_meta(key, value) values(' +
      QuotedStr('schema_version') + ', ' +
      QuotedStr(IntToStr(cMusicArchiveSchemaVersion)) + ')');
    FTransaction.Commit;
  except
    if FTransaction.Active then
      FTransaction.Rollback;
    raise;
  end;
end;

procedure TMusicArchiveCatalog.EnsureOpen;
begin
  if not FOpen then
    raise EMusicArchiveCatalog.Create('Music archive catalog is not open.');
end;

procedure TMusicArchiveCatalog.ExecuteSQL(const ASQL: string);
begin
  FConnection.ExecuteDirect(ASQL);
end;

procedure TMusicArchiveCatalog.Open(const ADatabaseName: string);
var
  lDirectory: string;
begin
  if ADatabaseName = '' then
    raise EMusicArchiveCatalog.Create('Catalog database name is empty.');

  Close;
  lDirectory := ExtractFileDir(ADatabaseName);
  if lDirectory <> '' then
    ForceDirectories(lDirectory);

  FDatabaseName := ADatabaseName;
  FConnection.DatabaseName := FDatabaseName;
  FConnection.Open;
  FOpen := True;
end;

end.
