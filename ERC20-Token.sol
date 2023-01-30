//SPDX-License-Identifier:GPL-3.0

pragma solidity >=0.5.0<0.9.0;

//https://eips.ethereum.org/EIPS/eip-20
//Min :6 functions and 2 events for ERC-20 token


interface ERC20Interface{
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to,uint tokens) external returns(bool success);

    function allowance(address tokenOwner,address spender) external view returns(uint remaining);
    function approve(address spender,uint tokens) external returns (bool success);
    function transferForm(address from,address to,uint tokens)external returns(bool success);

    event Transfer(address indexed from,address indexed to,uint tokens);
    event Approval(address indexed tokenOwner,address indexed spender,uint tokens);
}


/*abstract*/ contract Block is ERC20Interface{//when interface is inherited then its all function should completed at inhertion time else give error, do off that error you can write abstra`ct at first while inherition, as it allows to pass not defined function in inherition at end when function got defined erase that abstract
    string public name="Block";
    string public symbol="BLK";
    uint public decimal=0;
    uint public override totalSupply;//state variable created for totalSupply function to make it public:for generating getter function
    address public founder;
    mapping(address=> uint) balances;//mapped address to respective uint where uint is balances of respective address
    mapping(address=>mapping(address=>uint)) allowed;//gives the ability to  another address to transact token of owner address

    constructor(){
        totalSupply=1000;
        founder=msg.sender;
        balances[founder]=totalSupply;//founder has all rights on the totalSupply 
    }

    function balanceOf(address tokenOwner) external view override returns(uint balance){//override because we are using that undefined function in inherited contract
    return balances[tokenOwner];
    }
    function transfer(address to,uint tokens) external override returns(bool success){//here we are transfering the some no. of tokens to respective address from caller of this function that is msg.sender
      require(balances[msg.sender]>tokens,"You have insufficent balance");//checking if caller has written amount of tokens or not
      balances[to]+=tokens;//then tokens added to receiver adderss//balances[to]=balnces[to]+tokens
      balances[msg.sender]-=tokens;//same amt of tokens cut from caller address

    emit Transfer(msg.sender, to, tokens);//event emitted of transaction

    return true;
    }
    function allowance(address tokenOwner,address spender) external override view returns(uint remaining){
     return allowed[tokenOwner][spender];//returns how many tokens are allowed for transaction
    }
    function approve(address spender,uint tokens) external override returns (bool success){
        require(balances[msg.sender]>=tokens);//checks if owner has sufficient balance 
        require(tokens>0);//checks whether tokens asked are greater than 0
        allowed[msg.sender][spender]=tokens;//tokens asked are assigned for transact from spender thorugh ownerAddress
        emit Approval(msg.sender,spender, tokens);//emits the approval
        return true;
    }
    function transferForm(address from,address to,uint tokens)external override returns(bool success){
        require(allowed[from][to]>=tokens,"You are not approved this much of money");//cross checked by allow mapping whether owner has allowed that much of tokens or not ,which is implanted by approve function
        require(balances[from]>=tokens,"You have insufficient balances");//checks whether sufficient balance is there or not
        balances[from]-=tokens;//when above condition got set,them transaction proceed from owner
        balances[to]+=tokens;//transaction to receiver
        return true;


    }
   




}