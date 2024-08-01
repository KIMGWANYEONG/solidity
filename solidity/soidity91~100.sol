// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;


contract Q91 {
/*
배열에서 특정 요소를 없애는 함수를 구현하세요. 
예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
*/
    
    uint[] public numbers;

    function addNumber(uint _number) public {
        numbers.push(_number);
    }

    function removeElement(uint _index) public {
        uint zeroBasedIndex = _index - 1;

        require(zeroBasedIndex < numbers.length, "Index out of bounds");

        for (uint i = zeroBasedIndex; i < numbers.length - 1; i++) {
            numbers[i] = numbers[i + 1];
        }
        
        numbers.pop();
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}

contract Q92 {
/*
특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
*/

    function detectAddressType(address _addr) public view returns (string memory) {
        if (_addr.code.length > 0) {
            return "CA"; 
        }
        return "EOA"; 
        }
}

contract Q93 {
/*
다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
*/

    function useCall(address _addr, bytes4 _methodId, uint _n, address _a) public {
        (bool success,)=_addr.call(abi.encodeWithSelector(_methodId, _n, _a));
        require(success);
    }
}

contract Q94 {
/*
inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
*/

    function add(uint _a, uint _b) public pure returns(uint) {
    assembly {
        mstore(0x80, add(_a, _b))
        return(0x80, 32)
        }
    }

    function sub(uint _a, uint _b) public pure returns(uint) {
    assembly {
        mstore(0x80, sub(_a, _b))
        return(0x80, 32)
        }
    }

    function mul(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, mul(_a, _b))
            return(0x80, 32)
        }
    }

    function div(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, div(_a, _b))
            return(0x80, 32)
        }
    }
}

contract Q95 {
/*
inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
*/

    function add(uint _a, uint _b, uint _c) public pure returns (uint result) {
        assembly {
            let sumResult := add(add(_a, _b), _c)
            mstore(0x80, sumResult)
            result := mload(0x80)
        }
    }

    function mul(uint _a, uint _b, uint _c) public pure returns (uint result) {
        assembly {
            let productResult := mul(mul(_a, _b), _c)
            mstore(0x80, productResult)
            result := mload(0x80)
        }
    }
}

contract Q96 {
/*
inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
*/

    function findMaxMin(uint _a, uint _b, uint _c, uint _d) public pure returns (uint _max, uint _min) {
        assembly {

            let base := 0x80
            mstore(base, _a)
            mstore(add(base, 0x20), _b)
            mstore(add(base, 0x40), _c)
            mstore(add(base, 0x60), _d)
            
            let maxTemp := mload(base)
            let minTemp := mload(base)
 
            for { let i := base } lt(i, add(base, 0x80)) { i := add(i, 0x20) } {
                let value := mload(i)
                
                if gt(value, maxTemp) {
                    maxTemp := value
                }
                 
                if lt(value, minTemp) {
                    minTemp := value
                }
            }
            
            mstore(0x80, maxTemp)
            mstore(0xa0, minTemp)
            
            _max := mload(0x80)
            _min := mload(0xa0)
        }
    }
}

contract Q97 {
/*
inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
*/
 
    uint[] public numbers;

    function push(uint _n) public {
        assembly {
            let length := sload(numbers.slot)
            
            let slot := add(keccak256(add(numbers.slot, 0x20), 0x20), length)
   
            sstore(slot, _n)
            
            sstore(numbers.slot, add(length, 1))
        }
    }

    function pop() public {
        assembly {
            let length := sload(numbers.slot)
            if iszero(length) { revert(0, 0) } 
            
            let slot := add(keccak256(add(numbers.slot, 0x20), 0x20), sub(length, 1))
            
            sstore(slot, 0)
            
            sstore(numbers.slot, sub(length, 1))
        }
    }

    function getNumbers() public view returns (uint[] memory) {
        uint length;
        assembly {
            length := sload(numbers.slot)
        }

        uint[] memory result = new uint[](length);
        assembly {
            let src := add(keccak256(add(numbers.slot, 0x20), 0x20), 0)
            let dst := add(result, 0x20)
            
    
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                mstore(dst, sload(src))
                dst := add(dst, 0x20)
                src := add(src, 0x20)
            }
        }

        return result;
    }
}


contract Q98 {
/*
inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
*/

//모르겠습니다.

}

contract Q99 {
/*
inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
*/

    function findMaxMin(uint _a, uint _b, uint _c, uint _d) public pure returns (uint _max, uint _min) {
        assembly {

            let base := 0x80
            mstore(base, _a)
            mstore(add(base, 0x20), _b)
            mstore(add(base, 0x40), _c)
            mstore(add(base, 0x60), _d)
            
            let maxTemp := mload(base)
            let minTemp := mload(base)
 
            for { let i := base } lt(i, add(base, 0x80)) { i := add(i, 0x20) } {
                let value := mload(i)
                
                if gt(value, maxTemp) {
                    maxTemp := value
                }
                 
                if lt(value, minTemp) {
                    minTemp := value
                }
            }
            
            mstore(0x80, maxTemp)
            mstore(0xa0, minTemp)
            
            _max := mload(0x80)
            _min := mload(0xa0)
        }
    }
}

contract Q100 {
/*
inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
*/
    
    function findMaxMin(uint _a, uint _b, uint _c, uint _d) public pure returns (uint _max, uint _min) {
        assembly {

            let base := 0x80
            mstore(base, _a)
            mstore(add(base, 0x20), _b)
            mstore(add(base, 0x40), _c)
            mstore(add(base, 0x60), _d)
            
            let maxTemp := mload(base)
            let minTemp := mload(base)
 
            for { let i := base } lt(i, add(base, 0x80)) { i := add(i, 0x20) } {
                let value := mload(i)
                
                if gt(value, maxTemp) {
                    maxTemp := value
                }
                 
                if lt(value, minTemp) {
                    minTemp := value
                }
            }
            
            mstore(0x80, maxTemp)
            mstore(0xa0, minTemp)
            
            _max := mload(0x80)
            _min := mload(0xa0)
        }
    }
}

