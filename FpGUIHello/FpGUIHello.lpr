program FpGUIHello;

{$mode objfpc}{$H+}

uses
  Classes,
  fpg_base,
  fpg_main,
  fpg_form,
  fpg_button;

type
  TMainForm = class(TfpgForm)
  private
    FCloseButton: TfpgButton;
    procedure CloseButtonClick(Sender: TObject);
  public
    procedure AfterCreate; override;
  end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.AfterCreate;
begin
  inherited AfterCreate;
  Width := 420;
  Height := 240;
  WindowTitle := 'Nexus Lab fpGUI Sample';

  FCloseButton := TfpgButton.Create(Self);
  FCloseButton.Text := 'fpGUI is running';
  FCloseButton.Hint := 'Click to close';
  FCloseButton.ShowHint := True;
  FCloseButton.Align := alClient;
  FCloseButton.OnClick := @CloseButtonClick;
end;

procedure Run;
var
  lMainForm: TMainForm;
begin
  fpgApplication.Initialize;
  lMainForm := TMainForm.Create(nil);
  try
    lMainForm.Show;
    fpgApplication.Run;
  finally
    lMainForm.Free;
  end;
end;

begin
  Run;
end.
