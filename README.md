# Nexus Lab

Nexus examples and experimental applications live here. Start with the Nexus
capability you want to use; the runtime, compiler and developer tools remain in
their own repositories.

## Examples

| Capability | Examples |
| --- | --- |
| Build applications | [Native Pascal/C/C++ builds](examples/build/native), [Forge orchestration](examples/build/orchestration) |
| Describe packages | [Package catalogs](examples/packages/catalogs), [runtime package loading](examples/packages/runtime-loading) |
| Work with data | [JSON](examples/data/json), [XML](examples/data/xml), [databases](examples/data/database), [schemas](examples/data/schema), [CSV](examples/data/csv), [SQLite from Lua](examples/data/sqlite-lua) |
| Compress and hash | [Compression](examples/data/compression), [hashes](examples/data/hashes), [cryptography](examples/data/cryptography) |
| Build a user interface | [Script editor](examples/gui/script-editor), [virtual tree](examples/gui/virtual-tree), [fpGUI](examples/gui/fpgui), [layout](examples/gui/layout), [progress indicator](examples/gui/progress-indicator) |
| Draw and process images | [Images and barcodes](examples/graphics/images), [JPEG](examples/graphics/jpeg), [AggPas](examples/graphics/aggpas), [vertex canvas](examples/graphics/vertex-canvas), [ANGLE](examples/graphics/angle), [MetalANGLE](examples/graphics/metalangle), [iOS graphics](examples/graphics/metalangle-ios), [SPIR-V](examples/graphics/spirv) |
| Connect applications | [XMPP](examples/network/xmpp), [TLS](examples/network/tls), [sockets](examples/network/sockets), [Lua sockets](examples/network/lua-sockets) |
| Use the runtime | [Collections](examples/runtime/collections), [Object Pascal](examples/runtime/object-pascal), [base utilities](examples/runtime/base), [FFI](examples/runtime/ffi) |
| Use operating-system services | [Processes and IPC](examples/system/processes), [registry](examples/system/registry), [resources](examples/system/resources), [users](examples/system/users) |
| Process text | [Encoding](examples/text/encoding), [regular expressions](examples/text/regular-expressions), [Markdown](examples/text/markdown) |
| Extend Nexus Mobile | [Pascal plugin](examples/mobile/pascal-plugin), [native integration](examples/mobile/native), [Android](examples/mobile/android), [iOS](examples/mobile/ios) |
| Play audio | [OpenAL](examples/audio/openal), [earlier OpenAL](examples/audio/openal-legacy), [mixing](examples/audio/mixing), [MPG123](examples/audio/mpg123), [Vorbis](examples/audio/vorbis) |
| Automate and deploy | [Bots](examples/automation/bots), [installers](examples/deployment/installers), [workspace index](examples/workspace/index) |

## Build

Keep `nexus-lab`, `nexus`, `nexus-fpc` and `nexus-mobile` as sibling checkouts.
Nexus holds `packages/nexus-packages` and `packages/nexus-packages-ext`.
Use NexusFPC and the Nexus tools; the shared native toolchain settings are in
`../nexus/projects/nxbuild/nxbuild.environment.nxscript`.

From this repository, for example:

```sh
../nexus/output/nxbuild-next/x86_64-linux/nxbuild /action=build /project=examples/build/native/Hello.nxproject
../nexus/output/nxbuild-next/x86_64-linux/nxbuild /action=build /project=examples/graphics/images/FCLImageExamples.nxproject
```

`NexusLab.Forge.nxscript` groups the Nexus example projects. Generated outputs
belong under `output/`. Imported third-party demonstrations retain their source,
assets, notices and original project metadata. That metadata does not establish
support for Delphi or Lazarus. Mobile and platform-specific demonstrations still
require their corresponding native SDKs.

`StarExplorer`, `SwarmNX` and `rogue` are the existing application experiments.
Test-only fixtures stay with the tests that own them in the source repositories.
Production build templates stay in `nexus/projects/forge/templates`.

## Attribution

Upstream authors, original locations, revisions, import evidence and license
expressions are recorded in [Nexus ATTRIBUTIONS.md](../nexus/ATTRIBUTIONS.md#centralized-nexus-examples).
Original source headers and local `notices/` directories accompany the examples.
The examples have their individual licenses; this repository does not assign
one license to the complete collection.

## Relocation verification — 2026-10-16

1,926 original example files were moved here, including vendored examples and
the mobile samples' companion applications. All source copies were hash-checked
before removal; the final audit found no missing destinations, old copies or
changed binary assets. Source headers and notices remain with their material.

Thirteen native Linux example projects compiled with NexusFPC SDK `3175c76fba`
and nxbuild. This covered native/mixed builds, JSON, XML, database access, images,
processes, both NexusUI demonstrations, TLS and XMPP. The shared installation
settings were overridden only in ignored verification recipes to select that
matching compiler/RTL and this host's native library paths.

Six console/image smoke checks and the editor's startup/paint/close check passed.
Both schema manifests generated their schema/provider artifacts and all nine
preload files, with matching preload contents. Twelve NexusScript entry points,
including the Lab Forge build, package catalogs, bots, installers, CSV task and
workspace index, compiled and validated.

Targeted tests passed: nxbuild 21, Setup 23, package/editor models 31 and the
structural editor 14 (89 total). The existing owner-paused PackageModel dependency
fixture remains paused. Six Forge checks were corrected to use host-native
absolute executable paths, the compiler's unit filename case and the host's
executable suffix; all six failed before those corrections and passed afterward.
The CSV recipe now uses the shared native NexusFPC settings, its integration test
selects the host-platform path, and the Forge test build group builds its CSV
prerequisite. Forge's two implementation bugs were then fixed: Unix child statuses
are decoded, with signal termination retained as failure, and copied files preserve
source read/write/execute permissions. All four focused regressions failed before
the fixes and passed afterward, including two added Unix regressions for signals
and permissions on overwrite. The Forge CLI built and the full suite now passes
54/54 on this Linux host with NexusFPC SDK `3175c76fba` and nxbuild.

NexusScript remains at 64/75, with Windows path assumptions and an installed SQLite
runtime older than the binding requirement among its failures. That suite is not
reported as a passing relocation check.

The Abbrevia runtime-package recipe and native mobile plugin still require their
matching package/engine SDKs. Windows, Apple, Android and the imported native vendor
build matrices were not built here. Existing platform project metadata was
preserved and its source references updated; that is not a platform build claim.
No live network service or bot was started. Verification output stays outside
source control; no evidence archive is retained with the examples.
