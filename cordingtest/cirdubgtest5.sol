// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Test5 { 

        function convertSeconds(uint _n) public pure returns (string memory) {
        uint hour = _n/ 3600;
        uint minute = (_n% 3600) / 60;
        uint second = _n% 60;

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