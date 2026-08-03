unit obMusicArchiveBlobStore;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  obMusicArchiveCatalog;

type
  EMusicArchiveBlobStore = class(Exception);

  TMusicArchiveBlobStore = class
  private
    FCatalog: TMusicArchiveCatalog;
  public
    constructor Create(ACatalog: TMusicArchiveCatalog);

    procedure EnsureReady;

    property Catalog: TMusicArchiveCatalog read FCatalog;
  end;

implementation

constructor TMusicArchiveBlobStore.Create(ACatalog: TMusicArchiveCatalog);
begin
  inherited Create;
  if not Assigned(ACatalog) then
    raise EArgumentNilException.Create('ACatalog');
  FCatalog := ACatalog;
end;

procedure TMusicArchiveBlobStore.EnsureReady;
begin
  if not FCatalog.IsOpen then
    raise EMusicArchiveBlobStore.Create('Audio BLOB store needs an open catalog.');
end;

end.
