# TRMNL CLI

your TRMNL account, from your terminal.

every endpoint in our [API](https://trmnl.com/api-docs) is a command here. 140 of them today, more tomorrow. we don't ship a new version when we add an endpoint, the CLI reads our [OpenAPI spec](https://trmnl.com/api-docs/openapi.json) and figures it out.

**how it works**

1. install TRMNL (`brew install usetrmnl/tap/trmnl`)
2. explore commands (`trmnl --help`)
3. run one (`trmnl list-devices`)

the first command that touches your account opens trmnl.com in your browser. pick what the CLI may do (read, content, devices, delete, profile, apps), click allow, done. no API keys to copy paste.

## examples

```sh
trmnl list-devices -f 'body.data' -o table --rsh-columns id,name,friendly_id
trmnl update-device 123 'name: Kitchen'
trmnl list-plugin-settings
trmnl list-playlist-items
```

changed your mind about access? remove "TRMNL CLI" from [Connected agents](https://trmnl.com/account) any time.

## scripts + CI

no browser? no problem. create an API key under [Account API keys](https://trmnl.com/account), give it only the capabilities it needs, then:

```sh
export TRMNL_API_KEY=trmnl_xxxxx
trmnl list-devices
```

when `TRMNL_API_KEY` is set the CLI uses it and skips the browser entirely.

API keys show up once your account has a [Developer edition](https://shop.trmnl.com/products/developer-edition) device (every BYOD license includes it). browser sign in works for everyone.

## install (other ways)

grab a binary for macOS, Linux or Windows from [releases](https://github.com/usetrmnl/cli/releases), or:

```sh
go install github.com/usetrmnl/cli/cmd/trmnl@latest
```

## good to know

- config + tokens live in `~/.config/trmnl`, the spec cache in `~/.cache/trmnl`
- new endpoint not showing up yet? `trmnl cache clear`
- running your own server? `TRMNL_URL=https://your.server trmnl list-devices`
- powered by [Restish](https://rest.sh), so `trmnl --help` goes deep on output formats, filtering and paging

## looking for something else?

- the full guide, with sign in and API keys: the [TRMNL CLI help article](https://help.trmnl.com/en/articles/17226209-trmnl-cli)
- an API key for scripts and CI: [Account API Keys](https://help.trmnl.com/en/articles/11195228-account-api-keys)
- building a plugin: [trmnlp](https://github.com/usetrmnl/trmnlp) previews your markup locally, and [Private Plugins](https://help.trmnl.com/en/articles/9510536-private-plugins) covers the basics
- letting an AI agent drive: the [MCP Server help article](https://help.trmnl.com/en/articles/17432548-mcp-server) and our [agent skills](https://github.com/usetrmnl/trmnl-agent-skills)

## contributing

this repo is ~80 lines of Go. most "feature requests" for the CLI are really API requests, so if a command is missing or clunky, tell us what you're trying to do and we'll improve the endpoint. everyone wins.

Dependabot keeps Restish fresh. merge its PRs, then cut a release.

## releasing

```sh
bin/release 0.2.0
```

that's it. the script checks you're on a clean, pushed `master`, tags `v0.2.0`, waits for GoReleaser to build every binary + update the [Homebrew cask](https://github.com/usetrmnl/homebrew-tap), then prints the release link. run it with no version to see the latest one. needs [`gh`](https://cli.github.com) logged in.

picking a number: bump the last digit for fixes + Restish updates, the middle one for anything a user would notice.

if a release goes red on the cask step, the `HOMEBREW_TAP_TOKEN` secret expired. make a new [fine-grained token](https://github.com/settings/personal-access-tokens/new) (owner `usetrmnl`, only `usetrmnl/homebrew-tap`, contents read + write), then `gh secret set HOMEBREW_TAP_TOKEN -R usetrmnl/cli` and paste it when asked. then start that version over: `gh release delete v0.2.0 --cleanup-tag -y && bin/release 0.2.0`.
