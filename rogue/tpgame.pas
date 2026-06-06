unit tpGame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLocation = record
    X: integer;
    Y: integer;
  end;
  PLocation = ^TLocation;
  function Location(AX, AY: integer): TLocation;

type
  TLocationDouble = record
    X: double;
    Y: double;
  end;

type
  TTileSize = record
    W: integer;
    H: integer;
  end;

  TGameRect = record
    X: integer;
    Y: integer;
    W: integer;
    H: integer;
  end;

  TMoveDirection = (
    mdNone,
    mdLeft,
    mdRight,
    mdUp,
    mdDown
  );

implementation

function Location(AX, AY: integer): TLocation;
begin
  Result.X := AX;
  Result.Y := AY;
end;

end.

