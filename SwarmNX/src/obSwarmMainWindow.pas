unit obSwarmMainWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, obNXApplication, obNXButton, obNXControl, obNXEditBox,
  obNXFileDialog, obNXGroupBox, obNXLabel, obNXMemo, obNXProgressBar,
  obNXStatusBar, obNXWindow, tpNXLayout, tpNXPlatform, tpNXWindow,
  obSwarmTorrentController, obSwarmTorrentViewModel;

type
  TSwarmMainWindow = class
  private
    FAdvancedGroup: TNXGroupBox;
    FAnnounceButton: TNXButton;
    FAnnounceEdit: TNXEditBox;
    FConnectButton: TNXButton;
    FController: TSwarmTorrentController;
    FDestinationButton: TNXButton;
    FDestinationLabel: TNXLabel;
    FInfoHashLabel: TNXLabel;
    FLogMemo: TNXMemo;
    FNameLabel: TNXLabel;
    FOpenButton: TNXButton;
    FPauseButton: TNXButton;
    FPeerHostEdit: TNXEditBox;
    FPeerPortEdit: TNXEditBox;
    FPieceIndexEdit: TNXEditBox;
    FPieceLabel: TNXLabel;
    FProgressBar: TNXProgressBar;
    FProgressLabel: TNXLabel;
    FRootWindow: TNXWindow;
    FStartButton: TNXButton;
    FStatusBar: TNXStatusBar;
    FStateLabel: TNXLabel;
    FStopButton: TNXButton;
    FTotalLabel: TNXLabel;
    FVerifyButton: TNXButton;
    procedure AddLog(const AText: string);
    function AddButton(AParent: INXControlParent; const ACaption: string;
      ALeft, ATop, AWidth: Integer; AHandler: TNXMouseEvent): TNXButton;
    function AddEdit(AParent: INXControlParent; const AText: string;
      ALeft, ATop, AWidth: Integer): TNXEditBox;
    function AddLabel(AParent: INXControlParent; const ACaption: string;
      ALeft, ATop, AWidth: Integer): TNXLabel;
    function FormatBytes(AValue: Int64): string;
    function ParseInteger(const AText, AFieldName: string): Integer;
    procedure RefreshView;
    procedure RunCommand(const ADescription: string; ACommand: TNotifyEvent);

    procedure AnnounceClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure ConnectClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure DestinationClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure DestinationDialogResult(Sender: TObject; AResult: TNXModalResult;
      const APath: string);
    procedure OpenClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure OpenDialogResult(Sender: TObject; AResult: TNXModalResult;
      const APath: string);
    procedure PauseClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure StartClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure StopClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure VerifyClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);

    procedure DoAnnounce(Sender: TObject);
    procedure DoConnect(Sender: TObject);
    procedure DoPause(Sender: TObject);
    procedure DoStart(Sender: TObject);
    procedure DoStop(Sender: TObject);
    procedure DoVerify(Sender: TObject);
  public
    constructor Create(ARootWindow: TNXWindow;
      AController: TSwarmTorrentController);
    procedure Build;
  end;

implementation

constructor TSwarmMainWindow.Create(ARootWindow: TNXWindow;
  AController: TSwarmTorrentController);
begin
  inherited Create;
  FRootWindow := ARootWindow;
  FController := AController;
end;

function TSwarmMainWindow.AddButton(AParent: INXControlParent;
  const ACaption: string; ALeft, ATop, AWidth: Integer;
  AHandler: TNXMouseEvent): TNXButton;
begin
  Result := TNXButton.Create(AParent);
  Result.SetBounds(ALeft, ATop, AWidth, 26);
  Result.Caption := ACaption;
  Result.OnMouseClick := AHandler;
end;

function TSwarmMainWindow.AddEdit(AParent: INXControlParent;
  const AText: string; ALeft, ATop, AWidth: Integer): TNXEditBox;
begin
  Result := TNXEditBox.Create(AParent);
  Result.SetBounds(ALeft, ATop, AWidth, 24);
  Result.Text := AText;
end;

function TSwarmMainWindow.AddLabel(AParent: INXControlParent;
  const ACaption: string; ALeft, ATop, AWidth: Integer): TNXLabel;
begin
  Result := TNXLabel.Create(AParent);
  Result.SetBounds(ALeft, ATop, AWidth, 22);
  Result.Caption := ACaption;
end;

function TSwarmMainWindow.FormatBytes(AValue: Int64): string;
begin
  if AValue >= 1024 * 1024 * 1024 then
    Result := FormatFloat('0.00 GB', AValue / (1024 * 1024 * 1024))
  else if AValue >= 1024 * 1024 then
    Result := FormatFloat('0.00 MB', AValue / (1024 * 1024))
  else if AValue >= 1024 then
    Result := FormatFloat('0.00 KB', AValue / 1024)
  else
    Result := IntToStr(AValue) + ' bytes';
end;

function TSwarmMainWindow.ParseInteger(const AText,
  AFieldName: string): Integer;
