pragma solidity 0.7.0;

interface IEstate {
    // function isBanned() external returns(bool);
    // function isForSale() external returns(bool);
    // function isBeingGifted() external returns(bool);

    function changeOwner(address newOwner) external;
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
    address public owner;
    string public info;
    uint public area;
    bool public banned = false;
    address public giftee = address(0);
    uint public salePrice = 0;

    constructor(
        address owner_,
        string memory info_,
        uint area_
    ) {
        require(owner_ != address(0), "Owner cannot be empty");
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

    modifier isBanned() {
        require(banned, "Estate is not banned");
        _;
    }

    modifier isForSale() {
        require(salePrice != 0, "Estate is not for sale");
        _;
    }

    modifier isBeingGifted() {
        require(giftee != address(0), "Estate is not being gifted");
        _;
    }

    function changeOwner(address newOwner) override external isNotBanned {
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

    function acceptGift() override external isNotBanned isBeingGifted {
        this.changeOwner(giftee);
        clearState();
    }

    function rejectGift() override external isNotBanned isBeingGifted {
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