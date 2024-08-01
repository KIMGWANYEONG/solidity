// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;
   
    contract ArrayOperations {
    uint[] public number;
    uint[4] public number2;
   
    function createDynamicArray(uint n) public {
        delete number; // 기존 배열을 초기화
        for (uint i = 1; i <= n; i++) {
            number.push(i);
        }
    }

    function createFixedArray(uint a, uint b, uint c, uint d) public {
        number2[0] = a;
        number2[1] = b;
        number2[2] = c;
        number2[3] = d;
    }
    
    function sumDynamicArray() public view returns (uint sum) {
        assembly {
            let len := sload(number.slot)
            let dataLoc := keccak256(add(number.slot, 0x20), 0x20) // 배열의 첫 번째 요소의 위치 계산
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                sum := add(sum, sload(add(dataLoc, i)))
            }
        }
    }

    function sumFixedArray() public view returns (uint sum) {
        assembly {
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                sum := add(sum, sload(add(number2.slot, i)))
            }
        }
    }

    function getDynamicArrayElement(uint k) public view returns (uint value) {
        assembly {
            let len := sload(number.slot)
            if lt(k, len) {
                let dataLoc := keccak256(add(number.slot, 0x20), 0x20) // 배열의 첫 번째 요소의 위치 계산
                value := sload(add(dataLoc, k))
            }
        }
    }

    function getFixedArrayElement(uint k) public view returns (uint value) {
        require(k < 4, "Index out of bounds");
        assembly {
            value := sload(add(number2.slot, k))
        }
    }
}
