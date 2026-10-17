{
  Program to demonstrate verification of a certificate.
  Created by Bernd K. for issue:
  https://gitlab.com/freepascal.org/fpc/source/-/issues/39998
}
program NexusTLSVerification;
{$mode objfpc}{$H+}
uses SysUtils, blcksock, obNXSynapseOpenSSL;
var
  lSocket: TTCPBlockSocket;
begin
  if ParamCount <> 3 then
  begin
    WriteLn('Usage: testverify <host> <port> <CA-PEM-file>');
    Halt(2);
  end;
  if not FileExists(ParamStr(3)) then raise Exception.Create('CA file does not exist');
  lSocket := TTCPBlockSocket.Create;
  try
    lSocket.Family := SF_ANY;
    lSocket.ConnectionTimeout := 3000;
    lSocket.Connect(ParamStr(1), ParamStr(2));
    if lSocket.LastError <> 0 then raise Exception.Create(lSocket.LastErrorDesc);
    lSocket.SSL.SNIHost := ParamStr(1);
    lSocket.SSL.CertCAFile := ParamStr(3);
    lSocket.SSL.VerifyCert := True;
    if not lSocket.SSL.Connect then raise Exception.Create(lSocket.SSL.LastErrorDesc);
    WriteLn(lSocket.SSL.GetSSLVersion, ' ', lSocket.SSL.GetPeerName);
  finally
    lSocket.Free;
  end;
end.
