# TRMNL CLI

this repo contains the logic for our CLI, powered by [Terminalwire](https://terminalwire.com/).

**how it works**

1. install TRMNL (`curl -LSs https://trmnl.terminalwire.sh | bash`)
2. log in (`trmnl login`)
3. explore commands (`trmnl`)

## contributing

code inside `lib/` is not intended to run independently of the core TRMNL web server. it does, however, showcase design choices and hierarchy of available CRUD behaviors.

we are open to feedback and contributions to the following areas:

- attributes and formatting via `list` style commands, ex `trmnl plugins ls`
- CLI-only "go" actions that commit write operations, ex `trmnl go shopping_list <item>`
- desired plugin management functionality; we already support connection counts, what else?
