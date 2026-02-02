unit obRecordCache;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Contnrs;

type
  generic TRecordCache<TRecord> = class
  public type
    PRecord = ^TRecord;

    PEntry = ^TEntry;
    TEntry = record
      RefCount: Integer;
      Key: ShortString;
      Value: TRecord;
    end;

    TAfterCreateEvent = procedure(const AKey: ShortString; var AValue: TRecord) of object;
    TBeforeFreeEvent  = procedure(const AKey: ShortString; var AValue: TRecord) of object;

  private
    FMap: TFPHashList;
    FOnAfterCreate: TAfterCreateEvent;
    FOnBeforeFree:  TBeforeFreeEvent;

    function FindIndexByKey(const AKey: ShortString): Integer; inline;

  public
    constructor Create;
    destructor Destroy; override;

    // Acquire returns the entry handle. ACreated=True if it was new.
    function Acquire(const AKey: ShortString; out ACreated: Boolean): PEntry;
    function Acquire(const AKey: ShortString): PEntry;

    // Lookup without refcount changes
    function Find(const AKey: ShortString): PEntry;

    // Refcount ops on the entry handle
    procedure Retain(AHandle: PEntry);
    procedure Release(AHandle: PEntry);

    // Typed access to the stored record
    class function Data(AHandle: PEntry): PRecord; static; inline;

    function Count: Integer; inline;

    property OnAfterCreate: TAfterCreateEvent read FOnAfterCreate write FOnAfterCreate;
    property OnBeforeFree: TBeforeFreeEvent  read FOnBeforeFree  write FOnBeforeFree;
  end;

implementation

constructor TRecordCache.Create;
begin
  inherited Create;
  FMap := TFPHashList.Create;
end;

destructor TRecordCache.Destroy;
var
  lIdx: Integer;
  lEntry: PEntry;
begin
  for lIdx := FMap.Count - 1 downto 0 do
  begin
    lEntry := PEntry(FMap.Items[lIdx]);

    if Assigned(FOnBeforeFree) then
      FOnBeforeFree(lEntry^.Key, lEntry^.Value);

    Dispose(lEntry);
    FMap.Delete(lIdx);
  end;

  FreeAndNil(FMap);
  inherited Destroy;
end;

function TRecordCache.Count: Integer;
begin
  Result := FMap.Count;
end;

function TRecordCache.FindIndexByKey(const AKey: ShortString): Integer;
begin
  Result := FMap.FindIndexOf(AKey);
end;

function TRecordCache.Find(const AKey: ShortString): PEntry;
var
  lIdx: Integer;
begin
  lIdx := FindIndexByKey(AKey);
  if lIdx < 0 then
    Exit(nil);
  Result := PEntry(FMap.Items[lIdx]);
end;

function TRecordCache.Acquire(const AKey: ShortString; out ACreated: Boolean): PEntry;
var
  lIdx: Integer;
  lEntry: PEntry;
begin
  lIdx := FindIndexByKey(AKey);
  if lIdx >= 0 then
  begin
    lEntry := PEntry(FMap.Items[lIdx]);
    Inc(lEntry^.RefCount);
    ACreated := False;
    Exit(lEntry);
  end;

  New(lEntry);
  lEntry^.RefCount := 1;
  lEntry^.Key := AKey;
  lEntry^.Value := Default(TRecord);

  FMap.Add(AKey, lEntry);

  if Assigned(FOnAfterCreate) then
    FOnAfterCreate(AKey, lEntry^.Value);

  ACreated := True;
  Result := lEntry;
end;

function TRecordCache.Acquire(const AKey: ShortString): PEntry;
var
  lCreated: Boolean;
begin
  Result := Acquire(AKey, lCreated);
end;

procedure TRecordCache.Retain(AHandle: PEntry);
begin
  if AHandle = nil then
    Exit;
  Inc(AHandle^.RefCount);
end;

procedure TRecordCache.Release(AHandle: PEntry);
var
  lIdx: Integer;
  lKey: ShortString;
begin
  if AHandle = nil then
    Exit;

  Dec(AHandle^.RefCount);
  if AHandle^.RefCount > 0 then
    Exit;

  lKey := AHandle^.Key;

  lIdx := FindIndexByKey(lKey);
  if lIdx >= 0 then
    FMap.Delete(lIdx);

  if Assigned(FOnBeforeFree) then
    FOnBeforeFree(lKey, AHandle^.Value);

  Dispose(AHandle);
end;

class function TRecordCache.Data(AHandle: PEntry): PRecord;
begin
  if AHandle = nil then
    Exit(nil);
  Result := @AHandle^.Value;
end;

end.

