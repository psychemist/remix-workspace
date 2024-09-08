// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AreaCalculator {
    function circleCalculator(int _radius) public pure returns (int256) {
        require(_radius > 0, "Radius must be a positive integer!");
        return (_radius * 22) / 7;
    }

    function triangleCalculator(uint _base, uint _height) public pure returns (uint256) {
        return (_base * _height) / 2;
    }

    function squareCalculator(uint _length) public pure returns (uint) {
        return _length ** 2;
    }

    function rectangleCalculator(uint _length, uint _breadth) public pure returns (uint) {
        return _length * _breadth;
    }
}