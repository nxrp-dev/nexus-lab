program SwarmNX;

{$mode objfpc}{$H+}
{$apptype GUI}

uses
  obSwarmClientApp;

var
  SwarmApp: TSwarmClientApp;

begin
  SwarmApp := TSwarmClientApp.Create;
  try
    SwarmApp.Run;
  finally
    SwarmApp.Free;
  end;
end.