begin
  if not TryStrToInt(Trim(AText), Result) then
    raise EConvertError.Create(AFieldName + ' must be an integer.');
end;

procedure TSwarmMainWindow.Build;
var
  lClientGroup: TNXGroupBox;
  lInfoGroup: TNXGroupBox;
  lProgressGroup: TNXGroupBox;
begin
  lClientGroup := TNXGroupBox.Create(FRootWindow, 'Client',
    MakeNXRect(12, 12, 970, 92));
  FOpenButton := AddButton(lClientGroup.ContentPanel, 'Load Torrent', 12, 14,
    120, @OpenClick);
  FDestinationButton := AddButton(lClientGroup.ContentPanel, 'Destination', 142,
    14, 120, @DestinationClick);
  FStartButton := AddButton(lClientGroup.ContentPanel, 'Start', 272, 14, 80,
    @StartClick);
  FPauseButton := AddButton(lClientGroup.ContentPanel, 'Pause', 362, 14, 80,
    @PauseClick);
  FStopButton := AddButton(lClientGroup.ContentPanel, 'Stop', 452, 14, 80,
    @StopClick);
  FDestinationLabel := AddLabel(lClientGroup.ContentPanel,
    'Destination: not selected', 12, 48, 900);

  lInfoGroup := TNXGroupBox.Create(FRootWindow, 'Torrent',
    MakeNXRect(12, 114, 970, 138));
  FNameLabel := AddLabel(lInfoGroup.ContentPanel, 'Name: none', 12, 14, 920);
  FInfoHashLabel := AddLabel(lInfoGroup.ContentPanel, 'Info hash:', 12, 42,
    920);
  FTotalLabel := AddLabel(lInfoGroup.ContentPanel, 'Total: 0 bytes', 12, 70,
    260);
  FPieceLabel := AddLabel(lInfoGroup.ContentPanel, 'Pieces: 0', 300, 70, 260);
  FStateLabel := AddLabel(lInfoGroup.ContentPanel, 'Status: Stopped', 590, 70,
    260);

  lProgressGroup := TNXGroupBox.Create(FRootWindow, 'Progress',
    MakeNXRect(12, 264, 970, 92));
  FProgressBar := TNXProgressBar.Create(lProgressGroup.ContentPanel);
  FProgressBar.SetBounds(12, 18, 930, 24);
  FProgressLabel := AddLabel(lProgressGroup.ContentPanel,
    'Progress: 0%  Verified: 0/0', 12, 50, 920);

  FAdvancedGroup := TNXGroupBox.Create(FRootWindow, 'Diagnostics',
    MakeNXRect(12, 368, 970, 132));
  AddLabel(FAdvancedGroup.ContentPanel, 'Announce URL', 12, 14, 100);
  FAnnounceEdit := AddEdit(FAdvancedGroup.ContentPanel, '', 118, 12, 470);
  FAnnounceButton := AddButton(FAdvancedGroup.ContentPanel, 'Announce', 600, 11,
    100, @AnnounceClick);

  AddLabel(FAdvancedGroup.ContentPanel, 'Peer host', 12, 48, 100);
  FPeerHostEdit := AddEdit(FAdvancedGroup.ContentPanel, '127.0.0.1', 118, 46,
    210);
  AddLabel(FAdvancedGroup.ContentPanel, 'Port', 342, 48, 40);
  FPeerPortEdit := AddEdit(FAdvancedGroup.ContentPanel, '6881', 386, 46, 74);
  FConnectButton := AddButton(FAdvancedGroup.ContentPanel, 'Connect To Peer',
    474, 45, 130, @ConnectClick);

  AddLabel(FAdvancedGroup.ContentPanel, 'Piece index', 12, 82, 100);
  FPieceIndexEdit := AddEdit(FAdvancedGroup.ContentPanel, '0', 118, 80, 74);
  FVerifyButton := AddButton(FAdvancedGroup.ContentPanel, 'Verify Piece', 206,
    79, 110, @VerifyClick);

  FLogMemo := TNXMemo.Create(FRootWindow);
  FLogMemo.SetBounds(12, 512, 970, 172);
  FLogMemo.ReadOnly := True;
  FLogMemo.AddLine('SwarmNX ready.');

  FStatusBar := TNXStatusBar.Create(FRootWindow);
  FStatusBar.SimplePanel := False;
  FStatusBar.AddPanel('Ready', 220);
  FStatusBar.AddPanel('No torrent loaded', 420);
  FStatusBar.AddPanel('', 180);

  RefreshView;
end;

procedure TSwarmMainWindow.AddLog(const AText: string);
begin
  FLogMemo.AddLine(FormatDateTime('hh:nn:ss', Now) + '  ' + AText);
  FStatusBar.Panels[0].Text := AText;
end;

procedure TSwarmMainWindow.RefreshView;
var
  lViewModel: TSwarmTorrentViewModel;
