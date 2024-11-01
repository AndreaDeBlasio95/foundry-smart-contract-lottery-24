## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Tests!

1. Write deploy scripts
   1. Note, these will not work on zkSync
2. Write tests
   1. Local chain
   2. Forked testnet
   3. Forked mainnet

VRF Supported Networks
https://docs.chain.link/vrf/v2-5/supported-networks

forge test --match-test <testFunctionName>

for events we need to use

```
function expectEmit(
bool checkTopic1,
bool checkTopic2,
bool checkTopic3,
bool checkData
) external;
```

Set the block.timestamp to 100
vm.warp(100);

Set the block.number to 100
vm.roll(100);

Transaction HEX
cast sig "methodNameHere()"
output: 0x....

source .env
cast wallet import account-name --interactive

forge coverage
forge coverage --report debug
forge coverage --report debug > coverage.txt
