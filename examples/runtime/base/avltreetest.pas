program AvlTreeTest;
{
    This file is a demo of the Free Component Library (FCL)
    Copyright (c) 2009 by Marco van de Voort.

    A demo/test adapted to use the shared Generics.Collections AVL map.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright. Alternately you may also
    use this file under a BSD license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}{$H+}

uses Classes, SysUtils, Generics.Collections, Generics.Defaults;

const
  cNumberOfValues = 10000;

var
  lComparisons: SizeInt = 0;

function CompareNames(const AFirst, ASecond: string): Integer;
begin
  Inc(lComparisons);
  Result := CompareStr(ASecond, AFirst);
end;

var
  lTree: specialize TAVLTreeMap<string, Integer>;
  lSeen: TBits;
  lIndex, lValue: Integer;
  lName: string;
  lBefore, lFindComparisons, lInsertComparisons: SizeInt;
  lIsNew: Boolean;
begin
  Randomize;
  lFindComparisons := 0;
  lInsertComparisons := 0;
  lTree := specialize TAVLTreeMap<string, Integer>.Create(
    specialize TComparer<string>.Construct(@CompareNames));
  try
    lSeen := TBits.Create(cNumberOfValues);
    try
      for lIndex := 0 to cNumberOfValues - 1 do
      begin
        lValue := Random(cNumberOfValues);
        lName := IntToStr(lValue);
        lBefore := lComparisons;
        lIsNew := not lTree.ContainsKey(lName);
        Inc(lFindComparisons, lComparisons - lBefore);
        if lIsNew then
        begin
          lBefore := lComparisons;
          lTree.Add(lName, lValue);
          Inc(lInsertComparisons, lComparisons - lBefore);
          lSeen[lValue] := True;
        end;
      end;
      WriteLn(lTree.Count, ' unique nodes in the tree');
      WriteLn('Insert comparisons: ', lInsertComparisons);
      WriteLn('Find comparisons: ', lFindComparisons);
      lBefore := lComparisons;
      for lValue in lTree.Values do
        if not lSeen[lValue] then
          raise Exception.CreateFmt('Unexpected value: %d', [lValue]);
      if lComparisons <> lBefore then
        raise Exception.Create('Iteration must not compare keys');
      lTree.ConsistencyCheck;
    finally
      lSeen.Free;
    end;
  finally
    lTree.Free;
  end;
end.
