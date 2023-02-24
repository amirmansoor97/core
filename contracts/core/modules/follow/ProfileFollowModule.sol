// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {IFollowModule} from 'contracts/interfaces/IFollowModule.sol';
import {Errors} from 'contracts/libraries/constants/Errors.sol';
import {ModuleBase} from 'contracts/core/modules/ModuleBase.sol';
import {FollowValidatorFollowModuleBase} from 'contracts/core/modules/follow/FollowValidatorFollowModuleBase.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';

/**
 * @title ProfileFollowModule
 * @author Lens Protocol
 *
 * @notice A Lens Profile NFT token-gated follow module with single follow per token validation.
 */
contract ProfileFollowModule is FollowValidatorFollowModuleBase {
    /**
     * Given two profile IDs tells if the former has already been used to follow the latter.
     */
    mapping(uint256 => mapping(uint256 => bool)) public isProfileFollowing;

    constructor(address hub) ModuleBase(hub) {}

    /**
     * @notice This follow module works on custom profile owner approvals.
     *
     * @return bytes Empty bytes.
     */
    function initializeFollowModule(
        uint256,
        address,
        bytes calldata
    ) external view override onlyHub returns (bytes memory) {
        return new bytes(0);
    }

    /**
     * @dev Processes a follow by:
     *  1. Validating that the follower owns the profile passed through the data param.
     *  2. Validating that the profile that is being used to execute the follow was not already used for following the
     *     given profile.
     */
    function processFollow(
        uint256,
        address follower,
        address,
        uint256 profileId,
        bytes calldata data
    ) external override onlyHub {
        uint256 followerProfileId = abi.decode(data, (uint256));
        if (IERC721(HUB).ownerOf(followerProfileId) != follower) {
            revert Errors.NotProfileOwner();
        }
        if (isProfileFollowing[followerProfileId][profileId]) {
            revert Errors.FollowInvalid();
        } else {
            isProfileFollowing[followerProfileId][profileId] = true;
        }
    }

    /**
     * @dev We don't need to execute any additional logic on transfers in this follow module.
     */
    function followModuleTransferHook(
        uint256 profileId,
        address from,
        address to,
        uint256 followNFTTokenId
    ) external override {}
}
