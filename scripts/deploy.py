from brownie import config, MemorizeThisDayOnBTC,MemorizeThisDayOnETH,MemorizeThisDayOnLINK,MemorizeThisDayOnSHIB,MemorizeThisDayOnBNB,MemorizeThisDayOnDOGE,network
from scripts.helpful_scripts import get_account, get_contract

def deploy_BNB():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="Founder")
    mtd= MemorizeThisDayOnBNB.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="Developers"),
        get_account(id="Founder"),
        {"from":account,'gas_limit': 20000000},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd

def deploy_DOGE():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="Founder")
    mtd= MemorizeThisDayOnDOGE.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="Developers"),
        get_account(id="Founder"),
        {"from":account,'gas_limit': 20000000},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd

def deploy_SHIB():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="Founder")
    mtd= MemorizeThisDayOnSHIB.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="Developers"),
        get_account(id="Founder"),
        {"from":account,'gas_limit': 20000000},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd


def deploy_LINK():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="Founder")
    mtd= MemorizeThisDayOnLINK.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="Developers"),
        get_account(id="Founder"),
        {"from":account,'gas_limit': 20000000},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd



def deploy_ETH():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="Founder")
    mtd= MemorizeThisDayOnETH.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="Developers"),
        get_account(id="Founder"),
        {"from":account,'gas_limit': 20000000},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd



# def deploy_BTC():
#     currentNetwork=config["networks"][network.show_active()]
#     print(f"current network: {currentNetwork}")
#     account = get_account(0)
#     mtd= MemorizeThisDayOnBTC.deploy(
#         get_contract("vrf_coordinator").address,
#         get_contract("link_token").address,
#         config["networks"][network.show_active()]["fee"],
#         config["networks"][network.show_active()]["keyhash"],
#         get_contract("memorize_BTC_price_feed").address,
#         get_account(1),
#         account,
#         {"from":account,'gas_limit': 20000000},
#         publish_source=config["networks"][network.show_active()].get("verify",False)
#     )
#     print(f"Contract deployed to {mtd.address}")
#     return mtd

#,"priority_fee": 35000000000}
def deploy_BTC():
    currentNetwork=config["networks"][network.show_active()]
    print(f"current network: {currentNetwork}")
    account = get_account(id="founderRinkeby")
    mtd= MemorizeThisDayOnBTC.deploy(
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        get_contract("memorize_BTC_price_feed").address,
        get_account(id="developerRinkeby"),
        get_account(id="founderRinkeby"),
        {"from":account},
        publish_source=config["networks"][network.show_active()].get("verify",False)
    )
    print(f"Contract deployed to {mtd.address}")
    return mtd

def publish_source():
    mdt=MemorizeThisDayOnBTC[-1]
    MemorizeThisDayOnBTC.publish_source(mdt)
    
    

def main():
    deploy_BTC()
    #deploy_ETH()
    #deploy_LINK()
    #deploy_DOGE()
    #deploy_SHIB()
    #deploy_BNB()
    #publish_source()