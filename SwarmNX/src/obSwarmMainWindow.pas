unit obSwarmMainWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpg_button,
  fpg_dialogs,
  fpg_edit,
  fpg_form,
  fpg_label,
  fpg_memo,
  fpg_panel,
  fpg_progressbar,
  fpg_widget,
  obSwarmTorrentController, obSwarmTorrentViewModel;

type
  TSwarmMainWindow = class(TfpgForm)
  private
    FAdvancedGroup: TfpgGroupBox;
    FAnnounceButton: TfpgButton;
    FAnnounceEdit: TfpgEdit;
    FConnectButton: TfpgButton;
    FController: TSwarmTorrentController;
    FDestinationButton: TfpgButton;
    FDestinationLabel: TfpgLabel;
    FInfoHashLabel: TfpgLabel;
    FLogMemo: TfpgMemo;
    FNameLabel: TfpgLabel;
    FOpenButton: TfpgButton;
    FPauseButton: TfpgButton;
    FPeerHostEdit: TfpgEdit;
    FPeerPortEdit: TfpgEdit;
    FPieceIndexEdit: TfpgEdit;
    FPieceLabel: TfpgLabel;
    FProgressBar: TfpgProgressBar;
    FProgressLabel: TfpgLabel;
    FStartButton: TfpgButton;
    FStatusBar: TfpgPanel;
    FStatusLabels: array[0..2] of TfpgLabel;
    FStateLabel: TfpgLabel;
    FStopButton: TfpgButton;
    FTotalLabel: TfpgLabel;
    FVerifyButton: TfpgButton;
    procedure AddLog(const AText: string);
    function AddButton(AParent: TComponent; const ACaption: string;
      ALeft, ATop, AWidth: Integer; AHandler: TNotifyEvent): TfpgButton;
    function AddEdit(AParent: TComponent; const AText: string;
      ALeft, ATop, AWidth: Integer): TfpgEdit;
    function AddLabel(AParent: TComponent; const ACaption: string;
      ALeft, ATop, AWidth: Integer): TfpgLabel;
    function FormatBytes(AValue: Int64): string;
    function ParseInteger(const AText, AFieldName: string): Integer;
    procedure RefreshView;
    procedure RunCommand(const ADescription: string; ACommand: TNotifyEvent);
    procedure SetWidgetBounds(AWidget: TfpgWidget; ALeft, ATop, AWidth,
      AHeight: Integer);

    procedure AnnounceClick(ASender: TObject);
    procedure ConnectClick(ASender: TObject);
    procedure DestinationClick(ASender: TObject);
    procedure OpenClick(ASender: TObject);
    procedure PauseClick(ASender: TObject);
    procedure StartClick(ASender: TObject);
    procedure StopClick(ASender: TObject);
    procedure VerifyClick(ASender: TObject);

    procedure DoAnnounce(ASender: TObject);
    procedure DoConnect(ASender: TObject);
    procedure DoPause(ASender: TObject);
    procedure DoStart(ASender: TObject);
    procedure DoStop(ASender: TObject);
    procedure DoVerify(ASender: TObject);
  public
    constructor Create(AOwner: TComponent;
      AController: TSwarmTorrentController); reintroduce;
    procedure Build;
  end;

implementation

constructor TSwarmMainWindow.Create(AOwner: TComponent;
  AController: TSwarmTorrentController);
begin
  inherited Create(AOwner);
  FController := AController;
end;

function TSwarmMainWindow.AddButton(AParent: TComponent;
  const ACaption: string; ALeft, ATop, AWidth: Integer;
  AHandler: TNotifyEvent): TfpgButton;
begin
  Result := TfpgButton.Create(AParent);
  SetWidgetBounds(Result, ALeft, ATop, AWidth, 26);
  Result.Text := ACaption;
  Result.OnClick := AHandler;
end;

function TSwarmMainWindow.AddEdit(AParent: TComponent;
  const AText: string; ALeft, ATop, AWidth: Integer): TfpgEdit;
begin
  Result := TfpgEdit.Create(AParent);
  SetWidgetBounds(Result, ALeft, ATop, AWidth, 24);
  Result.Text := AText;
end;

function TSwarmMainWindow.AddLabel(AParent: TComponent;
  const ACaption: string; ALeft, ATop, AWidth: Integer): TfpgLabel;
begin
  Result := TfpgLabel.Create(AParent);
  SetWidgetBounds(Result, ALeft, ATop, AWidth, 22);
  Result.Text := ACaption;
end;

procedure TSwarmMainWindow.SetWidgetBounds(AWidget: TfpgWidget; ALeft, ATop,
  AWidth, AHeight: Integer);
begin
  AWidget.Left := ALeft;
  AWidget.Top := ATop;
  AWidget.Width := AWidth;
  AWidget.Height := AHeight;
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
  lClientGroup: TfpgGroupBox;
  lInfoGroup: TfpgGroupBox;
  lProgressGroup: TfpgGroupBox;
