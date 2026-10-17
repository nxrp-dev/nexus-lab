program sha1performancetest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils,Classes,HlpHashFactory;

var
  StartTime: TDateTime;
  EndTime: TDateTime;
  i: integer;
  s,ss: RawByteString;
begin
  writeln('SHA1 of a million "a" symbols');
  SetLength(s, 1000000);
  for i := 1 to 1000000 do s[i] := 'a';

  StartTime:=now;
  for i := 0 to 1000 do
    ss := LowerCase(THashFactory.TCrypto.CreateSHA1.ComputeUntyped(s[1], Length(s)).ToString(False));
  EndTime:=now;
  writeln('SHA1: ',ss);
  write('Performance test finished. Elapsed time: ');
  writeln((EndTime-StartTime)*3600*24:0:3,' s');
end.

