# OJCoin 🪙

OJCoin is a SIP-010 compliant fungible token implementation on the Stacks blockchain. This smart contract provides a complete token system with standard transfer, mint, and burn capabilities.

## Features

- ✅ **SIP-010 Compliant**: Fully implements the Stacks Improvement Proposal 010 fungible token standard
- 🔒 **Access Control**: Role-based permissions with contract owner privileges
- 💰 **Token Operations**: Transfer, mint, and burn functionality
- 📊 **Token Metadata**: Configurable name, symbol, decimals, and URI
- 🚀 **Maximum Supply**: Capped at 1 billion OJCoins (1,000,000,000 with 6 decimals)
- 🔍 **Read-Only Functions**: Query balances, supply, and token information

## Token Details

- **Name**: OJCoin
- **Symbol**: OJC
- **Decimals**: 6
- **Max Supply**: 1,000,000,000.000000 OJC (1,000,000,000,000,000 micro-units)

## Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v3.10.0 or later
- [Node.js](https://nodejs.org/) (for running tests)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ojcoin.git
cd ojcoin
```

2. Install dependencies:
```bash
npm install
```

## Development

### Check Contract Syntax

Verify the contract syntax is valid:

```bash
clarinet check
```

### Run Tests

Execute the test suite:

```bash
npm test
```

### Start Clarinet Console

Interact with the contract in a REPL environment:

```bash
clarinet console
```

### Launch Local Devnet

Start a local development network:

```bash
clarinet integrate
```

## Smart Contract Functions

### SIP-010 Standard Functions

#### `transfer`
Transfer tokens from sender to recipient.

```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```

#### `get-name`
Returns the token name.

```clarity
(get-name) → (response (string-ascii 32))
```

#### `get-symbol`
Returns the token symbol.

```clarity
(get-symbol) → (response (string-ascii 10))
```

#### `get-decimals`
Returns the number of decimals.

```clarity
(get-decimals) → (response uint)
```

#### `get-balance`
Returns the balance of an account.

```clarity
(get-balance (account principal)) → (response uint)
```

#### `get-total-supply`
Returns the total supply of tokens.

```clarity
(get-total-supply) → (response uint)
```

#### `get-token-uri`
Returns the token metadata URI.

```clarity
(get-token-uri) → (response (optional (string-utf8 256)))
```

### Additional Functions

#### `mint` (Owner Only)
Mint new tokens to a recipient address.

```clarity
(mint (amount uint) (recipient principal)) → (response bool uint)
```

**Requirements:**
- Only callable by contract owner
- Total supply cannot exceed maximum supply
- Amount must be greater than 0

#### `burn`
Burn tokens from the sender's account.

```clarity
(burn (amount uint)) → (response bool uint)
```

**Requirements:**
- Sender must have sufficient balance
- Amount must be greater than 0

#### `set-token-uri` (Owner Only)
Update the token metadata URI.

```clarity
(set-token-uri (new-uri (optional (string-utf8 256)))) → (response bool uint)
```

#### `is-contract-owner`
Check if an address is the contract owner.

```clarity
(is-contract-owner (address principal)) → bool
```

#### `get-max-supply`
Returns the maximum supply cap.

```clarity
(get-max-supply) → (response uint)
```

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| `u100` | `err-owner-only` | Function can only be called by contract owner |
| `u101` | `err-not-token-owner` | Caller is not authorized to transfer tokens |
| `u102` | `err-insufficient-balance` | Insufficient token balance |
| `u103` | `err-invalid-amount` | Amount must be greater than 0 |
| `u104` | `err-max-supply-exceeded` | Minting would exceed maximum supply |

## Deployment

### Testnet Deployment

1. Configure your testnet settings in `settings/Testnet.toml`
2. Deploy the contract:

```bash
clarinet deployments apply --testnet
```

### Mainnet Deployment

1. Configure your mainnet settings in `settings/Mainnet.toml`
2. Deploy the contract:

```bash
clarinet deployments apply --mainnet
```

⚠️ **Warning**: Ensure you thoroughly test the contract on testnet before deploying to mainnet.

## Usage Examples

### Minting Tokens (Contract Owner)

```clarity
;; Mint 1000 OJC (1000000000 micro-units) to an address
(contract-call? .ojcoin mint u1000000000 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Transferring Tokens

```clarity
;; Transfer 50 OJC (50000000 micro-units) to another address
(contract-call? .ojcoin transfer u50000000 tx-sender 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG none)
```

### Burning Tokens

```clarity
;; Burn 10 OJC (10000000 micro-units)
(contract-call? .ojcoin burn u10000000)
```

### Checking Balance

```clarity
;; Get balance of an address
(contract-call? .ojcoin get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

## Security Considerations

- The contract owner has exclusive minting privileges
- Token transfers require sender authorization
- Maximum supply is enforced to prevent inflation
- All public functions include input validation
- Burns are irreversible and permanently reduce supply

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

The project includes comprehensive unit tests. Run them with:

```bash
npm test
```

Tests cover:
- Token transfers
- Minting operations
- Burning operations
- Access control
- Balance queries
- Supply management

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarinet Documentation](https://docs.hiro.so/clarinet)
- [SIP-010 Fungible Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)
- [Clarity Language Reference](https://docs.stacks.co/clarity/language-overview)

## Support

For questions and support:
- Open an issue on GitHub
- Visit the [Stacks Discord](https://discord.gg/stacks)
- Check the [Stacks Forum](https://forum.stacks.org/)

## Acknowledgments

- Built with [Clarinet](https://github.com/hirosystems/clarinet)
- Follows [SIP-010](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md) standard
- Deployed on the [Stacks blockchain](https://www.stacks.co/)

---

**Made with ❤️ for the Stacks ecosystem**
