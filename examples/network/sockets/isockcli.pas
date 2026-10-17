{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program NexusSocketClient;
{$mode objfpc}{$H+}
uses SysUtils, blcksock;
var
  lSocket: TTCPBlockSocket;
  lHost, lPort: string;
  lIndex: Integer;
begin
  lHost := '127.0.0.1';
  lPort := '4100';
  if ParamCount > 0 then lHost := ParamStr(1);
  if ParamCount > 1 then lPort := ParamStr(2);
  lSocket := TTCPBlockSocket.Create;
  try
    lSocket.Family := SF_ANY;
    lSocket.ConnectionTimeout := 1000;
    lSocket.Connect(lHost, lPort);
    if lSocket.LastError <> 0 then raise Exception.Create(lSocket.LastErrorDesc);
    for lIndex := 1 to 3 do
    begin
      lSocket.SendString('Nexus message ' + IntToStr(lIndex) + #13#10);
      WriteLn(lSocket.RecvString(1000));
      if lSocket.LastError <> 0 then raise Exception.Create(lSocket.LastErrorDesc);
    end;
    lSocket.SendString('QUIT' + #13#10);
  finally
    lSocket.Free;
  end;
end.