begin
  Name := 'SwarmMainForm';
  Width := 1024;
  Height := 720;
  MinWidth := 1024;
  MinHeight := 720;
  WindowPosition := wpScreenCenter;
  WindowTitle := 'SwarmNX';

  lClientGroup := TfpgGroupBox.Create(Self);
  SetWidgetBounds(lClientGroup, 12, 12, 970, 92);
  lClientGroup.Text := 'Client';
  FOpenButton := AddButton(lClientGroup, 'Load Torrent', 12, 24,
    120, @OpenClick);
  FDestinationButton := AddButton(lClientGroup, 'Destination', 142,
    24, 120, @DestinationClick);
  FStartButton := AddButton(lClientGroup, 'Start', 272, 24, 80,
    @StartClick);
  FPauseButton := AddButton(lClientGroup, 'Pause', 362, 24, 80,
    @PauseClick);
  FStopButton := AddButton(lClientGroup, 'Stop', 452, 24, 80,
    @StopClick);
  FDestinationLabel := AddLabel(lClientGroup,
    'Destination: not selected', 12, 56, 900);

  lInfoGroup := TfpgGroupBox.Create(Self);
  SetWidgetBounds(lInfoGroup, 12, 114, 970, 138);
  lInfoGroup.Text := 'Torrent';
  FNameLabel := AddLabel(lInfoGroup, 'Name: none', 12, 24, 920);
  FInfoHashLabel := AddLabel(lInfoGroup, 'Info hash:', 12, 52,
    920);
  FTotalLabel := AddLabel(lInfoGroup, 'Total: 0 bytes', 12, 80,
    260);
  FPieceLabel := AddLabel(lInfoGroup, 'Pieces: 0', 300, 80, 260);
  FStateLabel := AddLabel(lInfoGroup, 'Status: Stopped', 590, 80,
    260);

  lProgressGroup := TfpgGroupBox.Create(Self);
  SetWidgetBounds(lProgressGroup, 12, 264, 970, 92);
  lProgressGroup.Text := 'Progress';
  FProgressBar := TfpgProgressBar.Create(lProgressGroup);
  SetWidgetBounds(FProgressBar, 12, 28, 930, 24);
  FProgressLabel := AddLabel(lProgressGroup,
    'Progress: 0%  Verified: 0/0', 12, 58, 920);

  FAdvancedGroup := TfpgGroupBox.Create(Self);
  SetWidgetBounds(FAdvancedGroup, 12, 368, 970, 132);
  FAdvancedGroup.Text := 'Diagnostics';
  AddLabel(FAdvancedGroup, 'Announce URL', 12, 24, 100);
  FAnnounceEdit := AddEdit(FAdvancedGroup, '', 118, 22, 470);
  FAnnounceButton := AddButton(FAdvancedGroup, 'Announce', 600, 21,
    100, @AnnounceClick);

  AddLabel(FAdvancedGroup, 'Peer host', 12, 58, 100);
  FPeerHostEdit := AddEdit(FAdvancedGroup, '127.0.0.1', 118, 56,
    210);
  AddLabel(FAdvancedGroup, 'Port', 342, 58, 40);
  FPeerPortEdit := AddEdit(FAdvancedGroup, '6881', 386, 56, 74);
  FConnectButton := AddButton(FAdvancedGroup, 'Connect To Peer',
    474, 55, 130, @ConnectClick);

  AddLabel(FAdvancedGroup, 'Piece index', 12, 92, 100);
  FPieceIndexEdit := AddEdit(FAdvancedGroup, '0', 118, 90, 74);
  FVerifyButton := AddButton(FAdvancedGroup, 'Verify Piece', 206,
    89, 110, @VerifyClick);

  FLogMemo := TfpgMemo.Create(Self);
  SetWidgetBounds(FLogMemo, 12, 512, 970, 172);
  FLogMemo.ReadOnly := True;
  FLogMemo.Lines.Add('SwarmNX ready.');

  FStatusBar := TfpgPanel.Create(Self);
  SetWidgetBounds(FStatusBar, 12, 690, 970, 26);
  FStatusLabels[0] := AddLabel(FStatusBar, 'Ready', 8, 2, 220);
  FStatusLabels[1] := AddLabel(FStatusBar, 'No torrent loaded', 236, 2, 420);
  FStatusLabels[2] := AddLabel(FStatusBar, '', 664, 2, 290);

  RefreshView;
end;

procedure TSwarmMainWindow.AddLog(const AText: string);
begin
  FLogMemo.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + AText);
  FStatusLabels[0].Text := AText;
end;

procedure TSwarmMainWindow.RefreshView;
var
  lViewModel: TSwarmTorrentViewModel;
