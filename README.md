# DegenERC Token

## Overview
DegenERC is a simple ERC20 token implementation intended as a training project. It covers the basics of the ERC20 standard, including minting and burning tokens, managing allowances, and transferring tokens between accounts.

## Features
- **ERC20 Standard Compliance**: Implements the basic functions required by the ERC20 standard.
- **Minting**: Allows the owner to mint new tokens to specific addresses.
- **Burning**: Allows approved addresses to burn tokens.
- **Allowances**: Supports the approval and transfer of tokens on behalf of another address.

## Contract Details
The `degenERC` contract extends the ERC20 standard and adds functionalities to handle minting and burning with whitelists.

### Constructor
The constructor initializes the token with a name, symbol, decimals, minting allowance for the owner, and total supply.

### Functions
- **name()**: Returns the name of the token.
- **symbol()**: Returns the symbol of the token.
- **decimals()**: Returns the number of decimals the token uses.
- **totalSupply()**: Returns the total supply of the token.
- **balanceOf(address account)**: Returns the balance of a specified address.
- **allowance(address owner, address spender)**: Returns the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.
- **transfer(address to, uint256 value)**: Transfers `value` tokens to the address `to`.
- **transferFrom(address from, address to, uint256 value)**: Transfers `value` tokens from the address `from` to the address `to`.
- **approve(address spender, uint256 value)**: Approves `spender` to spend `value` tokens on behalf of the caller.
- **mint(address to, uint256 value)**: Mints `value` tokens to the address `to`.
- **burn(address to, uint256 value)**: Burns `value` tokens from the address `to`.
- **_updateMintWhitelist(address to, uint256 value)**: Updates the mint allowance for a specific address.
- **_updateBurnWhitelist(address to, uint256 value)**: Updates the burn allowance for a specific address.


```
       _                            _ _   
__   _| | __ _ ___    _   _ ___  __| | |_ 
\ \ / / |/ _` / __|  | | | / __|/ _` | __|
 \ V /| | (_| \__ \  | |_| \__ \ (_| | |_ 
  \_/ |_|\__,_|___/___\__,_|___/\__,_|\__|
<<<<<<< HEAD
                 |_____|                  

                 |_____|                  
>>>>>>> dd5e49fa70790e2735d18a29525a3d2a2302fbe7
