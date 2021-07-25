// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.0;

contract CBSC {
    
     /*
        =========================================================

        Commitment Based Smart Contracts
        v.0.1
        
        Joost de Kruijff
        j.c.dekruijff@tilburguniversity.edu
        https://github.com/codeoffconduct/CBSC/blob/main/CBSC.sol

        =========================================================
    */
    
    
     /*
        Rules of engagement (ROE)
        - Properties in the ROE change the state of the blockchain
        - Struct definitions
        - Arrays to store the struct objects in order to work with initiated commitments, events and fluents
    */

    // address variable defining the owner 
    address internal owner = msg.sender;
    
    //Swap roles during assignment and delegation
    address internal x;
    address internal y;
    address internal z;

    // State enums
    enum EventState { Defined, Executed }
    enum FluentState { NonFulfilled, PartialFulfilled, Fulfilled }
    enum CommitmentState { Committed, Activated, Terminated }

    // Commitment struct
    struct Commitment {
        string _time;
        string _type;
        string _category;
        string _title; 
        CommitmentState _state;
    }
    
    // Event struct
    struct Event {
        string _time;
        string _title;
        EventState _state;
    }

    // Fluent struct
    struct Fluent {
        string _time;
        string _title;
        FluentState _state;
    }

    // Asset
    struct Asset {
        string a;
        uint256 m;
    }
 
    // Array to store Commitment structs
    Commitment[] private commitments;
    
    // Array to store Event structs
    Event[] private events;

    // Array to store Event structs
    Fluent[] private fluents;

    // Variable to store the asset details, like the address
    string A;

    // // Variable to store the asset details, like the address
    uint256 M;
    
    
    /*
        Modifiers
    */

    // Halts function if owner is not initiating the transaction
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    
    /*
        Events
        - Details per event can be found in the Log debug output of the transaction
        - Use web3 library to interact with events and setup listeners
    */
    
    // Trigger event to notify outside code that a new commitment is created
    event CommitmentCreated(
        //output the commitment details
            string, string, string, string
        );

    // Trigger event to notify outside code that an existing commitment is activated
    event Activate(
        //output the commitment details
            string, string, string, string
        );

    // Trigger event to notify outside code that an existing commitment is terminated
    event Terminate(
        //output the commitment details
            string, string, string, string
        );

    // Trigger event to notify outside code that a new event is created
    event EventCreated(
        //output the commitment details
            string, string
        );

    event ProtocolRun(string, string);
    
    /*
        Create Functions
    */

    constructor() {
        
        // Set the owner
        owner = msg.sender;
         
    }


    // Create a Commitment
    function createCommitment(
        string memory time, 
        string memory type_, 
        string memory category, 
        string memory title) external onlyOwner 
        {
        commitments.push(Commitment({
            _time: time,
            _type: type_,
            _category: category,
            _title: title,
            _state: CommitmentState.Committed
        }));

        // Notify event triggers of new commitment
        emit CommitmentCreated(time , type_, category, title);

    }
    
    //create an Event
    function createEvent(string memory time, string memory title) external onlyOwner {
        events.push(Event({
            _time: time,
            _title: title,
            _state: EventState.Defined
        }));
        
        // Notify event triggers of new event
        emit EventCreated(time, title);
    }

    //create an Event
    function createFluent(string memory time, string memory title) external onlyOwner {
        fluents.push(Fluent({
            _title: title,
            _time: time,
            _state: FluentState.NonFulfilled
        }));
    }

    /*
        Query Functions
    */

    //query entire protocol run
    function protocolRun() external {
        for(uint i = 0; i < events.length; i++) {
            emit ProtocolRun(events[i]._time, events[i]._title);
            emit ProtocolRun(commitments[i]._time, commitments[i]._title);
        }
        
    }
    
    function onTime(string memory t) external view returns(string memory TimeIs, string memory EventTitleIs, string memory CommitmentTitleIs){
        string memory eventOnT;
        string memory commitmentOnT;
        
        for(uint i = 0; i < events.length; i++) {
            if(keccak256(abi.encodePacked(events[i]._time)) == keccak256(abi.encodePacked(t))){
                eventOnT = events[i]._title;
            }
        }
        
        for(uint i = 0; i < commitments.length; i++) {
            if(keccak256(abi.encodePacked(commitments[i]._time)) == keccak256(abi.encodePacked(t))){
                commitmentOnT = commitments[i]._title;
            }
        }
        return(t, eventOnT, commitmentOnT);
    }

    /*
        KR Reaction RuleML forward chainining
    */

    // Event trigger
    
    function onEvent(string memory t) external view returns(string memory TimeIs, string memory EventTitleIs, string memory CommitmentTitleIs){
        string memory eventOnT;
        string memory commitmentOnT;
        
        for(uint i = 0; i < events.length; i++) {
            if(keccak256(abi.encodePacked(events[i]._time)) == keccak256(abi.encodePacked(t))){
                eventOnT = events[i]._title;
            }
        }
        
        for(uint i = 0; i < commitments.length; i++) {
            if(keccak256(abi.encodePacked(commitments[i]._time)) == keccak256(abi.encodePacked(t))){
                commitmentOnT = commitments[i]._title;
            }
        }
        return(t, eventOnT, commitmentOnT);
    }
    
    // Perform action to manipulate commitments through smart contract state
    function doAction(uint _index, string memory _title) public {
        Commitment storage commitment = commitments[_index];
        commitment._title = _title;
    }

    // Verify HoldsAt condition
    function ifConstraint() public {
        //TODO
    }

}