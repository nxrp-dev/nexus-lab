program simpleipcserver;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  BaseUnix,
  {$ENDIF}
  {$IFDEF windows}
  Windows,
  {$ENDIF}
  Classes, SysUtils, CustApp, simpleipc;

type

  { TSimpleIPCServerApp }

  TSimpleIPCServerApp = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

{ TSimpleIPCServerApp }

procedure TSimpleIPCServerApp.DoRun;
var
  IPCServer: TSimpleIPCServer;
  lKey: Char;
  NullObj: TObject;
begin
  IPCServer := TSimpleIPCServer.Create(nil);
  IPCServer.ServerID:='ipc_test_crash';
  IPCServer.Global:=True;
  IPCServer.StartServer;
  NullObj := nil;

  WriteLn('Server started');
  WriteLn('  Enter e to finish with an exception');
  WriteLn('  Enter t to terminate through OS api - ', {$IFDEF UNIX}'Kill'{$ELSE}'TerminateProcess'{$ENDIF});
  WriteLn('  Enter any other character to finish normally');
  ReadLn(lKey);

  case lKey of
    'e':
      begin
        NullObj.AfterConstruction;
      end;
    't':
      begin
        {$ifdef unix}
        FpKill(FpGetpid, 9);
        {$endif}
        {$ifdef windows}
        TerminateProcess(GetCurrentProcess, 0);
        {$endif}
      end;
  end;

  IPCServer.Active:=False;
  WriteLn('Server stopped');
  IPCServer.Destroy;
  Terminate;
end;

constructor TSimpleIPCServerApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

var
  Application: TSimpleIPCServerApp;
begin
  Application:=TSimpleIPCServerApp.Create(nil);
  Application.Title:='IPC Server';
  Application.Run;
  Application.Free;
end.

