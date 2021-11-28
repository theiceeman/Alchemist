from brownie import Gacha, config, network
from scripts.helpful_scripts import (
    get_account,
    get_contract,
    fund_with_link,
)

def deploy_gacha():
    accounts = get_account()
    Gacha_Contract = Gacha.deploy(bytes32 _keyhash, address _vrfCoordinator, address _linkToken, uint256 _fee, uint256[] memory arrayOfItemDropChance, uint256[] memory arr_ID, address OwnerContract, address NFT_address, uint256 _keyId{"from":accounts})
    Gacha_Contract.SetNum(5, {"from":accounts})
    print(Gacha_Contract.Number())

    print(f"On network {network.show_active()}")
    keyhash = config["networks"][network.show_active()]["keyhash"]
    fee = config["networks"][network.show_active()]["fee"]
    vrf_coordinator = get_contract("vrf_coordinator")
    link_token = get_contract("link_token")
    
    return VRFConsumer.deploy(
        keyhash,
        vrf_coordinator,
        link_token,
        fee,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )


def main():
    deploy_gacha()