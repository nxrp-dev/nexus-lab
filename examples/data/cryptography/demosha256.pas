{
  This file is part of the Free Component Library.
  Copyright (c) 2023 by the Free Pascal team.

  Demonstrate SHA 256 routines.

  See the file COPYING.FPC, included in this distribution,
  for details about the copyright.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
program demosha256;

{$mode objfpc}
{$h+}

uses SysUtils, HlpHashFactory;

procedure SHA256Test;

var
  aSource,Digest : AnsiString;
  S : TBytes;

begin
  aSource:='abc';
  S:=TEncoding.UTF8.GetAnsiBytes(aSource);
  Digest := THashFactory.TCrypto.CreateSHA2_256.ComputeBytes(S).ToString(False);
  if (Digest<> 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD') then
    raise Exception.Create('ERR_SHA256');
  SetLength(S,0);
  Digest := THashFactory.TCrypto.CreateSHA2_256.ComputeBytes(S).ToString(False);
  if (Digest<> 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855') then
    raise Exception.Create('ERR_SHA256');
end;

begin
  SHA256Test
end.

