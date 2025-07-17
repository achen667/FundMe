// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";

abstract contract ConfigConstants {
    uint8 public constant DECIMALS = 8;

    /*//////////////////////////////////////////////////////////////
                               CHAIN IDS
    //////////////////////////////////////////////////////////////*/
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    //uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is ConfigConstants, Script {
    struct NetworkConfig {
        address priceFeed;
    }

    mapping(uint256 => NetworkConfig) networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getEthSepoliaConfig();
        networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] = getZkSyncSepoliaConfig();
    }

    function getConfigByChainId(
        uint256 chainId
    ) public view returns (address priceFeed) {
        if (networkConfigs[chainId].priceFeed != address(0)) {
            return networkConfigs[chainId].priceFeed;
        }
        // else if (chainId == LOCAL_CHAIN_ID) {
        //     //return getOrCreateAnvilEthConfig();
        // }
        else {
            console2.log("No config found for chainId:", chainId);
            revert("No config found for this chainId");
        }
    }

    function getEthSepoliaConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getZkSyncSepoliaConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return
            NetworkConfig({
                priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
            });
    }
}
