// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Test7 {

/*
악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
--------------------------------------------------------
충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
*/
    enum CarStatus { 
        Stopped, 
        Off, 
        Driving 
    }
    
    struct Car {
        uint speed;
        uint gas;
        CarStatus status;
    }
    
    Car public myCar;
    uint public prepaidBalance; 
    constructor() {
        myCar.speed = 0;
        myCar.gas = 100;
        myCar.status = CarStatus.Off;
        prepaidBalance = 0;
    }


    function accel() public {
        require(myCar.status == CarStatus.Driving, "The car must be driving.");
        require(myCar.gas > 30, "Not enough fuel.");
        require(myCar.speed < 70, "Speed is too high.");

        myCar.speed += 10;
        myCar.gas -= 20;
    }

    function brake() public {
        require(myCar.status == CarStatus.Driving, "The car must be driving.");
        require(myCar.speed > 0, "The car is already stopped.");

        if (myCar.speed < 10) {
            myCar.speed = 0;
            myCar.status = CarStatus.Stopped; 
        } else {
            myCar.speed -= 10;
        }
        myCar.gas -= 10;
    }

    function turnOn() public {
        require(myCar.status == CarStatus.Stopped, "The car must be stopped to turn on the engine.");

        myCar.status = CarStatus.Driving;
        myCar.speed = 0; 
    }

    function turnOff() public {
        require(myCar.status == CarStatus.Stopped, "The car must be stopped to turn off the engine.");

        myCar.status = CarStatus.Off;
    }

    function charge() public payable {
        if (msg.value == 1 ether) {
            myCar.gas = 100;
        } else if (prepaidBalance >= 1 ether) {
            prepaidBalance -= 1 ether;
            myCar.gas = 100;
        } else {
            revert("Insufficient payment.");
        }
    }

    function prepay() public payable {
        require(msg.value > 0, "Payment must be greater than 0.");

        prepaidBalance += msg.value;
    }
}
