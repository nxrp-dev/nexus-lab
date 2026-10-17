# Nexus sockets and resolution

Nexus applications use Synapse, with the Nexus OpenSSL adapter for TLS.
`NexusSynapseExamples.nxproject` builds these examples through Nexus nxbuild.
Build output is in Nexus `output/nexus-lab-synapse/<native-target>`.

- `isocksvr` starts one bounded TCP echo session; `isockcli` exchanges three
  messages and closes it. Both accept optional host and port arguments and
  default to `127.0.0.1:4100`. IPv6 works with `::1`.
- `testdns` resolves a hostname (default `localhost`), `-r address` performs a
  reverse lookup, and `-p service` resolves a TCP service name to a port.
- `testverify host port CA-file` verifies a TLS peer using the Nexus adapter.
  It requires an explicit endpoint and CA file; it does not contact a default
  public service.
- `testuri` retains the independent URI parser demonstration.

The FCL socket/component resolver and database-only demonstrations were retired
with FCL Net. Unix-domain examples were removed because Nexus Synapse does not
currently implement that optional capability. Duplicate runtime/base socket
examples were removed; TCP examples live here.

Original author notices remain in the adapted sources and `notices/`.
See [central attribution](../../../../nexus/ATTRIBUTIONS.md#fcl-net).
