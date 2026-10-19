(*
  Copyright (c) 2026 Kevin Collins.
  SPDX-License-Identifier: MPL-2.0-no-copyleft-exception
*)

library plugin_sample;

{$mode objfpc}{$H+}

uses
  Lua51,
  Solar2D.Plugin,
  Sample.Plugin;

function PluginOpen(L: Plua_State): Integer; cdecl;
begin
  Result := TSolarPlugin.OpenLibrary(
    L,
    'sample',
    'com.nexus',
    2,
    0,
    TSamplePlugin
  );
end;

exports
  PluginOpen name 'luaopen_plugin_sample';

begin
end.
