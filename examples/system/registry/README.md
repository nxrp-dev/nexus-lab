# Registry examples

These examples consume the relocated Nexus registry package. The Linux native
recipe builds both Unicode demonstrations and the two runtime/base registry
examples, using a local `reg.xml` instead of application configuration storage.

From Nexus Lab:

```sh
../nexus/output/nxbuild-next/x86_64-linux/nxbuild /action=build /project=examples/system/registry/RegistryExamples.nxproject
```

Nexus Lab's Forge group includes this as `Examples:Registry`. To check all four
executables, build Nexus `packages/nexus-packages/fcl-registry/tests/FCLRegistryTests.nxproject`
and run its `FCLRegistryExampleTests` with this recipe's output directory as its
argument. Each demonstration runs in a separate generated working directory.

`remotereg.pas` needs Windows, JWA bindings and a remote registry service; it is
retained separately from the Linux checks. Windows native registry execution is
not covered by the portable XML backend results.

See [Nexus attributions](../../../../nexus/ATTRIBUTIONS.md#fcl-registry) for the
runtime and [centralized examples record](../../../../nexus/ATTRIBUTIONS.md#centralized-nexus-examples)
for the imported demonstrations and preserved notices.