begin
  lViewModel := FController.BuildViewModel;
  try
    if lViewModel.HasTorrent then
    begin
      FNameLabel.Text := 'Name: ' + lViewModel.Name;
      FInfoHashLabel.Text := 'Info hash: ' + lViewModel.InfoHashHex;
      FTotalLabel.Text := 'Total: ' + FormatBytes(lViewModel.TotalBytes);
      FPieceLabel.Text := Format('Pieces: %d  Piece length: %s',
        [lViewModel.PieceCount, FormatBytes(lViewModel.PieceLength)]);
      FAnnounceEdit.Text := lViewModel.AnnounceURL;
      FStatusLabels[1].Text := ExtractFileName(lViewModel.TorrentPath);
    end
    else
    begin
      FNameLabel.Text := 'Name: none';
      FInfoHashLabel.Text := 'Info hash:';
      FTotalLabel.Text := 'Total: 0 bytes';
      FPieceLabel.Text := 'Pieces: 0';
      FStatusLabels[1].Text := 'No torrent loaded';
    end;

    if lViewModel.HasDestination then
      FDestinationLabel.Text := 'Destination: ' + lViewModel.DestinationRoot
    else
      FDestinationLabel.Text := 'Destination: not selected';

    FStateLabel.Text := 'Status: ' + lViewModel.StateText;
    FProgressBar.Position := lViewModel.ProgressPercent;
    FProgressLabel.Text := Format('Progress: %d%%  Verified: %d/%d  %s of %s',
      [lViewModel.ProgressPercent, lViewModel.VerifiedPieces,
      lViewModel.PieceCount, FormatBytes(lViewModel.DownloadedBytes),
      FormatBytes(lViewModel.TotalBytes)]);

    FStartButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FPauseButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FStopButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FAnnounceButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FConnectButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FVerifyButton.Enabled := lViewModel.HasTorrent and lViewModel.HasDestination;
    FStatusLabels[2].Text := lViewModel.StateText;
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

procedure TSwarmMainWindow.OpenClick(ASender: TObject);
var
  lPath: string;
begin
  lPath := SelectFileDialog(sfdOpen, 'Torrent files (*.torrent)|*.torrent',
    GetCurrentDir);
  if lPath = '' then
    Exit;
  try
    FController.LoadTorrent(lPath);
    AddLog('Loaded torrent ' + lPath);
  except
    on E: Exception do
      AddLog('Load torrent failed: ' + E.Message);
  end;
  RefreshView;
end;

procedure TSwarmMainWindow.DestinationClick(ASender: TObject);
var
  lPath: string;
begin
  lPath := SelectDirDialog(GetCurrentDir);
  if lPath = '' then
    Exit;
  try
    FController.SetDestinationRoot(lPath);
    AddLog('Destination set to ' + lPath);
  except
    on E: Exception do
      AddLog('Set destination failed: ' + E.Message);
  end;
  RefreshView;
end;

procedure TSwarmMainWindow.DoStart(ASender: TObject);
begin
  FController.StartSession;
end;

procedure TSwarmMainWindow.StartClick(ASender: TObject);
begin
  RunCommand('Session started', @DoStart);
end;

procedure TSwarmMainWindow.DoPause(ASender: TObject);
begin
  FController.PauseSession;
end;

procedure TSwarmMainWindow.PauseClick(ASender: TObject);
begin
  RunCommand('Session paused', @DoPause);
end;

procedure TSwarmMainWindow.DoStop(ASender: TObject);
begin
  FController.StopSession;
end;

procedure TSwarmMainWindow.StopClick(ASender: TObject);
begin
  RunCommand('Session stopped', @DoStop);
end;

procedure TSwarmMainWindow.DoVerify(ASender: TObject);
begin
  FController.VerifyPiece(ParseInteger(FPieceIndexEdit.Text, 'Piece index'));
end;

procedure TSwarmMainWindow.VerifyClick(ASender: TObject);
begin
  RunCommand('Piece verified', @DoVerify);
end;

procedure TSwarmMainWindow.DoAnnounce(ASender: TObject);
begin
  AddLog(FController.Announce(FAnnounceEdit.Text,
    ParseInteger(FPeerPortEdit.Text, 'Port')));
end;

procedure TSwarmMainWindow.AnnounceClick(ASender: TObject);
begin
  RunCommand('Tracker announce completed', @DoAnnounce);
end;

procedure TSwarmMainWindow.DoConnect(ASender: TObject);
begin
  AddLog(FController.ConnectToPeer(FPeerHostEdit.Text,
    ParseInteger(FPeerPortEdit.Text, 'Port')));
end;

procedure TSwarmMainWindow.ConnectClick(ASender: TObject);
begin
  RunCommand('Peer connection completed', @DoConnect);
end;

end.
