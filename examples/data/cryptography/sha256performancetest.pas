program sha256performancetest;

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
  s,ss: AnsiString;
  SB : TBytes;
begin
  writeln('SHA256 of a million "a" symbols');
  SetLength(s, 1000000);
  for i := 1 to 1000000 do s[i] := 'a';
  SB:=TEncoding.UTF8.GetAnsiBytes(S);

  StartTime:=now;
  for i := 0 to 1000 do
  begin
    ss := THashFactory.TCrypto.CreateSHA2_256.ComputeBytes(SB).ToString(False);
    ss := LowerCase(ss);
  end;
  EndTime:=now;
  writeln('SHA256: ',ss);
  write('Performance test finished. Elapsed time: ');
  writeln((EndTime-StartTime)*3600*24:0:3,' s');
end.
