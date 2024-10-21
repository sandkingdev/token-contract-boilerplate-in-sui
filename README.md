# token-contract-boilerplate-in-sui 🪙📚

A comprehensive tutorial on building a token contract using the Sui Move programming language. This project demonstrates how to create, mint, transfer, and burn tokens on the Sui blockchain.

## Prerequisites 📋
- Install the Sui CLI by following the [official documentation](https://docs.sui.io).
- Ensure you have Git installed and a stable internet connection.

---

## Project Setup 🚀

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/token-contract-boilerplate-in-sui.git
cd token-contract-boilerplate-in-sui


sui move new <project-name>


sui move test


sui client publish --path or sui client publish 

```
### Step 2: allow authority
```bash
chmod +x ./interaction/devnet.sh

./interaction/devnet.sh
```

### Step 3: function call in the terminal
```bash
    sui client call \
        --function burn_coin \
        --module basictoken \
        --package <package_object_id> \
        --args <basic_token_metadata_object_id> <coin_object_id> \
        --gas-budget 50000000
```

    


