pragma solidity 0.7.0;

interface IEstate {
    function isBanned() external returns(bool);
    function isForSale() external returns(bool);
    function isBeingGifted() external returns(bool);

    function changeOwner(address payable newOwner) external;
    function changeArea(uint newArea) external;

    function ban() external;
    function unban() external;

    function gift(address giftee_) external;
    function cancelGift() external;
    function acceptGift() external;
    function rejectGift() external;

    function setSalePrice(uint newSalePrice) external;
    function cancelSale() external;
}

contract Estate is IEstate {
    address payable public owner;
    string public info;
    uint public area;
    bool public banned = false;
    address public giftee = address(0);
    uint public salePrice = 0;

    constructor(
        address payable owner_,
        string memory info_,
        uint area_
    ) {
        require(owner != address(0), "Owner cannot be empty");
        owner = owner_;
        info = info_;
        area = area_;
    }

    modifier isNotBanned() {
        require(!banned, "Estate is banned");
        _;
    }

    modifier isNotForSale() {
        require(salePrice == 0, "Estate is for sale");
        _;
    }

    modifier isNotBeingGifted() {
        require(giftee == address(0), "Estate is being gifted");
        _;
    }

    function isBanned() override external view returns(bool) {
        return banned;
    }

    function isForSale() override external view returns(bool) {
        return salePrice > 0;
    }

    function isBeingGifted() override external view returns(bool) {
        return giftee != address(0);
    }

    function changeOwner(address payable newOwner) override external isNotBanned {
        require(newOwner != address(0), "New owner cannot be empty");
        owner = newOwner;
        clearState();
    }

    function changeArea(uint newArea) override external {
        require(newArea > 0, "New area cannot be zero");
        area = newArea;
    }

    function ban() override external {
        banned = true;
        clearState();
    }

    function unban() override external {
        banned = false;
    }

    function gift(address newGiftee) override external isNotBanned isNotForSale {
        require(newGiftee != address(0), "New giftee cannot be empty");
        giftee = newGiftee;
    }

    function cancelGift() override external {
        giftee = address(0);
    }

    function acceptGift() override external isNotBanned {
        owner = payable(giftee);
        this.cancelGift();
    }

    function rejectGift() override external isNotBanned {
        this.cancelGift();
    }

    function setSalePrice(uint newSalePrice) override external isNotBanned isNotBeingGifted {
        require(newSalePrice > 0, "New sale price cannot be zero");
        salePrice = newSalePrice;
    }

    function cancelSale() override external {
        salePrice = 0;
    }

    function clearState() private {
        this.cancelSale();
        this.cancelGift();
    }
}

contract Estates {
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