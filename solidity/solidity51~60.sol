// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q51 {
/*숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
*/
    function thirdLargest(uint[] memory arr) public pure returns (uint) {
        require(arr.length >= 3, "Array must have at least 3 elements");
        
        for (uint i = 0; i < 3; i++) {
            for (uint j = 0; j < arr.length - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    (arr[j], arr[j + 1]) = (arr[j + 1], arr[j]);
                }
            }
        }
        
        return arr[arr.length - 3];
    }
}

contract Q52 {
/*자동으로 아이디를 만들어주는 함수를 구현하세요. 
이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
*/
    function generateID(string memory _name, uint256 _birthdate, address _wallet) public pure returns (bytes10) {
        bytes32 hash = keccak256(abi.encodePacked(_name, _birthdate, _wallet));
        return bytes10(hash);
    }
}


contract Q53 {
/*1. 시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 
각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    
    힌트 : 이중 mapping을 꼭 이용하세요.
*/
    string[5] banks = ["A", "B", "C", "D", "E"];
    
    mapping(string => mapping(address => uint)) deposits;

    function deposit(string memory _bank, uint _amount) public {
        deposits[_bank][msg.sender] += _amount;
    }

    function withdraw(string memory _bank, uint _amount) public {
        deposits[_bank][msg.sender] -= _amount;
    }

    function getBalance(string memory _bank) public view returns (uint) {
        return deposits[_bank][msg.sender];
    }
}

contract Q54 {
/*1. 기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    
    힌트 : 굳이 mapping을 만들 필요는 없습니다.
*/
   
    address public topDonor;
    uint public topDonation;

    function donate(uint _amount) public payable {
        
        if (_amount > topDonation) {
            topDonor = msg.sender;
            topDonation = _amount;
        }
    }

}

contract Q55 {
/*배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
*/
  address public owner;

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Caller is not the owner");
        owner = newOwner;
    }
}

contract Q56 {
/*위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
*/
    address public owner;
    address public subOwner;

    address newOwner;
    bool ownerApproved;
    bool subOwnerApproved;

    constructor(address _subOwner) {
        owner = msg.sender;
        subOwner = _subOwner;
    }

    function proposeNewOwner(address _newOwner) public {
        newOwner = _newOwner;
        ownerApproved = false;
        subOwnerApproved = false;
    }

    function approveAsOwner() public {
        ownerApproved = true;
        finalizeOwnershipChange();
    }

    function approveAsSubOwner() public {
        subOwnerApproved = true;
        finalizeOwnershipChange();
    }

    function finalizeOwnershipChange() internal {
        if (ownerApproved && subOwnerApproved) {
            owner = newOwner;
            newOwner = address(0); 
            ownerApproved = false; 
            subOwnerApproved = false;
        }
    }
}

contract Q57 {
/*위 문제의 또다른 버전입니다. 
owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
*/
    address public owner;
    address public subOwner;

    address public newOwner;
    bool public ownerApprovalNeeded;
    bool public subOwnerApprovalPending;

    constructor(address _subOwner) {
        owner = msg.sender;
        subOwner = _subOwner;
    }

    function changeOwner(address _newOwner) public {
        owner = _newOwner;
    }

    function proposeNewOwner(address _newOwner) public {

        newOwner = _newOwner;
        ownerApprovalNeeded = true;
        subOwnerApprovalPending = true;
    }

    function approveNewOwner() public {
        ownerApprovalNeeded = false;
        subOwnerApprovalPending = false;
        owner = newOwner;
        newOwner = address(0); 
    }

    function rejectNewOwner() public {
        ownerApprovalNeeded = false;
        subOwnerApprovalPending = false;
        newOwner = address(0); 
    }
}


contract Q58 {
/*A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. 
b는 상속받은 contract들만 변경시킬 수 있습니다. 
c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
*/
    uint private a;
    uint internal b;
    uint public c;
}

contract Q59 {
/*현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
*/

    uint public currentTime;
    uint public futureTime;

    function setFutureTime() public {
        currentTime = block.timestamp; 
        futureTime = currentTime + 2 days;  
    }
}

contract Q60 {
/*1. 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    
    예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
    
    힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
*/
    mapping(uint => mapping(uint => string[])) roomBookings;

    uint constant ROOM1 = 1;
    uint constant ROOM2 = 2;

    uint constant MAX_GUESTS = 3;

    function bookRoom(uint roomNumber, uint date, string[] memory guests) public {
        require(guests.length > 0 && guests.length <= MAX_GUESTS, "Guests must be less than 4");
        
        roomBookings[roomNumber][date] = guests;
    }

    function getGuests(uint roomNumber, uint date) public view returns (string[] memory) {
        return roomBookings[roomNumber][date];
    }
}