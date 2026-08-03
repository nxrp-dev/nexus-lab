unit obMusicDuplicateDetector;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type
  TMusicDuplicateDetector = class
  public
    function IsSupportedCandidate(const AFileName: string): Boolean; virtual;
  end;

implementation

function TMusicDuplicateDetector.IsSupportedCandidate(
  const AFileName: string): Boolean;
var
  lExt: string;
begin
  lExt := LowerCase(ExtractFileExt(AFileName));
  Result := (lExt = '.wav') or (lExt = '.mp3') or (lExt = '.flac') or
    (lExt = '.ogg') or (lExt = '.m4a');
end;

end.
