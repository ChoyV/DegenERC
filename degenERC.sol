///SPDX-License-Identifier: MIT

pragma solidity^0.8.20;


import "./IERC20.sol";



abstract contract degenERC is IERC20 {
address public owner;
string public _name;
uint256 public _totalSupply;
string public _symbol;
uint public _decimals;

mapping(address=>uint) public _mintWhitelist;
mapping(address=>uint) public _burnWhitelist;
mapping(address=>uint) public _balances;
mapping(address=>mapping(address=>uint)) internal _allowances;
constructor (string memory name_,string memory symbol_, uint decimals_, uint mintApproveForOwner) {
    owner = msg.sender;
    _symbol = symbol_;
    _name = name_;
    _decimals=decimals_;
    _mintWhitelist[owner] = mintApproveForOwner;
    _burnWhitelist[owner] = type(uint).max;
}



function name() public view returns (string memory) {
    return _name;
}

function symbol () public view returns (string memory) {
    return _symbol;
}
 
function decimals () public view returns (uint) {
    return _decimals;
}

function totalSupply () public view returns (uint) {
    return _totalSupply;
}

function balanceOf (address account) public view returns (uint) {
    return balances[account];
}

function transfer (address from,address to,uint value) public returns (bool) {
    require(value>=balances[from],'Value to send is more than balance');
    balances[from]-=value;
    balances[to]+=value;
    emit Transfer(from, to, value);
    return true;
}

function transferFrom (address from, address to, uint256 value) public view returns(bool) {
    require (from != address(0),"");
    require (_allowances[from][to]<=value, "Allowance is exceeded");
    transfer(from,to,value);
    return true;
}


function allowance (address owner, address spender) public view returns (uint) {
    return _allowances[owner][spender];
    
}


function approve (address owner, address spender, uint value, bool emitEvent) public virtual returns (bool) {
require(owner == msg.sender, "Approval allowed only for owner");
_approve(owner,spender,value, true);
} 




function _approve(address owner, address spender, uint value, bool emitEvent) internal {
    require(owner=address(0), "Prohibited for 0 address");
    require(spender=address(0), "Prohibited for 0 address");
    _allowances[owner][spender] = value;
    if (emitEvent) {
        emit Approval(address indexed owner, address indexed spender, uint256 value);
    }
}


function _spendAllowanance (address owner, address spender, uint value) internal virtual {
    uint currentAllowance = allowance(owner, spender);
    if (currentAllowance != type(uint256).max) {
        if (currentAllowance<value) {
            revert("You cant spend more than approved");
        }
        unchecked {
            _approve (owner,spender,currentAllowance-value);
        }
    }

}

function mint (address to, uint value) public virtual returns (bool) {
    require(msg.sender == address(0), "Not available to mint for 0 address");
    require (_mintWhitelist[msg.sender] >= value, "Unable to mint");
    _totalSupply+=value;
    _balances[to]+= value;
    emit Transfer(address(0),to,value);
}

function burn(address to, uint value) public virtual {
    require (_burnWhitelist[msg.sender] >= value, "Unable to mint");
    require(msg.sender == address(0), "Not available to mint for 0 address");
    _totalSupply-=value;
    _balances[to]-= value;
    emit Transfer(msg.sender,address(0),value);
}


function _updateMintWhitelist (address to, uint value) public override {
    require(msg.sender == owner,"You are not an owner");
    _mintWhitelist[to] = value;
}

function _updateBurnWhitelist (address to, uint value) public override {
    require(msg.sender == owner,"You are not an owner");
    _mintBurnlist[to] = value;
}
}
