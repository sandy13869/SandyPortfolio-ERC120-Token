//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract SamERC20{
    function name() virtual public view returns (string memory);
    function symbol() virtual public view returns (string memory);
    function decimals() virtual public view returns (uint8);
    function totalSupply() virtual public view returns (uint256);
    function balanceOf(address _owner) virtual public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) virtual public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);
    function approve(address _spender, uint256 _value) virtual public returns (bool success);
    function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Owned {
    address public owner;
    address public newOwner;

    // Changing/Teansferring of the ownership with

    event OwnershipTransfered(address indexed _from, address indexed _to);

    // To create an Instance of the contract

    constructor() {
        // The caller of the Smart Contract over the Eth Block chain
        owner = msg.sender;
    }

    // To Transfer the Ownership

    function transferOwnership(address _to) public {
        require(msg.sender == owner);
        newOwner= _to;
    }

    // Accepting the ownership by the new owner

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransfered(owner, newOwner);
        owner = newOwner;
        // Assign Garbage address to the Ethereum
        newOwner = address(0);
    }

}

contract Token is SamERC20, Owned {

    string public _symbol;
    string public _name;
    uint8 public _decimal;
    uint public _totalSupply;
    // Central authority to mint new coins
    address public _minter;

    // Keep tracking how much the address holdings & transaction

    mapping(address => uint) balances;

    constructor() {
        _symbol = "SAM";
        _name = "SamToken";
        _decimal = 0;
        _totalSupply = 100;
        _minter = ;//Add Test Net Address

        balances[_minter] = _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }

    // The function is overriding with the new one

    function name() public override view returns (string memory){
        return _name;
    }

    function symbol() public override view returns (string memory){
        return _symbol;
    }

    function decimals() public override view returns (uint8){
        return _decimal;
    }

    function totalSupply() public override view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance){
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value);
        balances[_from] -= _value; // balances[_from] = balances[_from] - _value
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;

    }

    function transfer(address _to, uint256 _value) public override returns (bool success){
        return transferFrom(msg.sender, _to, _value);
    }

    // Using for the ERC20 Standard but Implementation is optional

    function approve(address _spender, uint256 _value) public override returns (bool success){
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
        return 0;
    }

    // Inject new currency into the money supply

    function mint(uint amount) public returns (bool) {
        require(msg.sender == _minter);
        balances[_minter] += amount;
        _totalSupply += amount;
        return true;
    }

    // To shrink the Mint expansion or remove new currency by force

    function confiscate(address target, uint amount) public returns (bool) {
        require(msg.sender == _minter);

        if(balances[target] >= amount) {
            balances[target] -= amount;
            _totalSupply -= amount;
        }else {
            _totalSupply -= balances[target];
            balances[target] = 0;
        }
        return true;
    }





}