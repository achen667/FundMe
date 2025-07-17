---

# FundMe — Chainlink ETH/USD Funding Contract

This project implements a simple Ethereum smart contract called **FundMe**, which allows users to fund the contract in ETH — but only if their contribution exceeds a minimum USD value (determined via Chainlink price feeds). It includes scripts and a Makefile for deployment, testing, and interaction using Foundry and the `cast` CLI.

---

## Features

* Accepts ETH funding only if it exceeds \$5 (using Chainlink ETH/USD oracle)
* Keeps track of who funded and how much
* Owner-only withdrawal mechanism
* Tested using Foundry's Forge framework
* Easily deployable to local or Sepolia testnet with one command
* Includes Makefile automation for build, test, deploy, fund, withdraw

---

## Project Structure

```
.
├── contracts/
│   └── FundMe.sol              # Main contract
│   └── PriceConverter.sol      # Library to convert ETH → USD
├── script/
│   └── DeployFundMe.s.sol      # Foundry deploy script
├── test/
│   └── FundMe.t.sol            # Foundry tests (optional)
├── Makefile                    # Project automation
├── foundry.toml                # Foundry config
└── .env                        # Secrets & RPC URLs (not committed)
```

---

## Setup

### 1. Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Clone & Install Dependencies

```bash
git clone <your-repo-url>
cd <your-project>
make install
```

### 3. Create a `.env` file

```env
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_KEY
ACCOUNT=myDevKey
```

---

## Makefile Commands

| Command                                        | Description                            |
| ---------------------------------------------- | -------------------------------------- |
| `make build`                                   | Compile contracts with Forge           |
| `make test`                                    | Run all tests                          |
| `make deploy`                                  | Deploy to local anvil node             |
| `make deploy-sepolia ARGS="--network sepolia"` | Deploy to Sepolia & verify             |
| `make fund`                                    | Call `fund()` with 0.002 ETH           |
| `make withdraw`                                | Owner withdraws all funds              |
| `make anvil`                                   | Start local testnet with test mnemonic |
| `make clean`                                   | Clean artifacts and cache              |
| `make update`                                  | Update dependencies                    |
| `make format`                                  | Auto-format all Solidity files         |

---

## Deploying

### Deploy to Local Anvil (default):

```bash
make anvil  # in a separate terminal
make deploy
```

### Deploy to Sepolia:

```bash
make deploy-sepolia ARGS="--network sepolia"
```

Make sure `.env` has all required variables.

---

## Interacting with the Contract

After deployment, update the `CONTRACT_ADDRESS` variable in the Makefile.

### Fund Contract

```bash
make fund
```

### Withdraw Funds (owner only)

```bash
make withdraw
```

---

## Security Notes

* The contract enforces funding with a minimum USD value using a Chainlink oracle.
* Only the contract owner (set at deployment) can withdraw funds.
* `call` is used for withdrawals — reentrancy protection is recommended if extended.

---

## Example Contract Snippets

```solidity
function fund() public payable {
    require(
        msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
        "You need to spend more ETH!"
    );
    s_addressToAmountFunded[msg.sender] += msg.value;
    s_funders.push(msg.sender);
}
```

```solidity
function withdraw() public onlyOwner {
    for (uint256 i = 0; i < s_funders.length; i++) {
        address funder = s_funders[i];
        s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address ;
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Call failed");
}
```

---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

---

