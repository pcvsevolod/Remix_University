pragma solidity 0.7.0;

import "./Estate.sol";

contract EstateManager {
    Estate[] public estates;

    address private admin;

    constructor(address payable owner) {
        admin = msg.sender;
        addEstate({
            owner: owner,
            info: "Taganrog, Checkova, 2",
            area: 1_000
        });
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "You are not admin");
        _;
    }

    modifier correctIndex(uint index) {
        require(index < estates.length, "Index out of bounds");
        _;
    }

    modifier myEstate(uint index) {
        require(estates[index].owner() == msg.sender, "You don't own this estate");
        _;
    }

    modifier giftForMe(uint index) {
        require(estates[index].giftee() == msg.sender, "Gift not for you");
        _;
    }

    function addEstate(address payable owner, string memory info, uint area)
        public
        onlyAdmin
    {
        estates.push(new Estate(
            owner,
            info,
            area
        ));
    }

    function changeOwner(uint index, address payable newOwner)
        public
        onlyAdmin
        correctIndex(index)
    {
        estates[index].changeOwner(newOwner);
    }

    function changeArea(uint index, uint area) 
        public
        onlyAdmin
        correctIndex(index)
    {
        require(area > 0, "Area cannot be zero");
        estates[index].changeArea(area);
    }

    function banEstate(uint index)
        public
        onlyAdmin
        correctIndex(index)
    {
        estates[index].ban();
    }

    function unbanEstate(uint index)
        public
        onlyAdmin
        correctIndex(index)
    {
        estates[index].unban();
    }

    function giftEstate(uint index, address giftee)
        public
        correctIndex(index)
        myEstate(index)
    {
        estates[index].gift(giftee);
    }

    function stopGifting(uint index)
        public
        correctIndex(index)
        myEstate(index)
    {
        estates[index].cancelGift();
    }

    function acceptGift(uint index)
        public
        correctIndex(index)
        giftForMe(index)
    {
        estates[index].acceptGift();
    }

    function rejectGift(uint index)
        public
        correctIndex(index)
        giftForMe(index)
    {
        estates[index].rejectGift();
    }

    function sale(uint index, uint price)
        public
        correctIndex(index)
        myEstate(index)
    {
        estates[index].setSalePrice(price);
    }

    function cancelSale(uint index)
        public
        correctIndex(index)
        myEstate(index)
    {
        estates[index].cancelSale();
    }

    function buy(uint index)
        public
        payable
        correctIndex(index)
    {
        require(estates[index].owner() != msg.sender, "it is your estate");
        require(msg.value == estates[index].salePrice(), "Wrong price");
        address lastOwner = estates[index].owner();
        estates[index].changeOwner(msg.sender);
        payable(lastOwner).transfer(msg.value);
    }

    function getEstateCount() public view returns(uint) {
        return estates.length;
    }
}