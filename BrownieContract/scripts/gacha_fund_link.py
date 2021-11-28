from brownie import Gacha, config, network
from scripts.helpful_scripts import fund_with_link, get_account


def main():
    account = get_account()
    gacha_contract = Gacha[-1]
    tx = fund_with_link(
        gacha_contract.address, amount=config["networks"][network.show_active()]["fee"]
    )
    tx.wait(1)
    print("Requested!")
    
