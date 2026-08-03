unit obMusicMainWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  obNXButton,
  obNXControl,
  obNXEditBox,
  obNXFileDialog,
  obNXGrid,
  obNXGroupBox,
  obNXLabel,
  obNXListBox,
  obNXMemo,
  obNXPanel,
  obNXStatusBar,
  obNXTrackBar,
  obNXWindow,
  tpNXEvents,
  tpNXPlatform,
  tpNXWindow,
  tpMusicArchiveTypes,
  obMusicArchiveController,
  obMusicArchiveViewModels,
  obMusicTimelineControl;

type
  TMusicMainWindow = class
  private
    FAnnotationMemo: TNXMemo;
    FCategoryList: TNXListBox;
    FController: TMusicArchiveController;
    FDescriptionMemo: TNXMemo;
    FImportButton: TNXButton;
    FPauseButton: TNXButton;
    FPlayButton: TNXButton;
    FRecordingGrid: TNXGrid;
    FRootWindow: TNXWindow;
    FSearchEdit: TNXEditBox;
    FStatusBar: TNXStatusBar;
    FStopButton: TNXButton;
    FTimeline: TMusicTimelineControl;
    FTitleEdit: TNXEditBox;
    FVolumeTrack: TNXTrackBar;
    function AddButton(AParent: INXControlParent; const ACaption: string;
      ALeft, ATop, AWidth: Integer; AHandler: TNXMouseEvent): TNXButton;
    function AddLabel(AParent: INXControlParent; const ACaption: string;
      ALeft, ATop, AWidth: Integer): TNXLabel;
    procedure PopulateRecordings(AViewModel: TMusicArchiveViewModel);
    procedure RefreshView;
    procedure ImportClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure ImportDialogResult(Sender: TObject; AResult: TNXModalResult;
      const APath: string);
    procedure PauseClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure PlayClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
    procedure RecordingSelected(Sender: TObject; ACol, ARow: Integer);
    procedure SearchChanged(Sender: TObject);
    procedure StopClick(Sender: TObject; X, Y: Integer; Button: TNXMouseButton);
  public
    constructor Create(ARootWindow: TNXWindow;
      AController: TMusicArchiveController);

    procedure Build;
  end;

implementation

constructor TMusicMainWindow.Create(ARootWindow: TNXWindow;
  AController: TMusicArchiveController);
begin
  inherited Create;
  FRootWindow := ARootWindow;
  FController := AController;
end;

function TMusicMainWindow.AddButton(AParent: INXControlParent;
  const ACaption: string; ALeft, ATop, AWidth: Integer;
  AHandler: TNXMouseEvent): TNXButton;
begin
  Result := TNXButton.Create(AParent);
  Result.SetBounds(ALeft, ATop, AWidth, 26);
  Result.Caption := ACaption;
  Result.OnMouseClick := AHandler;
end;

function TMusicMainWindow.AddLabel(AParent: INXControlParent;
  const ACaption: string; ALeft, ATop, AWidth: Integer): TNXLabel;
begin
  Result := TNXLabel.Create(AParent);
  Result.SetBounds(ALeft, ATop, AWidth, 22);
  Result.Caption := ACaption;
end;

procedure TMusicMainWindow.Build;
var
  lBottomPanel: TNXGroupBox;
  lCommandPanel: TNXGroupBox;
  lDetailPanel: TNXGroupBox;
  lNavigationPanel: TNXGroupBox;
