// SPDX-License-Identifier: MIT
// ATSUSHI MANDAI CRDIT Contracts

pragma solidity ^0.8.0;

import "./libraries/access/Ownable.sol";
import "./interfaces/IERC20.sol";

/// @title NFT Lending Platform Core
/// @author Atsushi Mandai
/// @notice sample code for crypto payment contract.
contract Core is Ownable {

    /*
     * @dev Returns true when the payment is completed.
     */
    event PaymentComplete(string identifier);

    /*
     * @dev Keeps ERC20 tokens that can be used for payment.
     */
    mapping(address => bool) public tokenAcceptance;

    /*
     * @dec Returns whether the payment is completed.
     */
    mapping(string => bool) public paymentStatus;

    /*
     * @dev Lets a user pay with crypto.
     */
    function payWithCrypto(
        address _tokenContract,
        uint256 _amount,
        string memory _identifier
    ) public returns(bool) {
        require(
            tokenAcceptance[_tokenContract] == true,
            "This ERC20 token is not accepted."
        );
        IERC20 token = IERC20(_tokenContract);
        token.transferFrom(msg.sender, address(this), _amount);
        paymentStatus[_identifier] = true;
        emit PaymentComplete(_identifier);
        return true;
    }

    /*
     * @dev Lets owner withdraw balance.
     */
    function withdraw(address _tokenAddress) public onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(
            address(this),
            token.balanceOf(address(this))
        );
    }

    /*
     * @dev Lets owner change whether he/she accepts payments in certain ERC20 tokens.
     */
    function changeAcceptance(
        address _tokenAddress,
        bool _acceptance
    ) public onlyOwner {
        tokenAcceptance[_tokenAddress] = _acceptance;
    }

}