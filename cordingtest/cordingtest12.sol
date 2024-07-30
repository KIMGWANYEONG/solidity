// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;
/*
주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 그 이후는 1분마다 200원(wei)씩 부과합니다. 
주차료는 차량번호인식을 기반으로 실행됩니다.
주차료는 주차장 이용을 종료할 때 부과됩니다.
----------------------------------------------------------------------
차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
*/

contract ParkingSystem {
    struct Vehicle {
        uint entryTime;
        bool isParked;
    }

    mapping(string => Vehicle) private vehicles;
    mapping(string => uint) private parkingFees;

    uint constant FREE_PARKING_DURATION = 2 hours;
    uint constant PARKING_FEE_PER_MINUTE = 200 wei;

    function enterParking(string memory _plateNumber) external {
        require(!vehicles[_plateNumber].isParked, "Vehicle already parked.");
        vehicles[_plateNumber] = Vehicle(block.timestamp, true);
    }

    function exitParking(string memory _plateNumber) external {
        require(vehicles[_plateNumber].isParked, "Vehicle not parked.");

        uint parkedTime = block.timestamp - vehicles[_plateNumber].entryTime;
        uint fee = calculateParkingFee(parkedTime, _plateNumber);

        vehicles[_plateNumber].isParked = false;
        parkingFees[_plateNumber] += fee;
    }

    function calculateParkingFee(uint _parkedTime, string memory _plateNumber) internal pure returns (uint) {
        if (_parkedTime <= FREE_PARKING_DURATION) {
            return 0;
        }

        uint chargeableMinutes = (_parkedTime - FREE_PARKING_DURATION) / 1 minutes;
        uint fee = chargeableMinutes * PARKING_FEE_PER_MINUTE;

        if (isNumeric(_plateNumber)) {
            fee = (fee * 80) / 100; // 20% 할인
        } else if (isAlphabetic(_plateNumber)) {
            fee = (fee * 50) / 100; // 50% 할인
        }

        return fee;
    }

    function isNumeric(string memory _str) internal pure returns (bool) {
        bytes memory b = bytes(_str);
        for (uint i; i < b.length; i++) {
            if (b[i] < 0x30 || b[i] > 0x39) {
                return false;
            }
        }
        return true;
    }

    function isAlphabetic(string memory _str) internal pure returns (bool) {
        bytes memory b = bytes(_str);
        for (uint i; i < b.length; i++) {
            if ((b[i] < 0x41 || b[i] > 0x5A) && (b[i] < 0x61 || b[i] > 0x7A)) {
                return false;
            }
        }
        return true;
    }

    function getParkingFee(string memory _plateNumber) external view returns (uint) {
        return parkingFees[_plateNumber];
    }
}