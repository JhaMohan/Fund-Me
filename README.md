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

### To Debug specific test function

```shell
$ forge test -w function_name -vvv
```

### To run on forked network

```shell
$ forge test --match-test testPriceFeedVersionIsAccurate -vvvv --fork-url $SEPOLIA_URL
// sepolia url can take from alchemy
```

### Chisel to run solidity in terminal

```shell
$ chisel
$ uint256 index =1;
$ index
cmd + k // to clear terminal
```

### To calculate gas cost by function

```shell
$ forge snapshot --match-test  function_name
```

### To get storage slot layout

```shell
$ forge inspect contract_name storageLayout
forge inspect FundMe storageLayout
```

### To get value from storage slot layout

```shell
$ cast storage contract_address slota_no
```

1. create readme
2. push to github
