unit obContainers;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  generic TForEachProc<T> = procedure(const AItem: T) of object;

  generic TGenericList<T> = class(specialize TFPGList<T>)
  public
  type
    procedure ForEach(AProc: specialize TForEachProc<T>);
    function Add(AClass: TClass): T; overload;
  end;

implementation

function TGenericList.Add(AClass: TClass): T;
begin
  if not AClass.InheritsFrom(T) then
    raise Exception.Create('Invalid class type for this list.');

  Result := T(AClass.Create);
  inherited Add(Result);
end;

procedure TGenericList.ForEach(AProc: specialize TForEachProc<T>);
var
  lIndex: Integer;
begin
  for lIndex := 0 to Count - 1 do
    AProc(Items[lIndex]);
end;

end.