begin
  FController.OpenDefaultArchive;

  lCommandPanel := TNXGroupBox.Create(FRootWindow, 'Archive',
    MakeNXRect(12, 12, 1000, 72));
  FImportButton := AddButton(lCommandPanel.ContentPanel, 'Import Folder', 12,
    14, 120, @ImportClick);
  AddLabel(lCommandPanel.ContentPanel, 'Search', 154, 16, 60);
  FSearchEdit := TNXEditBox.Create(lCommandPanel.ContentPanel);
  FSearchEdit.SetBounds(214, 14, 360, 24);
  FSearchEdit.OnChange := @SearchChanged;

  lNavigationPanel := TNXGroupBox.Create(FRootWindow, 'Categories',
    MakeNXRect(12, 96, 220, 472));
  FCategoryList := TNXListBox.Create(lNavigationPanel.ContentPanel);
  FCategoryList.SetBounds(10, 12, 190, 416);
  FCategoryList.Items.AddItem('All Recordings', 0);
  FCategoryList.Items.AddItem('Uncategorized', 1);
  FCategoryList.Items.AddItem('Recent Imports', 2);

  FRecordingGrid := TNXGrid.Create(FRootWindow);
  FRecordingGrid.SetBounds(244, 104, 462, 456);
  FRecordingGrid.ResizeGrid(5, 0);
  FRecordingGrid.Headers[0] := 'Title';
  FRecordingGrid.Headers[1] := 'Duration';
  FRecordingGrid.Headers[2] := 'Format';
  FRecordingGrid.Headers[3] := 'Imported';
  FRecordingGrid.Headers[4] := 'Status';
  FRecordingGrid.ColWidths[0] := 150;
  FRecordingGrid.ColWidths[1] := 70;
  FRecordingGrid.ColWidths[2] := 80;
  FRecordingGrid.ColWidths[3] := 80;
  FRecordingGrid.ColWidths[4] := 90;
  FRecordingGrid.SelectionMode := gsmRow;
  FRecordingGrid.OnCellSelected := @RecordingSelected;

  lDetailPanel := TNXGroupBox.Create(FRootWindow, 'Recording',
    MakeNXRect(718, 96, 294, 472));
  AddLabel(lDetailPanel.ContentPanel, 'Title', 10, 12, 70);
  FTitleEdit := TNXEditBox.Create(lDetailPanel.ContentPanel);
  FTitleEdit.SetBounds(10, 36, 254, 24);
  AddLabel(lDetailPanel.ContentPanel, 'Description', 10, 70, 120);
  FDescriptionMemo := TNXMemo.Create(lDetailPanel.ContentPanel);
  FDescriptionMemo.SetBounds(10, 94, 254, 132);
  AddLabel(lDetailPanel.ContentPanel, 'Annotations', 10, 238, 120);
  FAnnotationMemo := TNXMemo.Create(lDetailPanel.ContentPanel);
  FAnnotationMemo.SetBounds(10, 262, 254, 166);
  FAnnotationMemo.ReadOnly := True;
  FAnnotationMemo.AddLine('Select a time range to annotate.');

  lBottomPanel := TNXGroupBox.Create(FRootWindow, 'Playback',
    MakeNXRect(12, 580, 1000, 98));
  FPlayButton := AddButton(lBottomPanel.ContentPanel, 'Play', 12, 16, 72,
    @PlayClick);
  FPauseButton := AddButton(lBottomPanel.ContentPanel, 'Pause', 92, 16, 72,
    @PauseClick);
  FStopButton := AddButton(lBottomPanel.ContentPanel, 'Stop', 172, 16, 72,
    @StopClick);
  FTimeline := TMusicTimelineControl.Create(lBottomPanel.ContentPanel);
  FTimeline.SetBounds(264, 12, 560, 36);
  FTimeline.DurationMs := 180000;
  AddLabel(lBottomPanel.ContentPanel, 'Volume', 838, 18, 58);
  FVolumeTrack := TNXTrackBar.Create(lBottomPanel.ContentPanel);
  FVolumeTrack.SetBounds(898, 14, 74, 28);
  FVolumeTrack.Value := 80;

  FStatusBar := TNXStatusBar.Create(FRootWindow);
  FStatusBar.SimplePanel := False;
  FStatusBar.AddPanel('Ready', 220);
  FStatusBar.AddPanel('Archive database ready', 500);
  FStatusBar.AddPanel('Stopped', 180);

  RefreshView;
end;

procedure TMusicMainWindow.ImportClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button <> mbLeft then
    Exit;

  TNXFileDialog.ShowSelectFolder('Import Music Folder', GetCurrentDir,
    @ImportDialogResult);
end;

procedure TMusicMainWindow.ImportDialogResult(Sender: TObject;
  AResult: TNXModalResult; const APath: string);
begin
  if AResult <> mrOK then
    Exit;

  FController.StartImportPreview(APath);
  RefreshView;
end;

procedure TMusicMainWindow.PauseClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
  begin
    FController.Pause;
    RefreshView;
  end;
end;

procedure TMusicMainWindow.PlayClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
  begin
    FController.Play;
    RefreshView;
  end;
end;

procedure TMusicMainWindow.PopulateRecordings(AViewModel: TMusicArchiveViewModel);
var
  lIndex: Integer;
  lRecording: TMusicRecordingSummary;
begin
  FRecordingGrid.RowCount := AViewModel.RecordingCount;
  for lIndex := 0 to AViewModel.RecordingCount - 1 do
  begin
    lRecording := AViewModel.Recordings[lIndex];
    FRecordingGrid.Cells[0, lIndex] := lRecording.Title;
    FRecordingGrid.Cells[1, lIndex] := lRecording.DurationText;
    FRecordingGrid.Cells[2, lIndex] := lRecording.FormatName;
    FRecordingGrid.Cells[3, lIndex] := lRecording.ImportedAtText;
    FRecordingGrid.Cells[4, lIndex] := lRecording.AvailabilityText;
  end;
end;

procedure TMusicMainWindow.RecordingSelected(Sender: TObject; ACol, ARow: Integer);
begin
  if ARow < 0 then
    Exit;

  FController.SelectRecording(ARow + 1);
  RefreshView;
end;

procedure TMusicMainWindow.RefreshView;
var
  lViewModel: TMusicArchiveViewModel;
begin
  lViewModel := FController.BuildViewModel;
  try
    PopulateRecordings(lViewModel);
    FStatusBar.Panels[0].Text := lViewModel.ImportStatus;
    FStatusBar.Panels[1].Text := lViewModel.ArchiveName;
    FStatusBar.Panels[2].Text := lViewModel.PlaybackStateText;
    FTimeline.PositionMs := lViewModel.PlaybackPositionMs;
  finally
    lViewModel.Free;
  end;
end;

procedure TMusicMainWindow.SearchChanged(Sender: TObject);
begin
  FController.SetSearchText(FSearchEdit.Text);
  RefreshView;
end;

procedure TMusicMainWindow.StopClick(Sender: TObject; X, Y: Integer;
  Button: TNXMouseButton);
begin
  if Button = mbLeft then
  begin
    FController.Stop;
    RefreshView;
  end;
end;

end.
