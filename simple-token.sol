pragma solidity "0.4.21";

contract SimpleToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balances;
    mapping (address => uint256) public deposits;
    
    address owner;
    address buyer;
    uint256 cost; //the initial price for a token
    uint256 _money; //the value the buyer enters
    uint256 numTokens; //the number of tokens they can get
    uint256 change = 0;  //refund incase they pay extra
    

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function SimpleToken(
        uint256 initialSupply
        ) public payable {
        balances[this] = initialSupply;     // Give the creator all initial tokens
        owner = msg.sender;
        cost = msg.value;                  //Initializes the token price
    }

    /* Send coins */
    function transfer(address _to) public {
        numTokens = calculate();
        require(_to != 0x0);        // Prevent transfer to 0x0 address.
        require(balances[this] >= numTokens);           // Check if the sender has enough
        require(balances[_to] + numTokens >= balances[_to]);  // Check for overflows
        balances[this] -= numTokens;                    // Subtract from the sender
        balances[_to] += numTokens;                           // Add the same to the recipient
    }
     
     /*gets the amount of tokens */
    function calculate() public returns (uint) {
        uint tokens;
        require(_money >= cost);   // Check if the sender has enough to buy
        tokens = _money / cost; 
        if (tokens > 5){   //limit buyers to 5 tokens maximum in one sale
            tokens = 5;
        }
        change = _money - (cost * numTokens);
        update (); //update both owner and clients balances
        cost *= 2; //Currently doubles after each transfer-- possibly another way???
        return tokens;
    }
     
   function update() public {
        uint256 price = _money - change;
        
        //gives an error
        /*if(price == 0) throw;
        if(!this.send(price)) throw;
        return true;*/

        //gives an error about lvalue
        buyer.balance -= price;
        this.balance += price;
        deposits[buyer] = 0;
    }   
    
    function deposit() public payable {
        buyer = msg.sender;
        _money = msg.value;
        deposits[buyer] += _money;    //in case they enter multiple times
    }
    
    function transferContractOwnership(address _to) public {
        require(msg.sender == owner);
        owner = _to;
    }

    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner); //sends contract funds back to owner
    }
    
    function ethBalance(address _user) public view returns (uint) {
        return _user.balance;   
    }

    function TokenValue() public view returns (uint) {
      return cost;   //check the cost of the token
    }

}

