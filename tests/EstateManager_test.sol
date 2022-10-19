// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 

import "remix_accounts.sol";
import "../EstateManager.sol";

contract testSuite {
    EstateManagerForTesting public manager;

    address private managerSender;
    address private fakeAdmin = TestsAccounts.getAccount(0);
    address private originalOwner = TestsAccounts.getAccount(1);
    address private newOwner = TestsAccounts.getAccount(2);
    address private giftee = TestsAccounts.getAccount(3);

// Special hack, need special contract with changeAdmin
    function beforeEach() public {
        managerSender = address(this);
        manager = new EstateManagerForTesting(TestsAccounts.getAccount(2));
        Assert.equal(manager.getAdmin(), managerSender, "Admin should be original");
    }

    function afterEach() public {
        delete manager;
    }


//*
    function checkChangeOwnerCorrect() public {
        manager.changeOwner(0, newOwner);
        Assert.equal(manager.estates(0).owner(), newOwner, "Owner should be new");
    }
/**/
//*
    function checkChangeOwnerWithoutAdmin() public {
        manager.changeAdmin(fakeAdmin);
        try manager.changeOwner(0, newOwner) {
            Assert.ok(false, "Method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "You are not admin", "Should fail");
        } catch (bytes memory) {
            Assert.ok(false, "Unexpected fail");
        }
    }
/**/
//*
    function checkSetSalePrice() public {
        manager.changeOwner(0, managerSender); // because we cannot change msg.senver EstateManager
        manager.sale(0, 1_000_000);
        Assert.equal(manager.estates(0).salePrice(), 1_000_000, "Price should be 1,000,000");
    }
/**/
}
