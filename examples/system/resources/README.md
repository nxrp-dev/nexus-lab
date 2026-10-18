# Nexus executable resource examples

`restool.lpr` lists and extracts executable resources using the FCL Res package
owned by Nexus Packages. Build from the Lab root:

```sh
../nexus/output/nxbuild-next/x86_64-linux/nxbuild /action=build /project=examples/system/resources/ResourceExamples.nxproject
```

The Forge Examples group registers this as `Resources`. The imported
`program.res` is an example input. `windlg` is a Windows-only dialog demonstration
and does not depend on fcl-res at runtime.

Original notices remain under `notices`. See
[Nexus ATTRIBUTIONS.md](../../../../nexus/ATTRIBUTIONS.md#fcl-res) for attribution
and the package's `CODE_REVIEW.md` for reader regression results.
