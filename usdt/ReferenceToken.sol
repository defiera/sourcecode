
pragma solidity >=0.5.1 <0.7.0;








import "../tools/Ownable.sol";
import "../tools/SafeMath.sol";

import { ERC20Token } from "./ERC20Token.sol";
import { ERC777Token } from "./ERC777Token.sol";

contract USDTToken is Ownable, ERC20Token, ERC777Token {

    using SafeMath for uint256;

    string private mName;
    string private mSymbol;
    uint256 private mGranularity;
    uint256 private mTotalSupply;
    uint8 private mDecimal;
    address[] private mDefaultOperators;

    mapping(address => uint) private mBalances;
    mapping(address => mapping(address => bool)) private mAuthorized;
    mapping(address => mapping(address => uint256)) private mAllowed;

    
    
    
    
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint totalSupply,
        uint8 decimal
    ) public {
        mName = _name;
        mSymbol = _symbol;
        mTotalSupply = totalSupply * 10 ** uint(decimal);
        mGranularity = 1;

        mBalances[msg.sender] = mTotalSupply;
        mDefaultOperators.push(msg.sender);
    }

    function addDefaultOperators(address owner) external onlyOwner returns (bool) {
        mDefaultOperators.push(owner);
    }

    function removeDefaultOperators(address owner) external onlyOwner returns (bool) {

        for (uint i = 0; i < mDefaultOperators.length; i++) {
            if ( mDefaultOperators[i] == owner ) {
                for (uint j = i; j < mDefaultOperators.length - 1; j++) {
                    mDefaultOperators[j] = mDefaultOperators[j+1];
                }
                delete mDefaultOperators[mDefaultOperators.length - 1];
                mDefaultOperators.length --;
                return true;
            }
        }

        return false;
    }

    
    
    
    function name() external view returns (string memory) { return mName; }

    
    function decimals() external view returns (uint8) { return mDecimal; }

    
    function symbol() external view returns (string memory) { return mSymbol; }

    
    function granularity() external view returns (uint256) { return mGranularity; }

    
    function totalSupply() external view returns (uint256) { return mTotalSupply; }

    function defaultOperators() external view returns (address[] memory) { return mDefaultOperators; }

    
    
    function authorizeOperator(address _operator) external {
        require(_operator != msg.sender);
        mAuthorized[_operator][msg.sender] = true;
        emit AuthorizedOperator(_operator, msg.sender);
    }

    
    
    function revokeOperator(address _operator) external {
        require(_operator != msg.sender);
        mAuthorized[_operator][msg.sender] = false;
        emit RevokedOperator(_operator, msg.sender);
    }

    
    
    
    function balanceOf(address _tokenHolder) external view returns (uint256) { return mBalances[_tokenHolder]; }

    
    
    
    function send(address _to, uint256 _amount, bytes calldata _userData) external {
        doSend(msg.sender, _to, _amount, _userData, msg.sender, "");
    }

    
    
    
    
    function isOperatorFor(address _operator, address _tokenHolder) public view returns (bool) {

        for (uint i = 0; i < mDefaultOperators.length; i++) {
            if ( mDefaultOperators[i] == _operator )  {
                return true;
            }
        }

        return _operator == _tokenHolder || mAuthorized[_operator][_tokenHolder];
    }

    
    
    
    
    
    
    function operatorSend(address _from, address _to, uint256 _amount, bytes calldata _userData, bytes calldata _operatorData) external {
        require( isOperatorFor(msg.sender, _from) );
        doSend(_from, _to, _amount, _userData, msg.sender, _operatorData);
    }

    
    
    
    
    
    
    
    function mint(address _tokenHolder, uint256 _amount, bytes calldata _operatorData) external onlyOwner {

        mTotalSupply = mTotalSupply.add(_amount);
        mBalances[_tokenHolder] = mBalances[_tokenHolder].add(_amount);

        emit Minted(msg.sender, _tokenHolder, _amount, "", _operatorData);
    }

    
    
    
    
    function burn(uint256 _amount, bytes calldata _data) external {

        require( mBalances[msg.sender] >= _amount );

        mBalances[msg.sender] = mBalances[msg.sender].sub(_amount);
        mBalances[address(0x0)] = mBalances[address(0x0)].add(_amount);

        mTotalSupply = mTotalSupply.sub(_amount);

        emit Burned(msg.sender, msg.sender, _amount, _data, "");
    }

    function operatorBurn(
        address _from,
        uint256 _amount,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external {

        require( isOperatorFor(msg.sender, _from) );

        require( mBalances[_from] >= _amount );

        mBalances[_from] = mBalances[_from].sub(_amount);
        mBalances[address(0x0)] = mBalances[address(0x0)].add(_amount);

        mTotalSupply = mTotalSupply.sub(_amount);

        emit Burned(msg.sender, _from, _amount, _data, _operatorData);
    }

    
    
    
    
    function transfer(address _to, uint256 _amount) external returns (bool success) {
        doSend(msg.sender, _to, _amount, "", msg.sender, "");
        return true;
    }

    
    
    
    
    
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success) {
        require(_amount <= mAllowed[_from][msg.sender]);

        
        mAllowed[_from][msg.sender] = mAllowed[_from][msg.sender].sub(_amount);
        doSend(_from, _to, _amount, "", msg.sender, "");
        return true;
    }

    
    
    
    
    
    function approve(address _spender, uint256 _amount) external returns (bool success) {
        mAllowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    
    
    
    
    
    
    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
        return mAllowed[_owner][_spender];
    }

    
    
    
    function isRegularAddress(address _addr) internal view returns(bool) {
        if (_addr == address(0)) { return false; }
        uint size;
        assembly { size := extcodesize(_addr) } 
        return size == 0;
    }

    
    
    
    
    
    
    
    
    
    function doSend(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory _userData,
        address _operator,
        bytes memory _operatorData
    )
        private
    {
        require(_to != address(0));           
        require(mBalances[_from] >= _amount); 

        mBalances[_from] = mBalances[_from].sub(_amount);
        mBalances[_to] = mBalances[_to].add(_amount);

        emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);
    }
}
