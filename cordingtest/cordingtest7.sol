// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Test3 {

/*
악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
--------------------------------------------------------
충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
*/

    uint public speed;
    uint public fuel;
    bool public engineStatus; // false for off, true for on
    uint256 public prepaidBalance;

    constructor() {
        speed = 0;
        fuel = 100;
        engineStatus = false;
        prepaidBalance = 0;
    }

    function accelerate() public {
        require(engineStatus == true, "Engine is off");
        require(fuel > 30, "Not enough fuel");
        require(speed < 70, "Speed is too high");

        speed += 10;
        fuel -= 20;
    }  function refuel() public payable {
        if (msg.value == 1 ether) {
            fuel = 100;
        } else if (prepaidBalance >= 1 ether) {
            prepaidBalance -= 1 ether;
            fuel = 100;
        } else {
            revert("Insufficient payment");
        }
    }

    function brake() public {
        require(engineStatus == true, "Engine is off");
        require(speed > 0, "Car is already stopped");

        if (speed < 10) {
            speed = 0;
        } else {
            speed -= 10;
        }
                fuel -= 10;
    }

    function turnOffEngine() public {
        require(speed == 0, "Car must be stopped to turn off engine");

        engineStatus = false;
    }

    function turnOnEngine() public {
        engineStatus = true;
    }

    function prepay() public payable {
        require(msg.value > 0, "Payment must be greater than 0");

        prepaidBalance += msg.value;
    }
}