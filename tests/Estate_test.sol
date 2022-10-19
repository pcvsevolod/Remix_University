// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 

import "remix_accounts.sol";
import "../Estate.sol";

contract testSuite {
    Estate public estate;

    address private originalOwner = TestsAccounts.getAccount(0);
    address private newOwner = TestsAccounts.getAccount(1);
    address private giftee = TestsAccounts.getAccount(2);

    function beforeEach() public {
        estate = new Estate(originalOwner, "Test estate", 1_000);
        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        Assert.equal(estate.owner(), originalOwner, "Owner should be account 0");
        Assert.equal(estate.info(), "Test estate", "");
        Assert.equal(estate.area(), 1_000, "");
        Assert.equal(estate.banned(), false, "Should not be banned");
        Assert.equal(estate.giftee(), address(0), "Giftee should be empty");
        Assert.equal(estate.salePrice(), 0, "Sale price should be 0");
    }

    function afterEach() public {
        delete estate;
    }


/*
    function checkShouldFail() public {
        estate.setSalePrice(1);
        Assert.equal(estate.salePrice(), 2, "1 should be 2");
    }
/**/
/*
    function checkChangeOwnerCorrect() public {
        estate.changeOwner(newOwner);
        Assert.equal(estate.owner(), newOwner, "Account should be 2");
    }
/**/
/*
    function checkChangeOwnerToZero() public {
        try estate.changeOwner(address(0)) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New owner cannot be empty", "Should fail");
        } catch (bytes memory ) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkChangeAreaCorrect() public {
        estate.changeArea(3_000_000);
        Assert.equal(estate.area(), 3_000_000, "Area should be 3,000,000");
    }
/**/
/*
    function checkChangeAreaToZero() public {
        try estate.changeArea(0) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New area cannot be zero", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkBan() public {
        estate.ban();
        Assert.equal(estate.banned(), true, "Estate should be banned");
    }
/**/
/*
    function checkBanWithSale() public {
        estate.setSalePrice(1_000_000);
        estate.ban();
        Assert.equal(estate.banned(), true, "Estate should be banned");
        Assert.equal(estate.salePrice(), 0, "Sale price should be zero");
    }
/**/
/*
    function checkBanForGift() public {
        estate.gift(giftee);
        estate.ban();
        Assert.equal(estate.banned(), true, "Estate should be banned");
        Assert.equal(estate.giftee(), address(0), "Giftee should be zero");
    }
/**/
/*
    function checkUnban() public {
        estate.unban();
        Assert.equal(estate.banned(), false, "Estate should be unbanned");
    }
/**/
/*
    function checkGiftCorrect() public {
        estate.gift(giftee);
        Assert.equal(estate.giftee(), giftee, "Should set giftee");
    }
/**/
/*
    function checkGiftWithBan() public {
        estate.ban();
        try estate.gift(giftee) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is banned", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkGiftWithSale() public {
        estate.setSalePrice(1_000);
        try estate.gift(giftee) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is for sale", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkGiftToZero() public {
        try estate.gift(address(0)) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New giftee cannot be empty", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkCancelGift() public {
        estate.gift(giftee);
        estate.cancelGift();
        Assert.equal(estate.giftee(), address(0), "Giftee should be zero");
    }
/**/
/*
    function checkAcceptGiftCorrect() public {
        estate.gift(giftee);
        estate.acceptGift();
        Assert.equal(estate.owner(), giftee, "Owner should be giftee");
        Assert.equal(estate.giftee(), address(0), "Giftee should be zero");
    }
/**/
/*
    function checkAcceptGiftWithoutGiftee() public {
        estate.gift(giftee);
        estate.cancelGift();
        try estate.acceptGift() {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is not being gifted", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkRejectGiftCorrect() public {
        estate.gift(giftee);
        estate.rejectGift();
        Assert.equal(estate.owner(), originalOwner, "Owner should be original");
        Assert.equal(estate.giftee(), address(0), "Giftee should be zero");
    }
/**/
/*
    function checkRejectGiftWithoutGiftee() public {
        estate.gift(giftee);
        estate.cancelGift();
        try estate.rejectGift() {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is not being gifted", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkSetSalePriceCorrect() public {
        estate.setSalePrice(1_000_000);
        Assert.equal(estate.salePrice(), 1_000_000, "Sale price should be 1,000,000");
    }
/**/
/*
    function checkSetSalePriceForZero() public {
        try estate.setSalePrice(0) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New sale price cannot be zero", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkSetSalePriceWithBan() public {
        estate.ban();
        try estate.setSalePrice(1_000_000) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is banned", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkSetSalePriceForGift() public {
        estate.gift(giftee);
        try estate.setSalePrice(1_000_000) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is being gifted", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
/*
    function checkCancelSale() public {
        estate.setSalePrice(1_000_000);
        estate.cancelSale();
        Assert.equal(estate.salePrice(), 0, "Sale price should be 0");
    }
/**/
}
