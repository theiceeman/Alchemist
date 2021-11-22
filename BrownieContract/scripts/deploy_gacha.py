from brownie import Gacha, config, network
from scripts.helpful_scripts import (
    get_account,
    get_contract,
    fund_with_link,
)

def deploy_gacha():
    accounts = get_account()
    Gacha_Contract = Gacha.deploy({"from":accounts})
    Gacha_Contract.SetNum(5, {"from":accounts})
    print(Gacha_Contract.Number())
def main():
    deploy_gacha()