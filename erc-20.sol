pragma solidity >=0.4.22 <0.6.0;
library SafeMath {
 
 function add (uint256 a, uint256 b) internal pure returns (uint256) {
 uint256 c = a + b;
 require (c > a,"overflow found");
 return c;
 }
 
 function sub (uint256 a, uint256 b) internal pure returns (uint256) {
 require ( b <= a, "underflow found" );
 uint256 c = a - b;
 return c;
 }
 
 function mul (uint256 a, uint256 b) internal pure returns (uint256) {
 if (a == 0){
 return 0;
 }
 uint256 c = a * b;
 require (c/a == b);
 return c;
 }
 
 function div (uint256 a, uint256 b) internal pure returns (uint256) {
 require (b > 0);
 uint256 c = a / b;
 return c;
 }
}
contract ERC20 { // abstract 
 function totalSupply() public view returns (uint _totalSupply); // return total supply in the 
 function balanceOf(address _owner) public view returns (uint balance);// balance of 
 function transfer(address _to, uint _value) public returns (bool success); //transfer amount 
 function transferFrom(address _from, address _to, uint _value) public returns (bool success);// transfer fundfrom one account to other account
 // Approval of transaction from one any account having Tokens 
 function approve(address _spender, uint _value) public returns (bool success);
 // event will trigger & log files will be generated storing values of 
 // Transfer log (from, to & value) for valid verification from network
 event Transfer (address indexed _from, address indexed _to, uint _value);
 // Approval will be triggered by owners 
 event Approval (address indexed _owner, address indexed _spender, uint _value);
}
contract Cryptocurrency is ERC20 {
 
 using SafeMath for uint; 
 
 string public symbol = "VNC";
 string public name = "VanillaCrypto";
 uint public decimals = 8;
 
 uint totalSupply_ = 100000000000000000000000000000;
 // owner's address
 address public owner;
 mapping (address => uint) _balanceOf;
 // spender is allowed only when spender have balance to be approved 
 mapping (address => mapping(address => uint)) allowed;
 
 constructor () public {
 owner = msg.sender;
 _balanceOf [ owner ] = totalSupply_ ;
 
 }
 
 modifier onlyOwner {
 if (msg.sender != owner) {
 revert();
 }
 _;
 }
// Total Supply function
 // Total supplyfunction returns the total supply subtracted from balanceOf address
 function totalSupply() public view returns (uint _totalSupply){
 return totalSupply_.sub(_balanceOf[address(0)]);
 }
// balance of every accounts that owns crypto
 function balanceOf(address _owner) public view returns (uint balance){
 return _balanceOf[_owner];
}
// This function will return true for successful transaction
 function transfer(address _to, uint _value) public returns (bool success){
 _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
 _balanceOf[_to] = _balanceOf[_to].add(_value);
 emit Transfer(msg.sender, _to, _value);
 return true;
 }
// transferFrom returns True on successful transfer of value 
// If it valid transaction it will be allowed 
 function transferFrom(address _from, address _to, uint _value) public returns (bool 
success){
 _balanceOf[_from] = _balanceOf[_from].sub(_value);
 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
 _balanceOf[_to] = _balanceOf[_to].add(_value);
 emit Transfer(_from, _to, _value);
 return true;
 }
 // To approve the valid transaction using Approval Event 
 function approve(address _spender, uint _value) public returns (bool success){
 allowed[msg.sender][_spender] = _value;
 emit Approval (msg.sender, _spender, _value);
 return true;
 }
// Allowance is given by owner (owner of totalSupply_) to the spender (any address that owns 
 function allowance(address _owner, address _spender) public view returns (uint remaining){
 return allowed[_owner][_spender];
 }
 // While deploying this token cryptocurrency in the network , dont charge any ether 
 function () external payable{
 revert();
 }
function transferAnyERC20Token (address tokenAddress, uint _value) public onlyOwner 
returns (bool success) {
 return ERC20(tokenAddress).transfer(owner, _value);
 
}
 }
