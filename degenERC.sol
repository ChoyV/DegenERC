// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IERC20.sol";

/**
 * @title DegenERC
 * @dev Implementation of the IERC20 interface with additional mint and burn functionalities
 */
abstract contract degenERC is IERC20 {
    address public owner;
    string public _name;
    uint256 public _totalSupply;
    string public _symbol;
    uint8 public _decimals;

    mapping(address => uint) public _mintWhitelist;
    mapping(address => uint) public _burnWhitelist;
    mapping(address => uint) public _balances;
    mapping(address => mapping(address => uint)) public _allowances;

    modifier onlyOwner () {
        require(msg.sender == owner, "DegenERC: caller is not the owner");
        _;
    }

    /**
     * @dev Sets the values for {name}, {symbol}, {decimals}, {mintApproveForOwner}, and {totalSupply}.
     * @param name_ Name of the token
     * @param symbol_ Symbol of the token
     * @param decimals_ Number of decimal places the token uses
     * @param mintApproveForOwner Amount of tokens the owner is approved to mint
     * @param totalSupply_ Initial total supply of the token
     */
    constructor(string memory name_, string memory symbol_, uint decimals_, uint mintApproveForOwner, uint totalSupply_) {
        owner = msg.sender;
        _symbol = symbol_;
        _name = name_;
        _totalSupply = totalSupply_;
        _decimals = decimals_;
        _mintWhitelist[owner] = mintApproveForOwner;
        _burnWhitelist[owner] = type(uint).max;
    }

    /**
     * @notice Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @notice Returns the symbol of the token.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @notice Returns the number of decimals the token uses.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @notice Returns the total supply of the token.
     */
    function totalSupply() public view virtual returns (uint) {
        return _totalSupply;
    }

    /**
     * @notice Returns the balance of the specified address.
     * @param account The address to query the balance of
     * @return A uint representing the amount owned by the passed address
     */
    function balanceOf(address account) public view returns (uint) {
        return _balances[account];
    }

    /**
     * @notice Returns the remaining number of tokens that spender is allowed to spend on behalf of _owner.
     * @param _owner The owner of the tokens
     * @param spender The address which will spend the funds
     * @return A uint specifying the amount of tokens still available for the spender
     */
    function allowance(address _owner, address spender) public view returns (uint) {
        return _allowances[_owner][spender];
    }

    /**
     * @notice Transfer tokens to a specified address.
     * @param to The address to transfer to
     * @param value The amount to be transferred
     * @return A boolean that indicates if the operation was successful
     */
    function transfer(address to, uint value) public returns (bool) {
        address from = msg.sender;
        _update(from, to, value);
        return true;
    }

    /**
     * @notice Transfer tokens from one address to another.
     * @param from The address which you want to send tokens from
     * @param to The address which you want to transfer to
     * @param value The amount of tokens to be transferred
     * @return A boolean that indicates if the operation was successful
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0), "DegenERC: transfer from the zero address");
        require(_allowances[from][msg.sender] >= value, "DegenERC: transfer amount exceeds allowance");
        _spendAllowance(from, msg.sender, value);
        _update(from, to, value);
        return true;
    }

    /**
     * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param spender The address which will spend the funds
     * @param value The amount of tokens to be spent
     * @return A boolean that indicates if the operation was successful
     */
    function approve(address spender, uint value) public virtual returns (bool) {
        address _owner = msg.sender;
        _approve(_owner, spender, value, true);
        return true;
    }

    /**
     * @notice Mint tokens to a specified address.
     * @param to The address to mint tokens to
     * @param value The amount of tokens to be minted
     */
    function mint(address to, uint value) public virtual {
        require(_mintWhitelist[msg.sender] >= value, "DegenERC: mint amount exceeds allowance");
        _mintWhitelist[msg.sender]-= value;
        address from = address(0);
        _update(from, to, value);
    }

    /**
     * @notice Burn tokens from a specified address.
     * @param to The address from which tokens will be burned
     * @param value The amount of tokens to be burned
     */
    function burn(address to, uint value) public virtual {
        require(msg.sender != address(0), "DegenERC: burn from the zero address");
        require(_burnWhitelist[msg.sender] >= value, "DegenERC: mint amount exceeds allowance");
        _burnWhitelist[msg.sender]-= value;
        address from = msg.sender;
        _update(from, to, value);
    }

    /**
     * @notice Approve the passed address to spend the specified amount of tokens on behalf of _owner.
     * @param _owner The owner of the tokens
     * @param spender The address which will spend the funds
     * @param value The amount of tokens to be spent
     * @param emitEvent Boolean to indicate if an approval event should be emitted
     */
    function _approve(address _owner, address spender, uint value, bool emitEvent) internal {
        require(_owner != address(0), "DegenERC: approve from the zero address");
        require(spender != address(0), "DegenERC: approve to the zero address");
        _allowances[_owner][spender] = value;
        if (emitEvent) {
            emit Approval(_owner, spender, value);
        }
    }

    /**
     * @notice Update allowance for a spender
     * @param _owner The owner of the tokens
     * @param spender The address which will spend the funds
     * @param value The amount of tokens to be spent
     */
    function _spendAllowance(address _owner, address spender, uint value) internal virtual {
        uint currentAllowance = allowance(_owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= value, "DegenERC: insufficient allowance");
            _approve(_owner, spender, currentAllowance - value, false);
        }
    }

    

    /**
     * @notice Update the mint whitelist for a specific address
     * @param to The address to update the mint allowance for
     * @param value The new mint allowance
     */
    function _updateMintWhitelist(address to, uint value) public virtual onlyOwner {
        _mintWhitelist[to] = value;
    }

    /**
     * @notice Update the burn whitelist for a specific address
     * @param to The address to update the burn allowance for
     * @param value The new burn allowance
     */
    function _updateBurnWhitelist(address to, uint value) public virtual onlyOwner {
        _burnWhitelist[to] = value;
    }

    /**
     * @notice Internal function to update balances and total supply
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param value The amount of tokens to be transferred
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            require(fromBalance >= value, "DegenERC: transfer amount exceeds balance");
            unchecked {
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                _totalSupply -= value;
            }
        } else {
            unchecked {
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }
}
