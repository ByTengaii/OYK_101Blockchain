// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Bank {
    struct User {
        address userAddress;
        uint256 balance;
        bool isRegistered;
    }
    mapping(address => User) public users;
    address[] public usersAddressesArray;

    event TransferEther(address _from, address _to, uint256 _amount);

    modifier notRegistered() {
        require(users[msg.sender].isRegistered == true, "kayitli degilsin!");
        _;
    }
    function registerUser() public {
        require(users[msg.sender].isRegistered == false, "zaten kayitli!");

        users[msg.sender] = User(msg.sender, 0, true);
        usersAddressesArray.push(msg.sender);
    }
    function depositEther() public payable {
        require(users[msg.sender].isRegistered == true, "kayitli degilsin!");

        users[msg.sender].balance += msg.value;
    }
    function withdrawEther(uint256 _amount) public notRegistered {
        require(users[msg.sender].balance >= _amount, "yetersiz bakiye!");

        users[msg.sender].balance -= _amount;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "gonderilemedi!"); // revert
    }
    function transferEther(uint256 _amount, address _to) public notRegistered {
        require(users[msg.sender].balance >= _amount, "yetersiz bakiye!");
        require(users[_to].isRegistered == true, "boyle bir kullanici yok!");

        users[msg.sender].balance -= _amount;
        users[_to].balance += _amount;
        emit TransferEther(msg.sender, _to, _amount);
    }
    function getUser(address _address) public view returns(User memory user) {
        return users[_address];
    }
    function getUsers() public view returns (address[] memory addresses){
       return usersAddressesArray;
    }
    function getUsersArrayLength() public view returns(uint256 length) {
        return usersAddressesArray.length;
    }
}