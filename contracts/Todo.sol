// SPDX License Identifier: MIT
pragma solidity ^0.8.20;


contract Todo {
    struct TodoItem {
        string title;
        string description;
        bool isDone;
    }

    TodoItem[] todos;

    function createTodo(string memory _title, string memory _description) external {

    }

    function getTodos() external view returns (TodoItem[] memory) {

    }
}
