// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Test5 { 
/*
숫자를 시분초로 변환하세요.
예) 100 -> 1 min 40 sec
600 -> 10 min 
1000 -> 1 6min 40 sec
5250 -> 1 hour 27 min 30 sec
*/
        function convert(uint _n) public pure returns (uint, uint, uint) {
            return (_n/3600, (_n%3600/60, _n%60));

        if (hour > 0) {
            return string(abi.encodePacked(hour, "hour", time(hour), "", minute, "min", time(minute), "", second, "sec"));
        } else if (minute > 0) {
            return string(abi.encodePacked(minute, "min", time(minute), "", second, "sec"));
        } else {
            return string(abi.encodePacked(second, "sec"));
        }
    }

    function time(uint256 value) internal pure returns (string memory) {
        if (value != 1) {
            return "s";
        }
        return "";
    }
}