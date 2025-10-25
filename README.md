# FundMe

A Solidity smart contract that enables crowdfunding with ETH donations, featuring minimum USD-based contribution requirements and owner-only withdrawals.

## Features

- **USD-Based Minimum**: Enforces a minimum $5 USD donation using Chainlink price feeds
- **Configurable Price Feed**: Price feed address injected via constructor for multi-network deployment
- **Real-time Price Conversion**: Integrates Chainlink ETH/USD oracle for accurate price data
- **Donation Tracking**: Maps and tracks individual contributions per address
- **Owner Withdrawal**: Only contract owner can withdraw accumulated funds
- **Gas Optimized**: Uses custom errors and efficient storage patterns
- **Foundry Framework**: Built with Foundry for testing, deployment, and development

## Project Structure

```
fund-me/
├── src/
│   ├── FundMe.sol           # Main crowdfunding contract
│   └── PriceConverter.sol    # Price conversion library
├── script/
│   └── DeployFundMe.s.sol    # Deployment script
├── test/
│   └── FundMe.t.sol          # Contract tests
└── lib/                      # Dependencies (Chainlink, Forge-std)
```

## Contracts

### FundMe.sol

Main contract handling donations and withdrawals.

**Constructor:**
- `constructor(address _priceFeed)`: Initializes contract with Chainlink price feed address

**Key Functions:**
- `fund()`: Accept ETH donations (minimum $5 USD equivalent)
- `withdraw()`: Owner-only function to withdraw all contract funds
- `getVersion()`: Returns the Chainlink aggregator version

**State Variables:**
- `MIN_DONATION_AMT`: Constant minimum donation of $5 USD (5 * 10^18 wei)
- `I_OWNER`: Immutable owner address set at deployment
- `priceFeed`: Chainlink price feed address
- `donations`: Mapping of donor addresses to their total contributions

### PriceConverter.sol

Library for ETH/USD price conversion using Chainlink oracles.

**Functions:**
- `getEthPrice(address _priceFeed)`: Fetches current ETH price from specified Chainlink price feed
- `convertToUsd(uint256 _ethAmount, address _priceFeed)`: Converts ETH amount to USD equivalent
- `version(address _priceFeed)`: Returns the version of the price feed aggregator

## How It Works

1. **Donation**: Users call `fund()` with ETH. The contract validates the donation meets the $5 USD minimum using real-time Chainlink price data.
2. **Tracking**: Each donation is recorded in the `donations` mapping, accumulating per address.
3. **Withdrawal**: Contract owner calls `withdraw()` to transfer all contract balance to their address.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.0

## Installation

```bash
# Clone the repository
git clone <repo-url>
cd fund-me

# Install dependencies
forge install
```

## Network Configuration

**Sepolia testnet**:
- Chainlink ETH/USD Price Feed: `0x694AA1769357215DE4FAC081bf1f309aDC325306`

For other networks, pass the appropriate price feed address to the constructor during deployment. Find Chainlink price feeds at: https://docs.chain.link/data-feeds/price-feeds/addresses

## Deployment

### Using Foundry Script

```bash
# Deploy to Sepolia testnet
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify

# Deploy to local Anvil chain
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Manual Deployment

```bash
forge create src/FundMe.sol:FundMe --constructor-args <PRICE_FEED_ADDRESS> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

The deploying address becomes the immutable owner.

## Testing

```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test
forge test --match-test test_MinimumDonationAmount

# Generate gas report
forge test --gas-report
```

## Usage

### Making a Donation

```solidity
// Send at least $5 USD worth of ETH
fundMe.fund{value: ethAmount}();
```

### Withdrawing Funds (Owner Only)

```solidity
fundMe.withdraw();
```

### Checking Donations

```solidity
uint256 myDonation = fundMe.donations(myAddress);
```

## Error Handling

- `ErrMinimumDonation()`: Thrown when donation is less than $5 USD
- `ErrNotOwner()`: Thrown when non-owner attempts restricted operations
- `ErrWithdrawFail()`: Thrown when withdrawal transfer fails

## Continuous Integration

The project includes a GitHub Actions workflow that automatically:
- Formats code with `forge fmt`
- Builds the contracts
- Runs the test suite

The CI pipeline runs on every push and pull request to ensure code quality.

## Security Considerations

- Owner is set immutably at deployment and cannot be changed
- Withdrawal uses low-level `call` with success validation
- Minimum donation prevents dust attacks
- Custom errors save gas compared to string revert messages
- Price feed address is configurable for deployment flexibility

## License

MIT