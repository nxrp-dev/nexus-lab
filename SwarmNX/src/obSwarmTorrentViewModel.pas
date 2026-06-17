unit obSwarmTorrentViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, tpNXTorrent, tpSwarmTypes;

type
  TSwarmTorrentViewModel = class
  private
    FAnnounceURL: string;
    FDestinationRoot: string;
    FDownloadedBytes: Int64;
    FHasDestination: Boolean;
    FHasTorrent: Boolean;
    FInfoHashHex: string;
    FName: string;
    FPieceCount: Integer;
    FPieceLength: Integer;
    FProgressPercent: Integer;
    FState: TNXTorrentSessionState;
    FTorrentPath: string;
    FTotalBytes: Int64;
    FVerifiedPieces: Integer;
    function GetStateText: string;
  public
    constructor CreateEmpty;
    constructor Create(const ATorrentPath, ADestinationRoot, AName,
      AInfoHashHex, AAnnounceURL: string; APieceLength, APieceCount,
      AVerifiedPieces: Integer; ATotalBytes, ADownloadedBytes: Int64;
      AState: TNXTorrentSessionState);

    property AnnounceURL: string read FAnnounceURL;
    property DestinationRoot: string read FDestinationRoot;
    property DownloadedBytes: Int64 read FDownloadedBytes;
    property HasDestination: Boolean read FHasDestination;
    property HasTorrent: Boolean read FHasTorrent;
    property InfoHashHex: string read FInfoHashHex;
    property Name: string read FName;
    property PieceCount: Integer read FPieceCount;
    property PieceLength: Integer read FPieceLength;
    property ProgressPercent: Integer read FProgressPercent;
    property State: TNXTorrentSessionState read FState;
    property StateText: string read GetStateText;
    property TorrentPath: string read FTorrentPath;
    property TotalBytes: Int64 read FTotalBytes;
    property VerifiedPieces: Integer read FVerifiedPieces;
  end;

implementation

constructor TSwarmTorrentViewModel.CreateEmpty;
begin
  inherited Create;
  FState := tssStopped;
end;

function TSwarmTorrentViewModel.GetStateText: string;
begin
  Result := SwarmSessionStateText(FState);
end;

constructor TSwarmTorrentViewModel.Create(const ATorrentPath,
  ADestinationRoot, AName, AInfoHashHex, AAnnounceURL: string; APieceLength,
  APieceCount, AVerifiedPieces: Integer; ATotalBytes, ADownloadedBytes: Int64;
  AState: TNXTorrentSessionState);
begin
  inherited Create;
  FTorrentPath := ATorrentPath;
  FDestinationRoot := ADestinationRoot;
  FName := AName;
  FInfoHashHex := AInfoHashHex;
  FAnnounceURL := AAnnounceURL;
  FPieceLength := APieceLength;
  FPieceCount := APieceCount;
  FVerifiedPieces := AVerifiedPieces;
  FTotalBytes := ATotalBytes;
  FDownloadedBytes := ADownloadedBytes;
  FState := AState;
  FHasTorrent := FTorrentPath <> '';
  FHasDestination := FDestinationRoot <> '';
  if FTotalBytes > 0 then
    FProgressPercent := Round((FDownloadedBytes / FTotalBytes) * 100)
  else
    FProgressPercent := 0;
end;

end.
