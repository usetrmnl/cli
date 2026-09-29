# TRMNL CLI

The [TRMNL API](https://trmnl.com/api-docs) as a command line. Built on [Restish](https://rest.sh).

The commands come from the OpenAPI document TRMNL publishes at `https://trmnl.com/api-docs/openapi.json`,
so a new API endpoint shows up here without a new release.

## Install

Download a binary from [Releases](https://github.com/usetrmnl/cli/releases), or:

```sh
go install github.com/usetrmnl/cli/cmd/trmnl@latest
```

## Use

```sh
trmnl --help                     # every command, grouped like the API docs
trmnl list-devices               # opens your browser to sign in the first time
trmnl list-devices -f 'body.data' -o table --rsh-columns id,name
trmnl update-device 123 'name: Kitchen'
```

The first command that needs your account opens trmnl.com in your browser. You choose what the CLI may
do (read, content, devices, delete, profile, apps), the same way you connect an MCP agent. Tokens refresh
on their own. Remove the connection from your account page at any time.

Config and tokens live in `~/.config/trmnl`, the spec cache in `~/.cache/trmnl`. Run `trmnl cache clear`
to pick up new commands straight away.

Point it at another server with `TRMNL_URL`, for example `TRMNL_URL=http://localhost:3000 trmnl list-devices`.

## Release

Push a `v*` tag. GoReleaser builds the binaries and attaches them to the GitHub release.

To take a newer Restish: `go get github.com/rest-sh/restish/v2@latest && go mod tidy`.

## Looking for something else?

- Build and preview plugins locally: [trmnlp](https://github.com/usetrmnl/trmnlp)
- Let an AI agent use your account: the TRMNL MCP server, see [trmnl-agent-skills](https://github.com/usetrmnl/trmnl-agent-skills)
