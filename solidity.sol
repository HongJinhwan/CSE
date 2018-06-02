pragma solidity ^0.4.8;

contract Givu {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint256 public size = 100;
    mapping (address=>uint256) public balanceOf;
    mapping (address=>ArrayList) public historyToFoundation;
    mapping (address=>ArrayList) public historyToPoor;
    mapping (address=>Queue) public foundationQueue;
    
    event Send(uint256 _value);
    
    function Givu(uint256 _supply, string _name, string _symbol){
        name = _name;
        symbol = _symbol;
        totalSupply = _supply;
        balanceOf[msg.sender] = _supply;
    }
    
    //From donator To Foundation
    function transferToFoundation(address _to, uint256 _value){
        if(balanceOf[msg.sender]<_value) 
            throw;
        if(balanceOf[_to] + _value < balanceOf[_to])
            throw;
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        historyToFoundation[msg.sender].data.length= size;
        foundationQueue[_to].data.length = size;
        add(historyToFoundation[msg.sender],Flow({from:msg.sender, to:_to, value:_value}));
        push(foundationQueue[_to], Flow({from:msg.sender, to:_to, value:_value}));
    }
    
    function transferToPoor(address _to, uint256 _value){
        if(balanceOf[msg.sender]<_value) 
            throw;
        if(balanceOf[_to] + _value < balanceOf[_to])
            throw;
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

       /* address fromAddress = peek(foundationQueue[msg.sender]).from;
        address toAddress = peek(foundationQueue[msg.sender]).to;
        uint256 value = peek(foundationQueue[msg.sender]).value;    
        uint256 edit = value - _value;
        historyToPoor[msg.sender].data.length= size;
        add(historyToPoor[fromAddress],Flow({from:fromAddress, to:toAddress, value:edit}));
        */

        while(_value > 0){
            address fromAddress = peek(foundationQueue[msg.sender]).from;
            address toAddress = peek(foundationQueue[msg.sender]).to;
            uint256 value = peek(foundationQueue[msg.sender]).value;    

            if(_value >= value) {
                _value -= value;
                pop(foundationQueue[msg.sender]);        				
                historyToPoor[msg.sender].data.length= size;
                add(historyToPoor[fromAddress],Flow({from:fromAddress, to:toAddress, value:_value}));
            }
            else {
                uint256 edit = value - _value;
                minus(foundationQueue[msg.sender],_value);
                //peek(foundationQueue[msg.sender]).value -= _value;
        		historyToPoor[msg.sender].data.length= size;
                add(historyToPoor[fromAddress],Flow({from:fromAddress, to:toAddress, value:_value}));
                break;
            }
        }
    }
    
    
    
    
    struct Flow{
        address from;
        address to;
        uint256 value;
    }
    
    
    
    function Print_Poor_From(uint256 index) constant returns(address){
        return historyToPoor[msg.sender].data[index].from;
    }
    
    function Print_Poor_To(uint256 index) constant returns(address){
        return historyToPoor[msg.sender].data[index].to;
    }
    
    function Print_Poor_Value(uint256 index) constant returns(uint256){
        return historyToPoor[msg.sender].data[index].value;
    }
    
    function Print_Foundation_From(uint256 index) constant returns(address){
        return historyToFoundation[msg.sender].data[index].from;
    }
    
    function Print_Foundation_To(uint256 index) constant returns(address){
        return historyToFoundation[msg.sender].data[index].to;
    }
    
    function Print_Foundation_Value(uint256 index) constant returns(uint256){
        return historyToFoundation[msg.sender].data[index].value;
    }
    
    
    
    
    struct ArrayList{
        Flow[] data;
        uint front;
        uint back;
    }
    
    function length(ArrayList storage list) constant internal returns (uint) {
        return list.back - list.front;
    }
    
    function add(ArrayList storage list, Flow data) internal
    {
        if ((list.back + 1) % list.data.length == list.front)
            return; // throw;
        list.data[list.back] = data;
        list.back = (list.back + 1) % list.data.length;
    }
    
    
    
    
    struct Queue {
        Flow[] data;
        uint front;
        uint back;
    }
    
    function length(Queue storage q) constant internal returns (uint) {
        return q.back - q.front;
    }
    
    function push(Queue storage q, Flow data) internal
    {
        if ((q.back + 1) % q.data.length == q.front)
            return; // throw;
        q.data[q.back] = data;
        q.back = (q.back + 1) % q.data.length;
    }
    
    function minus(Queue storage q, uint256 _value) internal
    {
        if (q.back == q.front)
            return; // throw;
        q.data[q.front].value -= _value;
    }
    
    function peek(Queue storage q) internal returns (Flow r)
    {
        if (q.back == q.front)
            return; // throw;
        r = q.data[q.front];
    }
    
    function pop(Queue storage q) internal returns (Flow r)
    {
        if (q.back == q.front)
            return; // throw;
        r = q.data[q.front];
        delete q.data[q.front];
        q.front = (q.front + 1) % q.data.length;
    }
    
}