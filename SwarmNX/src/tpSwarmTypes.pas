unit tpSwarmTypes;

{$mode objfpc}{$H+}

interface

uses
  tpNXTorrent;

type
  TSwarmCommandResult = record
    Success: Boolean;
    MessageText: string;
  end;

function SwarmSessionStateText(AState: TNXTorrentSessionState): string;
function MakeSwarmCommandResult(ASuccess: Boolean;
  const AMessageText: string): TSwarmCommandResult;

implementation

function SwarmSessionStateText(AState: TNXTorrentSessionState): string;
begin
  case AState of
    tssRunning:
      Result := 'Running';
    tssPaused:
      Result := 'Paused';
    tssComplete:
      Result := 'Complete';
    tssError:
      Result := 'Error';
  else
    Result := 'Stopped';
  end;
end;

function MakeSwarmCommandResult(ASuccess: Boolean;
  const AMessageText: string): TSwarmCommandResult;
begin
  Result.Success := ASuccess;
  Result.MessageText := AMessageText;
end;

end.
