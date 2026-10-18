// Copyright (c) 2026 Kevin Collins.
// SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
// Adapted from the Free Pascal X11 package's fpxkbtest demonstration.
program KeyboardMap;
{$mode objfpc}{$H+}
uses SysUtils, x, xlib, xkb, xkblib;
var
  lDisplay: PDisplay;
  lMap: PXkbDescPtr;
  lKey, lGroup, lLevel, lGroups, lLevels: Integer;
begin
  lDisplay := XOpenDisplay(nil);
  if lDisplay = nil then
  begin
    WriteLn(StdErr, 'Cannot open the X display.');
    Halt(1);
  end;
  try
    lMap := XkbGetMap(lDisplay, XkbAllClientInfoMask, XkbUseCoreKbd);
    if lMap = nil then raise Exception.Create('Cannot read the keyboard map.');
    try
      for lKey := lMap^.min_key_code to lMap^.max_key_code do
      begin
        lGroups := XkbKeyNumGroups(lMap, lKey);
        for lGroup := 0 to lGroups - 1 do
        begin
          lLevels := XkbKeyKeyType(lMap, lKey, lGroup)^.num_levels;
          for lLevel := 0 to lLevels - 1 do
            WriteLn('Key=', lKey, ' Group=', lGroup, ' Level=', lLevel,
              ' Keysym=', IntToHex(XkbKeycodeToKeysym(lDisplay, lKey,
                lGroup, lLevel), 8));
        end;
      end;
    finally XkbFreeKeyboard(lMap, 0, True); end;
  finally XCloseDisplay(lDisplay); end;
end.
