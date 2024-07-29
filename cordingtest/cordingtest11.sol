// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;
/*
로또 프로그램을 만드려고 합니다. 
숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

참가 금액은 0.05이더이다.

예시 1 : 8,2,4,7,D,A
예시 2 : 9,1,4,2,F,B
*/
contract Test11 {
    struct Entry {
        uint8[4] numbers;
        string[2] letters;
        address participant;
    }

    Entry[] public entries;
    uint8[4] public winningNumbers;
    string[2] public winningLetters;
    address public owner;
    uint256 public ticketPrice = 0.05 ether;

    event EntrySubmitted(address indexed participant, uint8[4] numbers, string[2] letters);
    event WinningNumbersSet(uint8[4] numbers, string[2] letters);
    event PrizeDistributed(address indexed participant, uint256 prize);
    event FundsDeposited(address indexed sender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function submitEntry(uint8[4] memory numbers, string[2] memory letters) public payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");
        entries.push(Entry(numbers, letters, msg.sender));
        emit EntrySubmitted(msg.sender, numbers, letters);
    }

    function setWinningNumbers(uint8[4] memory numbers, string[2] memory letters) public onlyOwner {
        winningNumbers = numbers;
        winningLetters = letters;
        emit WinningNumbersSet(numbers, letters);
    }

    function checkMatches(Entry memory entry) internal view returns (uint8) {
        uint8 matches = 0;

        for (uint8 i = 0; i < 4; i++) {
            for (uint8 j = 0; j < 4; j++) {
                if (entry.numbers[i] == winningNumbers[j]) {
                    matches++;
                    break;
                }
            }
        }

        for (uint8 i = 0; i < 2; i++) {
            for (uint8 j = 0; j < 2; j++) {
                if (keccak256(abi.encodePacked(entry.letters[i])) == keccak256(abi.encodePacked(winningLetters[j]))) {
                    matches++;
                    break;
                }
            }
        }

        return matches;
    }

    function distributePrizes() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Insufficient funds in contract");

        for (uint256 i = 0; i < entries.length; i++) {
            uint8 matches = checkMatches(entries[i]);
            uint256 prize = 0;

            if (matches == 6) {
                prize = 1 ether;
            } else if (matches == 5) {
                prize = 0.75 ether;
            } else if (matches == 4) {
                prize = 0.25 ether;
            } else if (matches == 3) {
                prize = 0.1 ether;
            }

            if (prize > 0) {
                require(contractBalance >= prize, "Insufficient funds for prize distribution");
                payable(entries[i].participant).transfer(prize);
                emit PrizeDistributed(entries[i].participant, prize);
            }
        }

 
        delete entries;
    }

    function depositFunds() public payable onlyOwner {
        emit FundsDeposited(msg.sender, msg.value);
    }

    function getEntriesCount() public view returns (uint256) {
        return entries.length;
    }

    function getEntry(uint256 index) public view returns (uint8[4] memory, string[2] memory, address) {
        Entry storage entry = entries[index];
        return (entry.numbers, entry.letters, entry.participant);
    }


    receive() external payable {}

    fallback() external payable {}
}