{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by the Free Pascal development team

    test netdb unit, host part

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program NexusResolverExample;
{$mode objfpc}{$H+}
uses Classes, SysUtils, blcksock;
var
  lSocket: TTCPBlockSocket;
  lAddresses: TStringList;
  lName: string;
  lIndex: Integer;
begin
  lName := 'localhost';
  if ParamCount > 0 then lName := ParamStr(1);
  lSocket := TTCPBlockSocket.Create;
  lAddresses := TStringList.Create;
  try
    lSocket.Family := SF_ANY;
    if (lName = '-r') and (ParamCount = 2) then
      WriteLn(lSocket.ResolveIPToName(ParamStr(2)))
    else if (lName = '-p') and (ParamCount = 2) then
      WriteLn(lSocket.ResolvePort(ParamStr(2)))
    else
    begin
      lSocket.ResolveNameToIP(lName, lAddresses);
      for lIndex := 0 to lAddresses.Count - 1 do WriteLn(lAddresses[lIndex]);
    end;
  finally
    lAddresses.Free;
    lSocket.Free;
  end;
end.
