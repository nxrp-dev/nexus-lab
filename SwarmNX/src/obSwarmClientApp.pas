unit obSwarmClientApp;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  fpg_main,
  fpg_stylemanager,
  obSwarmMainWindow,
  obSwarmTorrentController;

type
  TSwarmClientApp = class
  private
    FController: TSwarmTorrentController;
    FMainWindow: TSwarmMainWindow;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run;
  end;

implementation

constructor TSwarmClientApp.Create;
begin
  inherited Create;
  FController := TSwarmTorrentController.Create;
end;

destructor TSwarmClientApp.Destroy;
begin
  FMainWindow.Free;
  FController.Free;
  inherited Destroy;
end;

procedure TSwarmClientApp.Run;
begin
  fpgApplication.Initialize;
  fpgStyleManager.SetStyle('Plastic Dark');
  fpgStyle := fpgStyleManager.Style;
  fpgApplication.AppTitle := 'SwarmNX';
  FMainWindow := TSwarmMainWindow.Create(nil, FController);
  FMainWindow.Build;
  FMainWindow.Show;
  fpgApplication.Run;
end;

end.
