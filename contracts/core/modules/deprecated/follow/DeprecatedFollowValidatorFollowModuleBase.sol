// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {IDeprecatedFollowModule} from 'contracts/interfaces/IDeprecatedFollowModule.sol';
import {ILensHub} from 'contracts/interfaces/ILensHub.sol';
import {Errors} from 'contracts/libraries/constants/Errors.sol';
import {ModuleBase} from 'contracts/core/modules/ModuleBase.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';

/**
 * @title FollowValidatorFollowModuleBase
 * @author Lens Protocol
 *
 * @notice This abstract contract adds the default expected behavior for follow validation in a follow module
 * to inheriting contracts.
 */
abstract contract DeprecatedFollowValidatorFollowModuleBase is ModuleBase, IDeprecatedFollowModule {
    /**
     * @notice Standard function to validate follow NFT ownership. This module is agnostic to follow NFT token IDs
     * and other properties.
     */
    function isFollowing(
        uint256 profileId,
        address follower,
        uint256 followNFTTokenId
    ) external view override returns (bool) {
        address followNFT = ILensHub(HUB).getFollowNFT(profileId);
        if (followNFT == address(0)) {
            return false;
        } else {
            return
                followNFTTokenId == 0
                    ? IERC721(followNFT).balanceOf(follower) != 0
                    : IERC721(followNFT).ownerOf(followNFTTokenId) == follower;
        }
    }
}