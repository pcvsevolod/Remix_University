// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../Estate.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
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


    function checkChangeOwnerCorrect() public {
        estate.changeOwner(newOwner);
        Assert.equal(estate.owner(), newOwner, "Account should be 2");
    }

    function checkChangeOwnerToZero() public {
        try estate.changeOwner(address(0)) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New owner cannot be empty", "Should fail");
        } catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, "Unexpected fail");
        }
    }

    function checkChangeAreaCorrect() public {
        estate.changeArea(3_000_000);
        Assert.equal(estate.area(), 3_000_000, "Area should be 3,000,000");
    }

    function checkChangeAreaToZero() public {
        try estate.changeArea(0) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New area cannot be zero", "Should fail");
        } catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, "Unexpected fail");
        }
    }

    function checkBan() public {
        estate.ban();
        Assert.equal(estate.banned(), true, "Estate should be banned");
    }

    function checkUnban() public {
        estate.unban();
        Assert.equal(estate.banned(), false, "Estate should be unbanned");
    }

    function checkGiftCorrect() public {
        estate.gift(giftee);
        Assert.equal(estate.giftee(), giftee, "Should set giftee");
    }

    function checkGiftWithBan() public {
        estate.ban();
        try estate.gift(giftee) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is banned", "Should fail");
        } catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, "Unexpected fail");
        }
    }

    function checkGiftWithSale() public {
        estate.setSalePrice(1_000);
        try estate.gift(giftee) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Estate is for sale", "Should fail");
        } catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, "Unexpected fail");
        }
    }

    function checkGiftToZero() public {
        try estate.gift(address(0)) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "New giftee cannot be empty", "Should fail");
        } catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, "Unexpected fail");
        }
    }

    function checkCancelGift() public {
        estate.gift(giftee);
        estate.cancelGift();
        Assert.equal(estate.giftee(), address(0), "Giftee should be zero");
    }

    function checkAcceptGiftCorrect() public {
        estate.gift(giftee);
    }

    function checkAcceptGiftWithoutGiftee() public {
    }

    function checkRejectGift() public {
    }

    function checkSetSalePrice() public {
    }

    function checkCancelSale() public {
    }


    // function checkSuccess() public {
    //     // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
    //     Assert.ok(2 == 2, 'should be true');
    //     Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
    //     Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    // }

    // function checkSuccess2() public pure returns (bool) {
    //     // Use the return value (true or false) to test the contract
    //     return true;
    // }
    
    // function checkFailure() public {
    //     Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    // }

    // /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    // /// #sender: account-1
    // /// #value: 100
    // function checkSenderAndValue() public payable {
    //     // account index varies 0-9, value is in wei
    //     Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
    //     Assert.equal(msg.value, 100, "Invalid value");
    // }
}
    