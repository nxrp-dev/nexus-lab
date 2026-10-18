program testsingle;

uses sysutils, PasZLibIO;

Var
  FN : String;

begin
  FN:=GetTempFileName;
  TUnzipper.Unzip('test.zip','files/file1.txt',FN);
  if not FileExists(FN) then
    Writeln('Error')
  else
    begin
    DeleteFile(FN);
    Writeln('OK');
    end;
end.

