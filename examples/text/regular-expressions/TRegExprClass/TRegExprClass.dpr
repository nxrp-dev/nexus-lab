program TRegExprClass;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  TRegExprClassMain in 'TRegExprClassMain.pas' {fmTRegExprClassMain},
  regexpr in '../../../../../nexus/packages/nexus-packages-ext/regexpr/external/tregexpr/Src/regexpr.pas';

{.$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmTRegExprClassMain, fmTRegExprClassMain);
  Application.Run;
end.
