program md5performancetest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cwstring,
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}
  {$ENDIF}
  SysUtils,Classes,HlpHashFactory,dateutils;

var
  StartTime: TDateTime;
  EndTime: TDateTime;
  i: integer;
  TimeTaken: string;
  s,ss: RawByteString;
begin
  writeln('MD5 of a million "a" symbols');
  SetLength(s, 1000000);
  for i := 1 to 1000000 do s[i] := 'a';

  StartTime:=now;
  for i := 0 to 1000 do
    ss := LowerCase(THashFactory.TCrypto.CreateMD5.ComputeUntyped(s[1], Length(s)).ToString(False));
  EndTime:=now;
  writeln('Performance test finished. Elapsed time:');
  DateTimeToString(TimeTaken, 'S.ZZ', EndTime-StartTime);
  WriteLn('Average time taken = ', TimeTaken, ' ms');
end.

