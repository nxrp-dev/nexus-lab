program Text2HTML;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Text2HTMLMain in 'Text2HTMLMain.pas' {fmText2HTMLMain},
  HyperLinksDecorator in '../../../../../nexus/packages/nexus-packages-ext/regexpr/external/tregexpr/Src/HyperLinksDecorator.pas',
  regexpr in '../../../../../nexus/packages/nexus-packages-ext/regexpr/external/tregexpr/src/regexpr.pas';

{.$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmText2HTMLMain, fmText2HTMLMain);
  Application.Run;
end.
