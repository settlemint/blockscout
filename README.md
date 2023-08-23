<h1 align="center">BlockScout</h1>
<p align="center">Blockchain Explorer for inspecting and analyzing EVM Chains.</p>
<div align="center">

[![Blockscout](https://github.com/blockscout/blockscout/workflows/Blockscout/badge.svg?branch=master)](https://github.com/blockscout/blockscout/actions)
[![](https://dcbadge.vercel.app/api/server/blockscout?style=flat)](https://discord.gg/blockscout)

</div>


BlockScout provides a comprehensive, easy-to-use interface for users to view, confirm, and inspect transactions on EVM (Ethereum Virtual Machine) blockchains. This includes the POA Network, Gnosis Chain, Ethereum Classic and other **Ethereum testnets, private networks and sidechains**.

See our [project documentation](https://docs.blockscout.com/) for detailed information and setup instructions.

For questions, comments and feature requests see the [discussions section](https://github.com/blockscout/blockscout/discussions).

## About BlockScout

BlockScout is an Elixir application that allows users to search transactions, view accounts and balances, and verify smart contracts on the Ethereum network including all forks and sidechains.

Currently available full-featured block explorers (Etherscan, Etherchain, Blockchair) are closed systems which are not independently verifiable.  As Ethereum sidechains continue to proliferate in both private and public settings, transparent, open-source tools are needed to analyze and validate transactions.

## Supported Projects

BlockScout supports a number of projects. Hosted instances include POA Network, Gnosis Chain, Ethereum Classic, Sokol & Kovan testnets, and other EVM chains.

- [List of hosted mainnets, testnets, and additional chains using BlockScout](https://docs.blockscout.com/for-projects/supported-projects)
- [Hosted instance versions](https://docs.blockscout.com/about/use-cases/hosted-blockscout)

## Getting Started

See the [project documentation](https://docs.blockscout.com/) for instructions:

- [Requirements](https://docs.blockscout.com/for-developers/information-and-settings/requirements)
- [Ansible deployment](https://docs.blockscout.com/for-developers/ansible-deployment)
- [Manual deployment](https://docs.blockscout.com/for-developers/manual-deployment)
- [ENV variables](https://docs.blockscout.com/for-developers/information-and-settings/env-variables)
- [Configuration options](https://docs.blockscout.com/for-developers/configuration-options)

## Build and Push Docker Image
```
docker buildx build --build-arg CACHE_EXCHANGE_RATES_PERIOD= --build-arg API_V1_READ_METHODS_DISABLED=false --build-arg API_PATH=/ --build-arg NETWORK_PATH=/ --build-arg LOGO=/images/blockscout_logo.svg --build-arg DISABLE_WEBAPP=false --build-arg API_V1_WRITE_METHODS_DISABLED=false --build-arg CACHE_TOTAL_GAS_USAGE_COUNTER_ENABLED= --build-arg WOBSERVER_ENABLED=false --build-arg ADMIN_PANEL_ENABLED=true --build-arg CACHE_ADDRESS_WITH_BALANCES_UPDATE_INTERVAL= --build-arg DISABLE_BRIDGE_MARKET_CAP_UPDATER=true --build-arg DECODE_NOT_A_CONTRACT_CALLS=false --build-arg SOCKET_ROOT=/ --build-arg CHAIN_ID= --build-arg JSON_RPC= --build-arg COIN_NAME=Native_Token --build-arg COIN=NT --build-arg SUBNETWORK= --build-arg DISABLE_EXCHANGE_RATES=true --build-arg SECRET_KEY_BASE=RMgI4C1HSkxsEjdhtGMfwAHfyT6CKWXOgzCboJflfSm4jeAlic52io05KB6mqzc5 --build-arg ENABLE_TXS_STATS=true --build-arg SHOW_TXS_CHART=true --build-arg MIXPANEL_URL= --build-arg MIXPANEL_TOKEN= --build-arg AMPLITUDE_URL= --build-arg AMPLITUDE_API_KEY= --build-arg BLOCKSCOUT_VERSION=v5.2.2-beta --build-arg RELEASE_VERSION=5.2.2 --build-arg LOGO=/explorer/images/blockscout_logo.svg --file ./docker/Dockerfile --platform linux/amd64 --tag ghcr.io/settlemint/blockscout:latest --tag ghcr.io/settlemint/blockscout:v5.2.2-beta-APPEND_GIT_SHA --push .
```

## Acknowledgements

We would like to thank the [EthPrize foundation](http://ethprize.io/) for their funding support.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution and pull request protocol. We expect contributors to follow our [code of conduct](CODE_OF_CONDUCT.md) when submitting code or comments.

## License

[![License: GPL v3.0](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
