# StarExplorer

StarExplorer is a Nexus2D game experiment and a working example of a Pascal native plugin using the Nexus Lua/Solar2D packages. Projects belong in nexus-lab; the shared plugin bridge remains in `nexus/packages/nexus-packages`.

The main menu contains the preserved plugin proof: load `plugin.sample`, create an object, and verify that Pascal Add and Greeting links return the expected values. See [plugin-proof](plugin-proof/README.md) for the original successful runtime screenshot and build prerequisites.

## Build and run the Win64 proof

```powershell
.\plugin-proof\Build-Proof.ps1 -OutputRoot C:\StarExplorerProof
```

The script builds from shared package source, copies this game into a new output directory, and stages its two native DLLs. It prints the staged main.lua and simulator paths. Open that main.lua in the Win64 Nexus2D simulator; the menu should display `WIN64 PASCAL PLUGIN: PASS`.

`-PackageRoot`, `-Nexus2DRoot`, `-CompilerBin`, and `-GnuDllToolBin` override the local dependency paths. The recorded build uses native Win64 FPC 3.2.2, GNU binutils and LLVM import-library/image tools. Generated DLLs are not stored as project source.

## Cleanup and preservation

The October 10, 2026 import retains 95 game files (about 39 MB) from the tested proof, excluding 585 unused files (about 189 MB): unused asset collections, an unrelated BalloonTap workspace, the unreachable asteroid-game scene, an unused scene template and two unused Lua helpers. Dependency tracing includes menu scene targets and literal resources in the reachable Lua modules. Entire NPC/cutscene data folders, platform inputs and asset notices were retained.

The [cleanup manifest](plugin-proof/evidence/cleanup-manifest.json) lists every retained/excluded file and hashes each exclusion. The complete original proof is also preserved in `C:\backup\Nexus2DPluginProof-20261010.zip`; archive hashes and runtime/build evidence are under `plugin-proof/evidence`.

The game is an experiment. The historical plugin pass verifies loading, object creation and two links; it does not certify every game scene or the broader bridge event/lifetime behavior. Mobile resources were retained because build.settings names them, but the native plugin proof is Win64 only.
