# StarExplorer Win64 plugin proof

This preserves the successful Nexus2D Pascal plugin test performed on October 2, 2026. StarExplorer belongs to nexus-lab; the shared bridge source remains in the `lua` and `solar2d` packages in nexus-packages. The game integration and successful runtime evidence were recovered on October 10 from `C:\gitdev\nexus\output\Solar2DPluginProof`.

## What passed

The Win64 Nexus2D simulator loaded `plugin.sample`, created a Pascal object with `sample.new()`, called `Add(20, 22)` and received `42`, and called `Greeting("StarExplorer")` and received `Hello, StarExplorer from Pascal`. See [the original successful screenshot](evidence/win64-plugin-pass.png).

This runtime proof covers module loading, object creation and those two published links. It does not establish that every property, event, retained-link lifetime case or target ABI in the broader sample has passed. The existing bridge review points remain applicable.

## Preserved files

- The parent project contains the three changed game files (`main.lua`, `build.settings`, `scenes/menu.lua`), copied exactly from the working proof, alongside the retained game source/assets. See the parent README and cleanup manifest for the removal of unused files.
- `plugin_sample.lpr`: the tested entry point, including its Lua and native-proxy link directives.
- `imports/`: the Lua 5.1 and native-proxy export definitions used to generate import libraries.
- `evidence/`: the successful screenshot, file hashes, complete archive metadata, and the recovery rebuild's compile/image reports.
- `Build-Proof.ps1`: a reconstructed build and staging recipe, using package source rather than the old output's object files or import libraries.

The complete original proof, including game assets, working DLLs, old build artifacts and diagnostic records, is preserved separately at `C:\backup\Nexus2DPluginProof-20261010.zip`. All 717 archive entries passed a ZIP CRC check. Its SHA-256 and the individual recovered artifact hashes are recorded in [recovery-manifest.json](evidence/recovery-manifest.json).

The original game at `C:\newdev\StarExplorer` was not modified. No simulator source or binary changes were required for this proof.

## Rebuild and run

Run from this directory:

```powershell
.\Build-Proof.ps1 -OutputRoot C:\plugin-proof
```

Use a new or empty output directory without spaces. The script copies the parent StarExplorer project, leaving source files untouched. Paths can be supplied with `-GameSource`, `-PackageRoot`, `-Nexus2DRoot`, `-CompilerBin`, and `-GnuDllToolBin`. To rebuild from the archive, extract it and point `-GameSource` at its `StarExplorer` directory.

The recovered recipe requires native Win64 FPC 3.2.2 and its GNU assembler/linker, GNU `dlltool.exe` and its supporting DLLs, and LLVM `llvm-dlltool.exe`/`llvm-readobj.exe` on PATH. Default paths identify the toolchains used on this machine. This records the historically tested toolchain; it does not validate the current NexusFPC compiler.

The host must provide the Win64 Lua 5.1 `lua.dll` and `Resources\CoronaLabs.Corona.Native.dll`. The plugin imports the native proxy, not `Corona Simulator.exe`; the earlier direct-executable import attempt crashed. The script regenerates both import libraries, forces compilation of the bridge/sample, checks the DLL's AMD64 machine type, imports and `luaopen_plugin_sample` export, and stages the plugin and proxy in the copied game's `plugin` directory.

Open the staged `StarExplorer\main.lua` using `platform\windows\Bin\Corona\Corona Simulator.exe`. The menu should display `WIN64 PASCAL PLUGIN: PASS`, the result `42`, and the StarExplorer greeting.

On October 10, 2026, this recipe successfully rebuilt and staged the plugin from the current package source and passed the image checks. The retained screenshot documents the October 2 runtime test; the recovery rebuild was not rerun through the GUI.
