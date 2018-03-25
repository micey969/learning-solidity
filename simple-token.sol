pragma solidity "0.4.21";

contract SimpleToken {

    // ------------------------------------------------------------------------
    // This creates an array with all balances
    // ------------------------------------------------------------------------  
    mapping (address => uint256) public balances;
    mapping (address => uint256) public deposits;
    

    // ------------------------------------------------------------------------
    // This creates variables to hold
    //  -Owner of the contract address
    //  -Initial cost for a token
    // ------------------------------------------------------------------------
    address owner;
    uint256 cost; 


    // ------------------------------------------------------------------------
    // Initialisation
    //  -The contract token supply
    //  -The owner of the contract  
    //  -The token price
    // ------------------------------------------------------------------------
    function SimpleToken(
        uint256 initialSupply,
        uint256 initialCost
        ) public payable {
        balances[this] = initialSupply;     
        owner = msg.sender;
        cost = initialCost;                  
    }


    // ------------------------------------------------------------------------
    // Sends Coins
    //  -Gets the sender's balance from deposit
    //  -Receives token amount from calculate
    //  -Prevents transfer to 0x0 address
    //  -Check if the contract has enough tokens
    //  -Check for overflows
    //  -Subtract token amount from contract
    //  -Add token amount to recipient balance
    //  -Update both account balances
    // ------------------------------------------------------------------------
    function transfer(address _to) public{
        uint256 numTokens = calculate();
        require(_to != 0x0);        
        require(balances[this] >= numTokens);           
        require(balances[_to] + numTokens >= balances[_to]);  
        balances[this] -= numTokens;                    
        balances[_to] += numTokens;
        update(numTokens);   
    }
     

    // ------------------------------------------------------------------------
    // Gets the amount of tokens
    //  -Checks if there is enough money to buy
    //  -Puts a limit on tokens bought in one transaction
    //  -Calculates change if there is an an excess
    //  -Returns the amount of token to transfer
    // ------------------------------------------------------------------------
    function calculate() internal returns (uint256) {
        uint256 numTokens;
        require(deposits[msg.sender] >= cost);   
        numTokens = deposits[msg.sender] / cost; 
        if (numTokens > 5){   
            numTokens = 5;
        }
        return numTokens;
    }
     

    // ------------------------------------------------------------------------
    // Update balances
    //  -Get Ether amount
    //  -Transfer Ether amount to owner
    //  -Any remaining deposited amount stays in deposit
    //  -Double token value after each tranaction
    // ------------------------------------------------------------------------
    function update(uint256 numTokens) public {
        uint256 price = (cost * numTokens);
        deposits[msg.sender] -= price;
        owner.transfer(price);
        cost *= 2;
    }   
    

    // ------------------------------------------------------------------------
    // Deposit Ether
    //  -Deposits input amount
    //  -Allows for multiple deposit
    // ------------------------------------------------------------------------
    function deposit() public payable {
        deposits[msg.sender] += msg.value;    
    }
    

    // ------------------------------------------------------------------------
    // Transfer ownership of contract
    //  -Verify the owner of the contract
    //  -Switch owner to new address
    // ------------------------------------------------------------------------
    function transferContractOwnership(address _to) public {
        require(msg.sender == owner);
        owner = _to;
    }

    // ------------------------------------------------------------------------
    // Destroys the contract
    //  -Verify the owner of the contract
    //  -Transfer contract funds to owner
    //  -Destroy contract
    // ------------------------------------------------------------------------
    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner); 
    }
    
    // ------------------------------------------------------------------------
    // Allow user to check their Ether balance
    // ------------------------------------------------------------------------
    function ethBalance(address _user) public view returns (uint256) {
        return _user.balance;   
    }

    // ------------------------------------------------------------------------
    // Allow user to check the cost of a token
    // ------------------------------------------------------------------------
    function TokenValue() public view returns (uint256) {
        return cost;   
    }

    // ------------------------------------------------------------------------
    // Allow user to empty their deposit
    // ------------------------------------------------------------------------
    function Cashout(address _account) public {
        _account.transfer(deposits[_account]);
        deposits[_account] = 0;     
    }

}

