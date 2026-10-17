# Nexus JPEG examples

These examples demonstrate JPEG encoding, decoding, transcoding and metadata
through Nexus's PasJPEG package. Runtime source is owned by
`nexus/packages/nexus-packages/graphics/pasjpeg`, with review and attribution
linked there. This software is based in part on the work of the Independent
JPEG Group. Original source notices, sample assets and distribution notices
are preserved here; canonical provenance is in
[Nexus attributions](../../../../nexus/ATTRIBUTIONS.md#pasjpeg).

Build `PasJPEGExamples.nxproject` with Nexus nxbuild. It builds five portable
programs: `cjpeg`, `djpeg`, `jpegtran`, `demo` and `rdjpgcom`. Generated files go
under Nexus `output/PasJPEGExamples/<native-target>`. Use a scratch directory
when running the programs; the original `demo` writes `PasJpeg.jpg` and
`PasJpeg.raw` in the current directory.

Examples, with the executables on the command path:

```sh
cjpeg input.bmp encoded.jpg
djpeg -bmp encoded.jpg decoded.bmp
jpegtran encoded.jpg transcoded.jpg
jpegtran -progressive encoded.jpg progressive.jpg
rdjpgcom encoded.jpg
demo encoded.jpg
```

The command-line stream variables were corrected on 2026-10-17 to match the
codec's actual TStream interface, and the sample-factor declaration typo was
repaired. These are native FPC examples. The original `testproj.dpr`, `test1`
form and associated assets are retained historical VCL material and are not
part of the supported build; Delphi validation is not required by Nexus.
