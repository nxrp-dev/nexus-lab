{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program NexusSocketServer;
{$mode objfpc}{$H+}
uses SysUtils, blcksock, synsock;
var
  lListener, lClient: TTCPBlockSocket;
  lHost, lPort, lLine: string;
begin
  lHost := '127.0.0.1';
  lPort := '4100';
  if ParamCount > 0 then lHost := ParamStr(1);
  if ParamCount > 1 then lPort := ParamStr(2);
  lListener := TTCPBlockSocket.Create;
  lClient := TTCPBlockSocket.Create;
  try
    lListener.Family := SF_ANY;
    lListener.Bind(lHost, lPort);
    if lListener.LastError <> 0 then raise Exception.Create(lListener.LastErrorDesc);
    lListener.Listen;
    if lListener.LastError <> 0 then raise Exception.Create(lListener.LastErrorDesc);
    WriteLn('Listening on ', lHost, ':', lListener.GetLocalSinPort);
    Flush(Output);
    if not lListener.CanRead(30000) then raise Exception.Create('No client arrived within 30 seconds');
    lClient.Socket := lListener.Accept;
    if lClient.Socket = INVALID_SOCKET then raise Exception.Create('Accept failed');
    repeat
      lLine := lClient.RecvString(5000);
      if lClient.LastError <> 0 then Break;
      if lLine = 'QUIT' then Break;
      WriteLn(lLine);
      lClient.SendString(lLine + #13#10);
    until lClient.LastError <> 0;
  finally
    lClient.Free;
    lListener.Free;
  end;
end.
