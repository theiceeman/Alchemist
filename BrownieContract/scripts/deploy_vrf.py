#!/usr/bin/python3
from brownie import VRFConsumer, config, network
from scripts.helpful_scripts import (
    get_account,
    get_contract,
    fund_with_link,
)


def depoly_vrf():
    account = get_account()
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



def request_random_and_read(contract):
    account = get_account()
    vrf_contract = contract
    tx = fund_with_link(
        vrf_contract.address, amount=config["networks"][network.show_active()]["fee"]
    )
    tx.wait(1)
    get_random_num = vrf_contract.getRandomNumber({"from": account})
    print("Requested!")
    get_random_num.wait(1)
    if vrf_contract.randomResult() == 0:
        print("The result is 0, you may have to wait a minute unless on a local chain!")
    print(vrf_contract.randomResult())




def main():
    contract = depoly_vrf()
    request_random_and_read(contract)
    
