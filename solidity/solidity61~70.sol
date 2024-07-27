// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Q61 {
/*
a의 b승을 반환하는 함수를 구현하세요.
*/
   function power(uint _a, uint _b) public pure returns (uint256) {
        uint256 result = 1;
        for (uint256 i = 0; i < _b; i++) {
            result *= _a;
        }
        return result;
    }
}

contract Q62 {
/*
2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 
3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
*/

    function validateInputs(uint _a, uint _b) public pure {
        require(_a <= 10 && _b <= 10, "Inputs must be between 0 and 10");
    }

    function add(uint _a, uint _b) public pure returns (uint) {
        validateInputs(_a, _b);
        return _a + _b;
    }

    function multiply(uint _a, uint _b) public pure returns (uint) {
        validateInputs(_a, _b);
        return _a * _b;
    }

    function power(uint _a, uint _b) public pure returns (uint) {
        validateInputs(_a, _b);
        return uint(_a) ** _b;
    }
}


contract Q63 {
/*
2개 숫자의 차를 나타내는 함수를 구현하세요.
*/
    function subtract(uint _a, uint _b) public pure returns (uint) {
        return _a - _b;
    }
}

contract Q64 {
/*
지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
*/
    function splitAddress(address _addr) public pure returns (bytes4[] memory) {
        bytes memory packedAddress = abi.encodePacked(_addr);
        bytes4[] memory result = new bytes4[](5);

        for (uint i = 0; i < 5; i++) {
            bytes4 chunk;
            assembly {
                chunk := mload(add(add(packedAddress, 0x20), mul(i, 4)))
            }
            result[i] = chunk;
        }

        return result;
    }
}

contract Q65 {
/*
숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자) 
*/
    function squareNumbers(uint _a, uint _b, uint _c) public pure returns (uint, uint, uint) {
        return (_a * _a, _b * _b, _c * _c);
    }

    function getMedianSquare(uint _a, uint _b, uint _c) public pure returns (uint) {
        uint squareA = _a * _a;
        uint squareB = _b * _b;
        uint squareC = _c * _c;

        if ((squareA >= squareB && squareA <= squareC) || (squareA <= squareB && squareA >= squareC))
            return squareA;
        else if ((squareB >= squareA && squareB <= squareC) || (squareB <= squareA && squareB >= squareC))
            return squareB;
        else
            return squareC;
    }
}

contract Q66 {
/*
특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 
추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
*/
     function getDigits(uint _num) public pure returns (uint) {
        if (_num == 0) return 1;
        
        uint digits = 0;
        while (_num > 0) {
            _num /= 10;
            digits++;
        }
        return digits;
    }

    function getQuinaryDigits(uint _num) public pure returns (uint) {
        if (_num == 0) return 1;
        
        uint digits = 0;
        while (_num > 0) {
            _num /= 5;
            digits++;
        }
        return digits;
    }
}

contract Q67A {
/*
자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
*/
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {}
}

contract Q67B {
    receive() external payable {}
    fallback() external payable {}

    function deposit() external payable {
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function sendEther(address payable _recipient, uint _amount) external {
        _recipient.transfer(_amount);
    }
}

contract Q68 {
/*
계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
예) 5 → 1*2*3*4*5 = 60, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
while을 사용해보세요
*/
     function calculateFactorial(uint _n) public pure returns (uint) {
        if (_n == 0 || _n == 1) {
            return 1;
        }

        uint result = 1;
        uint i = 1;  

        while (i <= _n) {
            result *= i;
            i++;
        }

        return result;
    }
}

contract Q69 {
/*
숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
힌트 : 7번 문제(시,분,초로 변환하기)
*/
   function convertToString(uint _a, uint _b, uint _c) public pure returns (string memory) {
        return string(abi.encodePacked(
            toString(_a),
            " and ",
            toString(_b),
            " or ",
            toString(_c)
        ));
    }

    function toString(uint _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint temp = _value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(_value % 10)));
            _value /= 10;
        }
        return string(buffer);
    }
}

contract Q70 {
/*
번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. 
bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 고객의 정보를 넣고 변화시키는 함수를 구현하세요.
*/
    struct Customer {
        uint number;
        string name;
        bytes32 hash;
    }

    mapping(uint => Customer) public customers;

    function addCustomer(uint _number, string memory _name) public {
        bytes32 _hash = keccak256(abi.encodePacked(_number, _name));
        customers[_number] = Customer(_number, _name, _hash);
    }

    function updateCustomer(uint _number, string memory _newName) public {
        
        bytes32 _newHash = keccak256(abi.encodePacked(_number, _newName));
        customers[_number].name = _newName;
        customers[_number].hash = _newHash;
    }

    function getCustomer(uint _number) public view returns (uint, string memory, bytes32) {
        Customer memory customer = customers[_number];
        return (customer.number, customer.name, customer.hash);
    }
}

