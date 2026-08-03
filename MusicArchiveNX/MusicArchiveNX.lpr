program MusicArchiveNX;

{$mode objfpc}{$H+}
{$apptype GUI}

uses
  obMusicArchiveApp;

var
  MusicApp: TMusicArchiveApp;

begin
  MusicApp := TMusicArchiveApp.Create;
  try
    MusicApp.Run;
  finally
    MusicApp.Free;
  end;
end.
