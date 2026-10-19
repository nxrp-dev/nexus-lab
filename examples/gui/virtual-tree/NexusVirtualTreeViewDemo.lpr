(*
  Copyright (c) 2026 Kevin Collins.
  SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
*)

program NexusVirtualTreeViewDemo;

{$mode objfpc}{$H+}
{$apptype GUI}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  SysUtils, uiNXVirtualTreeViewDemo;

begin
  try
    RunNXVirtualTreeViewDemo;
  except
    on lError: Exception do
    begin
      WriteLn(StdErr, lError.ClassName, ': ', lError.Message);
      WriteLn(StdErr, BackTraceStrFunc(ExceptAddr));
      ExitCode := 1;
    end;
  end;
end.
