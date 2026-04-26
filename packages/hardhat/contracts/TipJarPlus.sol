// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TipJarPlus {
    address public owner;

    struct Tip {
        address tipper;
        uint256 amount;
        string message;
        uint256 timestamp;
    }

    Tip[] private tips;

    mapping(address => uint256) public totalTipsByAddress;

    event TipReceived(address indexed tipper, uint256 amount, string message, uint256 timestamp);

    event TipWithdrawn(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    receive() external payable {
        _saveTip("");
    }

    function tip(string memory _message) public payable {
        require(msg.value > 0, "Tip amount must be greater than zero.");
        _saveTip(_message);
    }

    function _saveTip(string memory _message) internal {
        require(msg.value > 0, "Tip amount must be greater than zero.");

        tips.push(Tip({ tipper: msg.sender, amount: msg.value, message: _message, timestamp: block.timestamp }));

        totalTipsByAddress[msg.sender] += msg.value;

        emit TipReceived(msg.sender, msg.value, _message, block.timestamp);
    }

    function withdrawTips() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "There are no tips to withdraw.");

        emit TipWithdrawn(owner, contractBalance);

        (bool success, ) = payable(owner).call{ value: contractBalance }("");
        require(success, "Transfer failed.");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTipCount() public view returns (uint256) {
        return tips.length;
    }

    function getTip(
        uint256 _index
    ) public view returns (address tipper, uint256 amount, string memory message, uint256 timestamp) {
        require(_index < tips.length, "Invalid index.");

        Tip memory selectedTip = tips[_index];

        return (selectedTip.tipper, selectedTip.amount, selectedTip.message, selectedTip.timestamp);
    }

    function getAllTips() public view returns (Tip[] memory) {
        return tips;
    }
}
