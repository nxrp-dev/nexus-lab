program TRegExprRoutins;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  TRegExprRoutinesMain in 'TRegExprRoutinesMain.pas' {fmTRegExprRoutines},
  regexpr in '../../../../../nexus/packages/nexus-packages-ext/regexpr/external/tregexpr/Src/regexpr.pas';

{.$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmTRegExprRoutines, fmTRegExprRoutines);
  Application.Run;
end.
