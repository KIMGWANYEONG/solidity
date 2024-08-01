// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q81 {
/*
Contract에 예치, 인출할 수 있는 기능을 구현하세요. 
지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.  
*/

    mapping(address => uint) private balances;

    event Transfer(address indexed from, address indexed to, uint amount);

    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address account) external view returns (uint) {
        return balances[account];
    }

    function totalSupply() external view returns (uint) {
        return address(this).balance;
    }
}

contract Q82 {
/*
특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
*/

    function countMultiples(uint256 number) external pure returns (uint256) {
        uint256 count = 0;
        
        for (uint256 i = 1; i <= number; i++) {
            if (i % 3 == 0 || i % 5 == 0 || i % 8 == 0) {
                count++;
            }
        }
        
        return count;
    }
}


contract Q83 {
/*
이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 
사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
*/

    struct Person {
        string name;
        uint256 number;
        address walletAddress;
        mapping(uint256 => string) dataMapping;
    }

    Person[] public people;
    uint256 public peopleCount;

    function addPerson(string memory _name, uint256 _number, address _walletAddress) public {
        Person storage newPerson = people.push();
        newPerson.name = _name;
        newPerson.number = _number;
        newPerson.walletAddress = _walletAddress;
        peopleCount++;
    }

    function addDataToMapping(uint256 _personIndex, uint256 _key, string memory _value) public {
        require(_personIndex < peopleCount, "Person does not exist");
        people[_personIndex].dataMapping[_key] = _value;
    }

    function getPersonData(uint256 _personIndex, uint256 _key) public view returns (string memory) {
        require(_personIndex < peopleCount, "Person does not exist");
        return people[_personIndex].dataMapping[_key];
    }
}

contract Q84 {
/*
2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 
단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
*/

    mapping(address => bool) public blacklist;

    modifier notBlacklisted() {
        require(!blacklist[msg.sender], "Your address is blacklisted");
        _;
    }

    function addToBlacklist(address _address) public {
        blacklist[_address] = true;
    }

    function removeFromBlacklist(address _address) public {
        blacklist[_address] = false;
    }

    function add(uint256 a, uint256 b) public view notBlacklisted returns (uint256) {
        return a + b;
    }

    function subtract(uint256 a, uint256 b) public view notBlacklisted returns (uint256) {
        return a - b;
    }

    function multiply(uint256 a, uint256 b) public view notBlacklisted returns (uint256) {
        return a * b;
    }
}

contract Q85 {
/*
숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
*/

    uint256 public votesFor;
    uint256 public votesAgainst;
    
    uint256 public startBlock;
    uint256 public endBlock;

    constructor() {
        startBlock = block.number;
        endBlock = startBlock + 20; 
    }

    function voteFor() public {
        require(block.number <= endBlock, "Voting period has ended");
        votesFor += 1;
    }

    function voteAgainst() public {
        require(block.number <= endBlock, "Voting period has ended");
        votesAgainst += 1;
    }

    function getCurrentBlock() public view returns (uint256) {
        return block.number;
    }

    function isVotingPeriodOver() public view returns (bool) {
        return block.number > endBlock;
    }
}

contract Q86 {
/*
숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
*/
    uint public votesFor;
    uint public votesAgainst;

    mapping(address => uint) public deposits;

    uint constant MIN_DEPOSIT = 1 ether;

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }

    function voteFor() public {
        require(deposits[msg.sender] >= MIN_DEPOSIT, "You must deposit at least 1ether");
        votesFor += 1;
    }

    function voteAgainst() public {
        require(deposits[msg.sender] >= MIN_DEPOSIT, "You must deposit at least 1ether");
        votesAgainst += 1;
    }

    function withdraw(uint amount) public {
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getDeposit(address user) public view returns (uint) {
        return deposits[user];
    }
}

contract Q87 {
/*
visibility에 신경써서 구현하세요.   
숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 
변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.
*/

    uint private a;

    function setA(uint _value) internal {
        a = _value;
    }

    function getA() internal view returns (uint) {
        return a;
    }

    function exampleFunction(uint _value) public {
        setA(_value);  
    }

    function retrieveA() public view returns (uint) {
        return getA(); 
    }
}

contract Q88 {
/*
아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.

contract OWNER {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}
힌트 : 상속
*/

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

    contract ChangeOwner is Q88 {
    function changeOwner(address newOwner) public {
    
    setInternal(newOwner);
    }
}

contract Q89 {
/*
이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 
이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. 
(띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
*/

    struct Customer {
        string name;
        string introduction;
    }

    mapping(address => Customer) public customers;

    function registerCustomer(string memory _name, string memory _introduction) public {
        require(bytes(_name).length >= 5 && bytes(_name).length <= 10, "Name must be between 5 and 10 characters.");
        require(bytes(_introduction).length >= 20 && bytes(_introduction).length <= 50, "Introduction must be between 20 and 50 characters.");
        
        customers[msg.sender] = Customer(_name, _introduction);
    }

    function getCustomer(address _customerAddress) public view returns (string memory name, string memory introduction) {
        Customer memory customer = customers[_customerAddress];
        return (customer.name, customer.introduction);
    }
}
contract Q90 {
/*
당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
*/

//모르겠습니다.
}
