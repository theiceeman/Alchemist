from brownie import AlchemistNFT, config, network, accounts
from scripts.helpful_scripts import (
    get_account,
    get_contract,
    fund_with_link,
)

def deploy_NFT():
    account = get_account()
    NFT_Contract = AlchemistNFT.deploy({"from":account})
    

    
def main():
    deploy_NFT()