// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Q71 {
/*
숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
*/
    uint256 a; 
    uint256 public lastChangedTime; 

    uint256 constant delay = 10 minutes;

    function setA(uint256 newValue) public {

        uint256 currentTime = block.timestamp;
        require(currentTime >= lastChangedTime + delay, "You can only change the value once every 10 minutes");

        a = newValue;

        lastChangedTime = currentTime;
    }

    function canChange() public view returns (bool) {
        return block.timestamp >= lastChangedTime + delay;
    }
}

contract Q72 {
/*
contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 
해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. 
owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.

예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner),
D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
*/
    address public owner;
    uint public highestDeposit;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        balances[msg.sender] += msg.value;

        if (msg.value > highestDeposit) {
            highestDeposit = msg.value;
            owner = msg.sender;
        }
    }

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");

        payable(msg.sender).transfer(_amount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
contract Q73 {
/*
위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    
예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), 
D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
*/

    address public owner;
    mapping(address => uint) public balances;
    mapping(address => uint) public cumulativeDeposits;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");

        balances[msg.sender] += msg.value;
        cumulativeDeposits[msg.sender] += msg.value;

        if (cumulativeDeposits[msg.sender] > cumulativeDeposits[owner]) {
            owner = msg.sender;
        }
    }

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");

        payable(msg.sender).transfer(_amount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Q74 {
/*
어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    
예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 
0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) 
// 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
*/

    function addTenPercent(uint _number) public pure returns (uint, uint) {
        uint tenPercent = (_number * 10) / 100;
        uint total = _number + tenPercent;
        
        uint remainder = (_number * 10) % 100;

        return (total, remainder);
    }
}

contract Q75 {
/*
문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    
예) abc,3 -> abcabcabc // ab,5 -> ababababab
*/

    function repeatString(string memory _str, uint _n) public pure returns (string memory) {
 
        bytes memory strBytes = bytes(_str);
        uint strLength = strBytes.length;

        bytes memory resultBytes = new bytes(strLength * _n);

        for (uint i = 0; i < _n; i++) {
            for (uint j = 0; j < strLength; j++) {
                resultBytes[i * strLength + j] = strBytes[j];
            }
        }

        return string(resultBytes);
    }
}

contract Q76 {
/*
숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
(패키지없이)
*/
    function uintToString(uint _i) public pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i % 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}

contract Q77 {
/*
위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    
힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
*/
   
    using Strings for uint256;

    function uintToString(uint _value) public pure returns (string memory) {
        return _value.toString(); // OpenZeppelin의 toString() 메서드 사용
    }
}

contract Q78 {
/*
숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    
예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
*/

    uint256[] private numbers;

    // 배열을 설정하는 함수
    function setNumbers(uint256[] calldata _numbers) external {
        // 기존 배열을 새로운 배열로 교체
        numbers = _numbers;
    }

    function hasNumberInRange() external view returns (bool) {
   
        uint256 length = numbers.length;

        for (uint256 i = 0; i < length; i++) {
            if (numbers[i] >= 10 && numbers[i] <= 25) {
                return true;
            }
        }

        return false;
    }
}

contract ContractQ79A {
/*
3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. 
Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 
학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 
구현할 때는 Contract A를 import 하여 구현하세요.
*/

    function findMax(uint _a, uint _b, uint _c) external pure returns (uint) {
        uint max = _a;
        
        if (_b > max) {
            max = _b;
        }
        
        if (_c > max) {
            max = _c;
        }
        
        return max;
    }
}

//import를 하라는 게 어떤 뜻인 지 잘 모르겠습니다.

contract Q80 {
/*
1. 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 
1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 
가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 
가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. 
push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
*/
    uint[] private queue;

    function push(uint _value) external {
        queue.push(_value);
    }

    function FIFO() external returns (uint) {
        require(queue.length > 0, "Queue is empty");

        uint value = queue[0];

        for (uint i = 1; i < queue.length; i++) {
            queue[i - 1] = queue[i];
        }

        queue.pop();

        return value;
    }

    function size() external view returns (uint) {
        return queue.length;
    }

    function getQueue() external view returns (uint[] memory) {
        return queue;
    }
}
