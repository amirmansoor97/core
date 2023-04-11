// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {ILensHubEventHooks} from 'contracts/interfaces/ILensHubEventHooks.sol';
import {Errors} from 'contracts/libraries/constants/Errors.sol';
import {StorageLib} from 'contracts/libraries/StorageLib.sol';
import {Events} from 'contracts/libraries/constants/Events.sol';

abstract contract LensHubEventHooks is ILensHubEventHooks {
    /// @inheritdoc ILensHubEventHooks
    function emitUnfollowedEvent(uint256 unfollowerProfileId, uint256 idOfProfileUnfollowed) external override {
        address expectedFollowNFT = StorageLib.getProfile(idOfProfileUnfollowed).followNFT;
        if (msg.sender != expectedFollowNFT) {
            revert Errors.CallerNotFollowNFT();
        }
        emit Events.Unfollowed(unfollowerProfileId, idOfProfileUnfollowed, block.timestamp);
    }

    //////////////////////////////////////
    ///       DEPRECATED FUNCTIONS     ///
    //////////////////////////////////////

    // Deprecated in V2. Kept here just for backwards compatibility with Lens V1 Collect NFTs.
    function emitCollectNFTTransferEvent(uint256, uint256, uint256, address, address) external {}
}