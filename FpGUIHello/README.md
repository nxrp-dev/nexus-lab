# Nexus Lab fpGUI Sample

This is a minimal fpGUI application built by Free Pascal through PasBuild. It
does not contain a Lazarus project and does not require `lazbuild`.

The project expects sibling checkouts with this layout:

```text
gitdev/
  nexus/
    lib/fpgui/
    lib/pasbuild/
  nexus-lab/
    FpGUIHello/
```

Bootstrap PasBuild once if `pasbuild` is not already available, following
`nexus/lib/pasbuild/BOOTSTRAP.txt`.

Build on Windows from this directory:

```text
../../nexus/lib/pasbuild/target/PasBuild.exe compile -p windows
```

Build on Linux or another X11 Unix target:

```text
../../nexus/lib/pasbuild/target/PasBuild compile -p unix
```

The executable is written to `target/` and intermediate units to
`target/units/`.

