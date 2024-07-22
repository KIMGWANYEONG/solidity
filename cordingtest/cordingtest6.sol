// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test6 {
    
    /*
숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2
--------------------------------------------------------------------------------------------
문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f
*/

   
    function splitNumber(uint num) public pure returns (uint, uint[] memory) {
       
        uint length = 0;
        uint temp = num;
        while (temp != 0) {
            length++;
            temp /= 10;
        }

        uint[] memory digits = new uint[](length);
        temp = num;
        for (uint i = length; i > 0; i--) {
            digits[i-1] = temp % 10;
            temp /= 10;
        }

        return (length, digits);
    }

    function splitString(string memory str) public pure returns (uint, string[] memory) {
        bytes memory strBytes = bytes(str);
        uint length = strBytes.length;
        string[] memory chars = new string[](length);

        for (uint i = 0; i < length; i++) {
            chars[i] = string(abi.encodePacked(strBytes[i]));
        }

        return (length, chars);
    }
}