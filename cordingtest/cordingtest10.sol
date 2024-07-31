// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;
/*
은행에 관련된 어플리케이션을 만드세요.
은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

* 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
* 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
* 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
* 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
* 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
* 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
-------------------------------------------------------------------------------------------------
* 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
* 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
*/

contract TaxOffice {
    address public taxOfficeAddress;
    mapping(address => uint) public taxDue;
    address public bankSystemAddress;

    constructor() {
        taxOfficeAddress = msg.sender;
    }

    function setBankSystem(address _bankSystemAddress) external {
        require(msg.sender == taxOfficeAddress, "Only tax office can set bank system");
        bankSystemAddress = _bankSystemAddress;
    }

    function calculateTax(address user) external {
        uint totalBalance = BankSystem(bankSystemAddress).getTotalBalance(user);
        taxDue[user] = totalBalance / 100; // 1% tax
    }

    function payTax() external {
        require(taxDue[msg.sender] > 0, "No tax due");
        uint taxAmount = taxDue[msg.sender];
        bool success = BankSystem(bankSystemAddress).transferToTaxOffice(msg.sender, taxAmount);
        require(success, "Tax payment failed");
        taxDue[msg.sender] = 0;
    }

    function forceTaxCollection(address user) external {
        require(msg.sender == taxOfficeAddress, "Only tax office can force collection");
        require(taxDue[user] > 0, "No tax due");
        uint taxAmount = taxDue[user];
        bool success = BankSystem(bankSystemAddress).transferToTaxOffice(user, taxAmount);
        require(success, "Forced tax collection failed");
        taxDue[user] = 0;
    }

    function getTaxDue(address user) external view returns (uint) {
        return taxDue[user];
    }
}

contract BankSystem {
    address public taxOfficeAddress;
    mapping(string => bool) public banks;
    mapping(address => bool) public registeredUsers;
    mapping(string => mapping(address => uint)) public balances;

    uint constant TRANSFER_FEE = 1e15; 

    constructor(address _taxOfficeAddress) {
        taxOfficeAddress = _taxOfficeAddress;
    }

    function addBank(string memory bankName) external {
        require(msg.sender == taxOfficeAddress, "Only tax office can add banks");
        banks[bankName] = true;
    }

    function register(string memory bankName) external {
        require(banks[bankName], "Bank does not exist");
        require(!registeredUsers[msg.sender], "User already registered");
        registeredUsers[msg.sender] = true;
    }

    function deposit(string memory bankName) external payable {
        require(registeredUsers[msg.sender], "User not registered");
        require(banks[bankName], "Bank does not exist");
        balances[bankName][msg.sender] += msg.value;
    }

    function withdraw(string memory bankName, uint amount) external {
        require(registeredUsers[msg.sender], "User not registered");
        require(banks[bankName], "Bank does not exist");
        require(balances[bankName][msg.sender] >= amount, "Insufficient balance");
        balances[bankName][msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function transferBetweenBanks(string memory fromBank, string memory toBank, uint amount) external {
        require(registeredUsers[msg.sender], "User not registered");
        require(banks[fromBank] && banks[toBank], "Invalid bank(s)");
        require(balances[fromBank][msg.sender] >= amount, "Insufficient balance");
        balances[fromBank][msg.sender] -= amount;
        balances[toBank][msg.sender] += amount;
    }

    function transferToOtherUser(string memory fromBank, string memory toBank, address toUser, uint amount) external {
        require(registeredUsers[msg.sender] && registeredUsers[toUser], "User(s) not registered");
        require(banks[fromBank] && banks[toBank], "Invalid bank(s)");
        require(balances[fromBank][msg.sender] >= amount + TRANSFER_FEE, "Insufficient balance");
        balances[fromBank][msg.sender] -= (amount + TRANSFER_FEE);
        balances[toBank][toUser] += amount;
        balances[fromBank][address(this)] += TRANSFER_FEE; 
    }

    function getTotalBalance(address user) external view returns (uint) {
        uint totalBalance = 0;
        string[] memory bankNames = getBankNames();
        for (uint i = 0; i < bankNames.length; i++) {
            totalBalance += balances[bankNames[i]][user];
        }
        return totalBalance;
    }

    function transferToTaxOffice(address user, uint amount) external returns (bool) {
        require(msg.sender == taxOfficeAddress, "Only tax office can call this");
        string[] memory bankNames = getBankNames();
        for (uint i = 0; i < bankNames.length; i++) {
            if (balances[bankNames[i]][user] >= amount) {
                balances[bankNames[i]][user] -= amount;
                return true;
            } else if (balances[bankNames[i]][user] > 0) {
                amount -= balances[bankNames[i]][user];
                balances[bankNames[i]][user] = 0;
            }
        }
        return false; 
    }

    function getBankNames() internal view returns (string[] memory) {
        uint count = 0;
        for (uint i = 0; i < 100; i++) { 
            if (banks[uintToString(i)]) {
                count++;
            }
        }
        string[] memory bankNames = new string[](count);
        uint index = 0;
        for (uint i = 0; i < 100; i++) {
            string memory bankName = uintToString(i);
            if (banks[bankName]) {
                bankNames[index] = bankName;
                index++;
            }
        }
        return bankNames;
    }

    function uintToString(uint v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1];
        }
        return string(s);
    }
}