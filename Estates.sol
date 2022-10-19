pragma solidity 0.7.0;

contract Estates {

    struct Estate {
        address owner;
        string info;
        uint square;
        bool ban;
        address giftee;
        uint price;
    }

    Estate[] public estates;

    address private admin;

    constructor(address _owner) public {
        estates.push(Estate(_owner, "Taganrog, Checkova, 2", 1000, false, address(0), 0));
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "You are not admin");
        _;
    }

    function add_estate(address _owner, string memory _info, uint _square) public onlyAdmin {
        require(_owner != address(0), "wrong address");
        estates.push(Estate(_owner, _info, _square, false, address(0), 0));
    }

    function change_owner(uint _id, address _owner) public onlyAdmin {
        require(_id < estates.length, "Doest exist");
        require(_owner != address(0), "wrong address");
        estates[_id].owner = _owner;
        estates[_id].giftee = address(0);
        estates[_id].price = 0;
    }

    function change_square(uint _id, uint _square) public onlyAdmin {
        require(_id < estates.length, "Doest exist");
        require(_square > 0, "wrong value");
        estates[_id].square = _square;
    }

    function change_ban(uint _id) public onlyAdmin {
        require(_id < estates.length, "Doest exist");
        estates[_id].ban = !estates[_id].ban;
    }

    function present(uint _id, address _giftee) public {
        require(_id < estates.length, "Doest exist");
        require(msg.sender ==  estates[_id].owner, "not your estate");
        require(!estates[_id].ban, "estate is banned");
        require(estates[_id].price == 0, "already in sale");
        estates[_id].giftee = _giftee;
    }

    function accept_present(uint _id) public {
        require(_id < estates.length, "Doest exist");
        require(msg.sender ==  estates[_id].giftee, "not for you");
        require(!estates[_id].ban, "estate is banned");    
        estates[_id].owner = msg.sender;
        estates[_id].giftee = address(0);
    }

    function reject_present(uint _id) public {
        require(_id < estates.length, "Doest exist");
        require(msg.sender ==  estates[_id].giftee, "not for you");
        estates[_id].giftee = address(0);
    }

    function sale(uint _id, uint _price) public {
        require(_id < estates.length, "Doest exist");
        require(msg.sender ==  estates[_id].owner, "not your estate");
        require(!estates[_id].ban, "estate is banned");
        require(estates[_id].giftee == address(0), "already in present");
        estates[_id].price = _price;
    }

    function buy(uint _id) public payable {
        require(_id < estates.length, "Doest exist");
        require(!estates[_id].ban, "estate is banned");
        require(estates[_id].price != 0, "Not saled");
        require(estates[_id].owner != msg.sender, "it's your estate");
        require(msg.value == estates[_id].price, "wrong amount of money");
        address last_owner = estates[_id].owner;
        estates[_id].owner = msg.sender;
        estates[_id].price = 0;
        payable(last_owner).transfer(msg.value);
    }

    function get_estate_amount() public view returns(uint) {
        return estates.length;
    }

    


}