# FundMe

A Solidity smart contract that enables crowdfunding with ETH donations, featuring minimum USD-based contribution requirements and owner-only withdrawals.

## Features

- **USD-Based Minimum**: Enforces a minimum $5 USD donation using Chainlink price feeds
- **Real-time Price Conversion**: Integrates Chainlink ETH/USD oracle for accurate price data
- **Donation Tracking**: Maps and tracks individual contributions per address
- **Owner Withdrawal**: Only contract owner can withdraw accumulated funds
- **Gas Optimized**: Uses custom errors and efficient storage patterns

## Contracts

### FundMe.sol

Main contract handling donations and withdrawals.

**Key Functions:**
- `fund()`: Accept ETH donations (minimum $5 USD equivalent)
- `withdraw()`: Owner-only function to withdraw all contract funds

**State Variables:**
- `MIN_DONATION_AMT`: Constant minimum donation of $5 USD (5 * 10^18 wei)
- `I_OWNER`: Immutable owner address set at deployment
- `donations`: Mapping of donor addresses to their total contributions

### PriceConverter.sol

Library for ETH/USD price conversion using Chainlink oracles.

**Functions:**
- `getEthPrice()`: Fetches current ETH price from Chainlink price feed
- `convertToUsd(uint256 _ethAmount)`: Converts ETH amount to USD equivalent

## How It Works

1. **Donation**: Users call `fund()` with ETH. The contract validates the donation meets the $5 USD minimum using real-time Chainlink price data.
2. **Tracking**: Each donation is recorded in the `donations` mapping, accumulating per address.
3. **Withdrawal**: Contract owner calls `withdraw()` to transfer all contract balance to their address.

## Prerequisites

- Solidity ^0.8.0
- Chainlink contracts: `@chainlink/contracts`

## Network Configuration

Currently configured for **Sepolia testnet**:
- Chainlink ETH/USD Price Feed: `0x694AA1769357215DE4FAC081bf1f309aDC325306`

For other networks, update the price feed address in `PriceConverter.sol:9`.

## Deployment

1. Deploy `FundMe.sol` (PriceConverter is a library and will be linked automatically)
2. The deploying address becomes the immutable owner
3. Contract is ready to accept donations immediately

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

## Security Considerations

- Owner is set immutably at deployment and cannot be changed
- Withdrawal uses low-level `call` with success validation
- Minimum donation prevents dust attacks
- Custom errors save gas compared to string revert messages

## License

MIT