(*
  Copyright (c) 2026 Kevin Collins.
  SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
*)

program Mixed;

{$mode objfpc}{$H+}
{$link native.o}
{$link twice.o}

function nx_add(ALeft, ARight: LongInt): LongInt; cdecl; external;
function nx_twice(AValue: LongInt): LongInt; cdecl; external;

begin
  if nx_twice(nx_add(19, 2)) <> 42 then
    Halt(1);
  WriteLn('C, C++, and Pascal built in declaration order.');
end.
