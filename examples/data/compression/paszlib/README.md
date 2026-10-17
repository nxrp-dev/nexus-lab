# Nexus Pascal compression examples

These examples use the authoritative NexusFPC `packages/paszlib/src` tree.
The duplicate `paszlib-external` folder was removed after comparing its source
and notices. Original author/license notices remain with these examples.

`PasZLibExamples.nxproject` builds the programs with NexusFPC through nxbuild.
The output is Nexus `output/PasZLibExamples/<native-target>`.

- `fpzipper` and `fpunzipper` demonstrate the TZipper/TUnzipper APIs.
- `minizip`, `miniunz` and `minigzip` demonstrate the low-level ZIP/gzip APIs.
- `example`, `example2` and `testgzstream` demonstrate memory/stream compression.
- `extractodt` demonstrates extracting a ZIP member from an OpenDocument file.
- `testsingle` demonstrates extracting one member from the retained test ZIP.

Run examples in a disposable working directory; several write local files or
read command-line filenames. `example` and the mini tools retain interactive
prompts from their original demonstrations.

See [central attribution](../../../../../nexus/ATTRIBUTIONS.md#paszlib) and the
[official reconciliation record](../../../../../nexus-fpc/packages/paszlib/CONSOLIDATION.md).