begin
  lViewModel := FController.BuildViewModel;
  try
    if lViewModel.HasTorrent then
    begin
      FNameLabel.Caption := 'Name: ' + lViewModel.Name;
      FInfoHashLabel.Caption := 'Info hash: ' + lViewModel.InfoHashHex;
      FTotalLabel.Caption := 'Total: ' + FormatBytes(lViewModel.TotalBytes);
      FPieceLabel.Caption := Format('Pieces: %d  Piece length: %s',
        [lViewModel.PieceCount, FormatBytes(lViewModel.PieceLength)]);
      FAnnounceEdit.Text := lViewModel.AnnounceURL;
      FStatusBar.Panels[1].Text := ExtractFileName(lViewModel.TorrentPath);
    end
    else
    begin
      FNameLabel.Caption := 'Name: none';
      FInfoHashLabel.Caption := 'Info hash:';
      FTotalLabel.Caption := 'Total: 0 bytes';
      FPieceLabel.Caption := 'Pieces: 0';
      FStatusBar.Panels[1].Text := 'No torrent loaded';
    end;

    if lViewModel.HasDestination then
      FDestinationLabel.Caption := 'Destination: ' + lViewModel.DestinationRoot
    else
      FDestinationLabel.Caption := 'Destination: not selected';

    FStateLabel.Caption := 'Status: ' + lViewModel.StateText;
    FProgressBar.Value := lViewModel.ProgressPercent;
    FProgressLabel.Caption := Format('Progress: %d%%  Verified: %d/%d  %s of %s',
      [lViewModel.ProgressPercent, lViewModel.VerifiedPieces,
      lViewModel.PieceCount, FormatBytes(lViewModel.DownloadedBytes),
      FormatBytes(lViewModel.TotalBytes)]);

    FStartButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FPauseButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FStopButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FAnnounceButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FConnectButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FVerifyButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FStatusBar.Panels[2].Text := lViewModel.StateText;
  finally
    lViewModel.Free;
  end;
end;

procedure TSwarmMainWindow.RunCommand(const ADescription: string;
  ACommand: TNotifyEvent);
begin
  try
    ACommand(Self);
    AddLog(ADescription);
  except
    on E: Exception do
      AddLog(ADescription + ' failed: ' + E.Message);
  end;
  RefreshView;
end;

procedure TSwarmMainWindow.OpenClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button <> mbLeft then
    Exit;
  TNXFileDialog.ShowOpen('Load Torrent', GetCurrentDir, '*.torrent',
    @OpenDialogResult);
end;

procedure TSwarmMainWindow.OpenDialogResult(Sender: TObject;
  AResult: TNXModalResult; const APath: string);
begin
  if AResult <> mrOK then
    Exit;
  try
    FController.LoadTorrent(APath);
    AddLog('Loaded torrent ' + APath);
  except
    on E: Exception do
      AddLog('Load torrent failed: ' + E.Message);
  end;
  RefreshView;
end;

procedure TSwarmMainWindow.DestinationClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button <> mbLeft then
    Exit;
  TNXFileDialog.ShowSelectFolder('Select Destination', GetCurrentDir,
    @DestinationDialogResult);
end;

procedure TSwarmMainWindow.DestinationDialogResult(Sender: TObject;
  AResult: TNXModalResult; const APath: string);
begin
  if AResult <> mrOK then
    Exit;
  try
    FController.SetDestinationRoot(APath);
    AddLog('Destination set to ' + APath);
  except
    on E: Exception do
      AddLog('Set destination failed: ' + E.Message);
  end;
  RefreshView;
end;

procedure TSwarmMainWindow.DoStart(Sender: TObject);
begin
  FController.StartSession;
end;

procedure TSwarmMainWindow.StartClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Session started', @DoStart);
end;

procedure TSwarmMainWindow.DoPause(Sender: TObject);
begin
  FController.PauseSession;
end;

procedure TSwarmMainWindow.PauseClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Session paused', @DoPause);
end;

procedure TSwarmMainWindow.DoStop(Sender: TObject);
begin
  FController.StopSession;
end;

procedure TSwarmMainWindow.StopClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Session stopped', @DoStop);
end;

procedure TSwarmMainWindow.DoVerify(Sender: TObject);
begin
  FController.VerifyPiece(ParseInteger(FPieceIndexEdit.Text, 'Piece index'));
end;

procedure TSwarmMainWindow.VerifyClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Piece verified', @DoVerify);
end;

procedure TSwarmMainWindow.DoAnnounce(Sender: TObject);
begin
  AddLog(FController.Announce(FAnnounceEdit.Text,
    ParseInteger(FPeerPortEdit.Text, 'Port')));
end;

procedure TSwarmMainWindow.AnnounceClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Tracker announce completed', @DoAnnounce);
end;

procedure TSwarmMainWindow.DoConnect(Sender: TObject);
begin
  AddLog(FController.ConnectToPeer(FPeerHostEdit.Text,
    ParseInteger(FPeerPortEdit.Text, 'Port')));
end;

procedure TSwarmMainWindow.ConnectClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
    RunCommand('Peer connection completed', @DoConnect);
end;

end.
