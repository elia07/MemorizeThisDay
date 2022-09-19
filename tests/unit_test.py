from eth_account import Account
import web3
from scripts.deploy import deploy_BTC
from datetime import timezone, datetime
from scripts.helpful_scripts import get_account, fund_with_link, get_contract
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS
import pytest
from brownie import exceptions
from brownie import chain, network
from web3 import Web3
from datetime import timedelta
#test safetransfer  and batch transfer

#holdersBalanceExpected = (mintPrice * mtdContract.HOLDERS_MINT_SHARE() / 100) / mtdContract.GetMintedDaysLength()
#holdersBalanceActual = []
#for i in range(0, mtdContract.GetMintedDaysLength()):
#    holdersBalanceActual.append(mtdContract._wallet(mtdContract._holders(mtdContract._mintedDays(i))))
#for h in holdersBalanceActual:
#    assert h == holdersBalanceExpected

#TODO TEST MEMO
#TODO change startDate

def test_constructor_initializing(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    dt = datetime(2010, 1, 1, 0, 0,0)
    #expected_startdate =calendar.timegm(time.mktime(datetime.datetime.strptime('2010-01-01 00:00:00', '%Y-%m-%d %H:%M:%S').timetuple()))
    expected_startdate =int(dt.replace(tzinfo=timezone.utc).timestamp())
    actual_startdate = mtdContract._startDate()    
    expected_developers_airdrop_count=20
    actual_developers_airdrop_count=mtdContract._airdrop(get_account())
    # Assert
    assert expected_startdate==actual_startdate
    assert expected_developers_airdrop_count==actual_developers_airdrop_count

def test_MemorizeThisDay_with_airdrop(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    acc2 = get_account(1)
    mintPrice=mtdContract._mintPrice()
    # Act
    beforMintMintedDays = mtdContract.GetMintedDaysLength()
    beforeMintGiftCount = mtdContract._airdrop(acc1)
    beforeMintDevWalletBanalce = mtdContract._wallet(acc1)
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2009,1,1,{"from":acc1})
        
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2023,1,1,{"from":acc1})
    
    tx = mtdContract.MemorizeThisDay(2010,1,1,{"from":acc1})
    
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2010,1,1,{"from":acc1})
    
    afterMintMintedDays = mtdContract.GetMintedDaysLength()
    afterMintGiftCount = mtdContract._airdrop(acc1)
    afterMintDevWalletBanalce = mtdContract._wallet(acc1)
    
    orginalMinter = mtdContract._orginalMinter(mtdContract.GetIdByDate(2010,1,1))
    
    # Assert
    assert (beforMintMintedDays+1)==afterMintMintedDays
    assert (beforeMintGiftCount-1)==afterMintGiftCount
    assert beforeMintDevWalletBanalce==afterMintDevWalletBanalce
    assert acc1.address==orginalMinter

def test_MemorizeThisDay_with_mint_price(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    acc2 = get_account(1)
    acc3 = get_account(2)
    acc4 = get_account(3)
    acc5 = get_account(4)
    acc6 = get_account(5)
    acc7 = get_account(6)
    acc8 = get_account(7)
    acc9 = get_account(8)
    acc10 = get_account(9)
    
    initMintPrice=mtdContract._mintPrice()
    mintPrice=mtdContract._mintPrice() + 1
    # Act
    mtdContract.SetMoralisTeamAddress(acc7.address,True,{"from":acc1})
    mtdContract.SetPatrickCollinsAddress(acc8.address,True,{"from":acc1})
    mtdContract.SetSecondInfluencerAddress(acc9.address,True,{"from":acc1})
    mtdContract.SetFirstInfluencerAddress(acc10.address,True,{"from":acc1})
    
    beforMintMintedDays = mtdContract.GetMintedDaysLength()

    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2009,1,1,{"from":acc1})
        
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2023,1,1,{"from":acc1})
    
    #use account 2 because of acc1 has gifts
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2010,1,1,{"from":acc2})
    
     #use account 2 because of acc1 has gifts
    tx = mtdContract.MemorizeThisDay(2010,1,1,{"from":acc2,"value":mintPrice})
    
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.MemorizeThisDay(2010,1,1,{"from":acc1})
    
    
    
    afterMintMintedDays = mtdContract.GetMintedDaysLength()

    orginalMinter = mtdContract._orginalMinter(mtdContract.GetIdByDate(2010,1,1))
    
    moralisCommunityShareExpected = 1000000000000000
    moralisCommunityShareActual = mtdContract._wallet(mtdContract._moralisCommunityAddress())
    
    patrickCollinsShareExpected = 1000000000000000
    patrickCollinsShareActual = mtdContract._wallet(mtdContract._patrickCollinsAddress()) 
    
    firstInfluencerShareExpected = 1000000000000000
    firstInfluencerShareActual = mtdContract._wallet(mtdContract._firstInfluencerAddress())
    
    secondInfluencerShareExpected = 1000000000000000
    secondInfluencerShareActual = mtdContract._wallet(mtdContract._secondInfluencerAddress())
    
    # +2500000000000000 for first mint only
    developerTeamShareShareExpected = 3400000000000000 + 2500000000000000
    developerTeamShareShareActual = mtdContract._wallet(mtdContract._developerTeamShareAddress())
    
    #smartContractShareActual = mtdContract._wallet(mtdContract.address)
    
    # Assert
    assert (beforMintMintedDays+1)==afterMintMintedDays
    assert acc2.address==orginalMinter
    assert mintPrice == 10000000000000001
    assert moralisCommunityShareExpected == moralisCommunityShareActual
    assert patrickCollinsShareExpected == patrickCollinsShareActual
    assert firstInfluencerShareExpected == firstInfluencerShareActual
    assert secondInfluencerShareExpected == secondInfluencerShareActual
    assert developerTeamShareShareExpected == developerTeamShareShareActual
    #assert smartContractShareActual == 0
    
    # Act
    
    with pytest.raises(exceptions.VirtualMachineError): 
        tx = mtdContract.MemorizeThisDay(2010,1,1,{"from":acc2,"value":mintPrice})
    
    #feburay doesnt have 31 days 
    with pytest.raises(exceptions.VirtualMachineError): 
        tx = mtdContract.MemorizeThisDay(2010,1,32,{"from":acc2,"value":mintPrice})
        tx = mtdContract.MemorizeThisDay(2010,13,1,{"from":acc2,"value":mintPrice})
        tx = mtdContract.MemorizeThisDay(2010,1,0,{"from":acc2,"value":mintPrice})
        tx = mtdContract.MemorizeThisDay(2010,0,1,{"from":acc2,"value":mintPrice})
        tx = mtdContract.MemorizeThisDay(2010,2,30,{"from":acc2,"value":mintPrice})        
        tx = mtdContract.MemorizeThisDay(2010,2,29,{"from":acc2,"value":mintPrice})   
    
    beforMintMintedDays = mtdContract.GetMintedDaysLength()
    
    NUM_OF_MINTS=5
    dt = datetime(2010, 1, 1, 0, 0,0)
    for Nmint in range(1, NUM_OF_MINTS):
        if Nmint % 365 == 0:
            mintPrice = mintPrice * 2
            
        dt += timedelta(days=1)  
        
        moralisCommunityShareExpected = mtdContract._wallet(mtdContract._moralisCommunityAddress()) + (mintPrice * mtdContract.MORALIS_COMMUNITY_MINT_SHARE() / 100)
        patrickCollinsShareExpected = mtdContract._wallet(mtdContract._patrickCollinsAddress()) + (mintPrice * mtdContract.PATRICK_COLLINS_MINT_SHARE() / 100)
        firstInfluencerShareExpected = mtdContract._wallet(mtdContract._firstInfluencerAddress()) + (mintPrice * mtdContract.FIRST_INFLUENCER_MINT_SHARE() / 100)
        secondInfluencerShareExpected = mtdContract._wallet(mtdContract._secondInfluencerAddress()) + (mintPrice * mtdContract.SECOND_INFLUENCER_MINT_SHARE() / 100)
        developerTeamShareShareExpected = mtdContract._wallet(mtdContract._developerTeamShareAddress()) + (mintPrice * mtdContract.DEVELOPERS_TEAM_MINT_SHARE() / 100) 
        
        tx = mtdContract.MemorizeThisDay(dt.year,dt.month,dt.day,{"from":acc2,"value":mintPrice})
        
        moralisCommunityShareActual = mtdContract._wallet(mtdContract._moralisCommunityAddress())
        patrickCollinsShareActual = mtdContract._wallet(mtdContract._patrickCollinsAddress()) 
        firstInfluencerShareActual = mtdContract._wallet(mtdContract._firstInfluencerAddress())
        secondInfluencerShareActual = mtdContract._wallet(mtdContract._secondInfluencerAddress())
        developerTeamShareShareActual = mtdContract._wallet(mtdContract._developerTeamShareAddress())
        
        # Assert
        assert moralisCommunityShareExpected == moralisCommunityShareActual
        assert patrickCollinsShareExpected == patrickCollinsShareActual
        assert firstInfluencerShareExpected == firstInfluencerShareActual
        assert secondInfluencerShareExpected == secondInfluencerShareActual
        assert developerTeamShareShareExpected == developerTeamShareShareActual
    
    afterMintMintedDays = mtdContract.GetMintedDaysLength()
    
    assert beforMintMintedDays+NUM_OF_MINTS-1==afterMintMintedDays

def test_HoldersShare(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    acc2 = get_account(1)
    acc3 = get_account(2)
    acc4 = get_account(3)
    acc5 = get_account(4)
    acc6 = get_account(5)
    acc7 = get_account(6)
    acc8 = get_account(7)
    acc9 = get_account(8)
    acc10 = get_account(9)
    
    initMintPrice=mtdContract._mintPrice()
    mintPrice=mtdContract._mintPrice() # + 100000
    # Act
    tx = mtdContract.MemorizeThisDay(2010,1,1,{"from":acc2,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,2,{"from":acc3,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,3,{"from":acc4,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,4,{"from":acc5,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,5,{"from":acc6,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,6,{"from":acc6,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,7,{"from":acc6,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,8,{"from":acc6,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,9,{"from":acc6,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,10,{"from":acc7,"value":mintPrice})
    
    totalAmountForShare=mtdContract.GetHoldersShareBalance()
    eachshare = totalAmountForShare / mtdContract.GetMintedDaysLength()
    acc2BalanceExpected = mtdContract._wallet(acc2.address) + eachshare 
    acc3BalanceExpected = mtdContract._wallet(acc3.address) + eachshare 
    acc4BalanceExpected = mtdContract._wallet(acc4.address) + eachshare 
    acc5BalanceExpected = mtdContract._wallet(acc5.address) + eachshare 
    acc6BalanceExpected = mtdContract._wallet(acc6.address) + (eachshare * 5) 
    
    tx = mtdContract.DistributeHoldersShare({"from":acc8})
    
    # Assert
    assert acc2BalanceExpected == mtdContract._wallet(acc2.address)
    assert acc3BalanceExpected == mtdContract._wallet(acc3.address)
    assert acc4BalanceExpected == mtdContract._wallet(acc4.address)
    assert acc5BalanceExpected == mtdContract._wallet(acc5.address)
    assert acc6BalanceExpected == mtdContract._wallet(acc6.address)
         
#passes min balance
def test_Withdrawal(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1=get_account(0)
    acc2=get_account(1)
    mintPrice=mtdContract._mintPrice()
    # Act
    tx = mtdContract.MemorizeThisDay(2010,1,1,{"from":acc1,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,2,{"from":acc1,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,3,{"from":acc1,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,4,{"from":acc1,"value":mintPrice})
    tx = mtdContract.MemorizeThisDay(2010,1,5,{"from":acc2,"value":mintPrice})
    
    beforeWithdrawalBalance= acc1.balance()
    beforeWithdrawalWallet= mtdContract._wallet(acc1.address)
    mtdContract.Withdrawal({"from":acc1})
    afterWithdrawalBalance = acc1.balance()
    afterWithdrawalWallet= mtdContract._wallet(acc1.address)
    
    # Assert
    assert beforeWithdrawalBalance+beforeWithdrawalWallet== afterWithdrawalBalance
    assert afterWithdrawalWallet==0

def test_PlaceSellOrder(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    test_MemorizeThisDay_with_mint_price(mtdContract)
    holderAccount=get_account(1)
    pentestAccount=get_account(3)
    
    # Assert
    assert mtdContract.GetOrderBookLength()==0
    assert mtdContract._orderBookDetails(mtdContract.GetIdByDate(2010,1,1)) == 0
    
    # Act
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.PlaceSellOrder(2010,1,1,Web3.toWei(0.1,"ether"),{"from":pentestAccount}) #you dont have this day
    
    mtdContract.PlaceSellOrder(2010,1,1,Web3.toWei(0.1,"ether"),{"from":holderAccount})
    
    # Assert
    assert mtdContract.GetOrderBookLength()==1
    assert mtdContract._orderBookDetails(mtdContract.GetIdByDate(2010,1,1)) != 0
    
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.PlaceSellOrder(2010,1,1,Web3.toWei(0.1,"ether"),{"from":holderAccount})
    
def test_CancelOrder(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    test_PlaceSellOrder(mtdContract)
    holderAccount=get_account(1)
    pentestAccount=get_account(3)
    
    # Assert
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,1)) == holderAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,2)) == holderAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,3)) == holderAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,4)) == holderAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,5)) == holderAccount.address
    
    # Act
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.CancelOrder(2010,1,1,{"from":pentestAccount}) # you dont have this day
        
    mtdContract.CancelOrder(2010,1,1,{"from":holderAccount}) #cancel order done
    
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.CancelOrder(2010,1,1,{"from":holderAccount}) # this day is not exist on orderbook
    
    # Assert
    assert mtdContract.GetOrderBookLength()==0
    assert mtdContract._orderBookDetails(mtdContract.GetIdByDate(2010,1,1))==0

def test_BuyTheDay(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    test_PlaceSellOrder(mtdContract)
    holderAccount=get_account(1)
    buyerAccount=get_account(3)
    # Assert
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,1)) == holderAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,1)) != buyerAccount.address
    
    # Act
    buyPrice = mtdContract._orderBookDetails(mtdContract.GetIdByDate(2010,1,1))
    assert buyPrice == Web3.toWei(0.1,"ether")
    
    with pytest.raises(exceptions.VirtualMachineError): 
        mtdContract.BuyTheDay(2010,1,10,{"from":buyerAccount})#this day is not exist on orderbook
        mtdContract.BuyTheDay(2010,1,1,{"from":holderAccount})# you are the owner of this Day
        mtdContract.BuyTheDay(2010,1,1,{"from":buyerAccount})# Not enough funds to buy this day
    
    mtdContract.BuyTheDay(2010,1,1,{"from":buyerAccount,"value":buyPrice})
    # Assert
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,1))==buyerAccount.address
    assert mtdContract._holders(mtdContract.GetIdByDate(2010,1,1))!=holderAccount.address
    assert mtdContract.GetOrderBookLength()==0
    assert mtdContract._orderBookDetails(mtdContract.GetIdByDate(2010,1,1))==0

def test_SelectPeriodicWinner_emptylist(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    lastPeriodWinnerSelectDate = mtdContract._lastPeriodWinnerSelectDate()
    giftPeriodInDays = mtdContract._airdropPeriodInDays()
    # Act
    with pytest.raises(exceptions.VirtualMachineError):
            mtdContract.SelectPeriodicWinner({"from":acc1})
    #.replace(tzinfo=timezone.utc)
    currentDatetime = datetime.fromtimestamp(chain.time())
    diffDays=(currentDatetime - datetime.fromtimestamp(lastPeriodWinnerSelectDate)).days
    print(f"diffDays : {diffDays}")
    if diffDays < giftPeriodInDays:
        with pytest.raises(exceptions.VirtualMachineError):
            mtdContract.SelectPeriodicWinner({"from":acc1})
            
    while (currentDatetime - datetime.fromtimestamp(lastPeriodWinnerSelectDate)).days <= giftPeriodInDays:
        currentDatetime = datetime.fromtimestamp(chain.time())
        chain.sleep(44000)
        #chain.mine(1000)
    
    with pytest.raises(exceptions.VirtualMachineError):           
        mtdContract.SelectPeriodicWinner({"from":acc1})
    # Assert
    pass
        

def test_SelectPeriodicWinner_with_registers(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    lastPeriodWinnerSelectDate = mtdContract._lastPeriodWinnerSelectDate()
    giftPeriodInDays = mtdContract._airdropPeriodInDays()
    acc1 = get_account(0)
    acc2 = get_account(1)
    acc3 = get_account(2)
    acc4 = get_account(3)
    acc5 = get_account(4)
    acc6 = get_account(5)
    acc7 = get_account(6)
    acc8 = get_account(7)
    acc9 = get_account(8)
    acc10 = get_account(9)
    # Act
    fund_with_link(mtdContract.address)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc1})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc2})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc3})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc4})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc5})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc6})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc7})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc8})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc9})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc10})
    tx.wait(1)
    
    assert mtdContract.GetPeriodicGiftRegistersLength() == 10
    
    with pytest.raises(exceptions.VirtualMachineError):
            mtdContract.SelectPeriodicWinner({"from":acc1})
    currentDatetime = datetime.fromtimestamp(chain.time())
    diffDays=(currentDatetime - datetime.fromtimestamp(lastPeriodWinnerSelectDate)).days

    if diffDays < giftPeriodInDays:
        with pytest.raises(exceptions.VirtualMachineError):
            mtdContract.SelectPeriodicWinner({"from":acc1})
            
    while (currentDatetime - datetime.fromtimestamp(lastPeriodWinnerSelectDate)).days <= giftPeriodInDays:
        currentDatetime = datetime.fromtimestamp(chain.time())
        chain.sleep(44000)
        #chain.mine(1000)
    
    tx = mtdContract.SelectPeriodicWinner({"from":acc1})
    requestId = tx.events["RequestedRandomness"]["requestId"]
    STATIC_RNG = 777
    beforeWinGiftCount = mtdContract._airdrop(acc8)
    tx = get_contract("vrf_coordinator").callBackWithRandomness(requestId,STATIC_RNG,mtdContract.address,{"from":acc1})
    tx.wait(1)
    afterWinGiftCount = mtdContract._airdrop(acc8)
    # Assert
    assert (beforeWinGiftCount+1) == afterWinGiftCount
        

def test_RegisterForPeriodicGift(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1 = get_account(0)
    acc2 = get_account(1)
    acc3 = get_account(2)
    acc4 = get_account(3)
    acc5 = get_account(4)
    acc6 = get_account(5)
    acc7 = get_account(6)
    acc8 = get_account(7)
    acc9 = get_account(8)
    acc10 = get_account(9)
    # Act
    expected_register_count = 0
    actual_register_count = mtdContract.GetPeriodicGiftRegistersLength()
    # Assert
    assert expected_register_count == actual_register_count
    
    # Act
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc1})
    tx.wait(1)
    expected_register_count = 1
    actual_register_count = mtdContract.GetPeriodicGiftRegistersLength()
    # Assert
    assert expected_register_count == actual_register_count
    
    # Act
    with pytest.raises(exceptions.VirtualMachineError):
        tx = mtdContract.RegisterForPeriodiclyGift({"from":acc1})        
    expected_register_count = 1
    actual_register_count = mtdContract.GetPeriodicGiftRegistersLength()
    # Assert
    assert expected_register_count == actual_register_count
    
    # Act
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc2})
    tx.wait(1)
    expected_register_count = 2
    actual_register_count = mtdContract.GetPeriodicGiftRegistersLength()
    # Assert
    assert expected_register_count == actual_register_count
    
     # Act
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc3})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc4})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc5})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc6})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc7})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc8})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc9})
    tx.wait(1)
    tx = mtdContract.RegisterForPeriodiclyGift({"from":acc10})
    tx.wait(1)
    expected_register_count = 10
    actual_register_count = mtdContract.GetPeriodicGiftRegistersLength()
    # Assert
    assert expected_register_count == actual_register_count
        

def test_safeTransferFrom(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    # Assert
    pass

def test_safeBatchTransferFrom(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    # Assert
    pass

def test_IsDayNumberValidForMinting(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    acc1=get_account(0)
    # Act
    # Assert
    assert mtdContract.IsDayNumberValidForMinting(mtdContract.GetIdByDate(2010,1,1))==True
    assert mtdContract.IsDayNumberValidForMinting(mtdContract.GetIdByDate(2009,12,30))==False
    assert mtdContract.IsDayNumberValidForMinting(mtdContract.GetIdByDate(2023,1,1))==False
    

def test_PauseContract(mtdContract=None):
    
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    mtdContract.PauseContract({"from":get_account()})
    
    with pytest.raises(exceptions.VirtualMachineError):
        test_MemorizeThisDay_with_airdrop(mtdContract)
    # Assert
    pass

def test_UnPauseContract(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    test_PauseContract(mtdContract)
    mtdContract.UnPauseContract({"from":get_account()})
    test_MemorizeThisDay_with_airdrop(mtdContract)
    # Assert
    pass

def test_SmartContractFee_Withdrawal(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    # Assert
    pass

def test_UpdateChainlinkFee(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    beforeFee=mtdContract._chainlinkFee()
    mtdContract.UpdateChainlinkFee(10000,{"from":get_account()})
    afterFee=mtdContract._chainlinkFee()
    # Assert
    assert beforeFee==100000000000000000
    assert afterFee==10000

def test_SetMoralisTeamAddress_with_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._moralisCommunityAddress())!=0
    
    # Act
    oldAddress = mtdContract._moralisCommunityAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._moralisCommunityAddress())
    mtdContract.SetMoralisTeamAddress(newAddress,False,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == 0
    assert mtdContract._moralisCommunityAddress() == newAddress.address
    
    
def test_SetMoralisTeamAddress_without_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._moralisCommunityAddress())!=0
    
    # Act
    oldAddress = mtdContract._moralisCommunityAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._moralisCommunityAddress())
    mtdContract.SetMoralisTeamAddress(newAddress,True,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == oldAddressBalance
    assert mtdContract._moralisCommunityAddress() == newAddress.address
    

def test_SetPatrickCollinsAddress_with_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._patrickCollinsAddress())!=0
    
    # Act
    oldAddress = mtdContract._patrickCollinsAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._patrickCollinsAddress())
    mtdContract.SetPatrickCollinsAddress(newAddress,False,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == 0
    assert mtdContract._patrickCollinsAddress() == newAddress.address
    
    
def test_SetPatrickCollinsAddress_without_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._patrickCollinsAddress())!=0
    
    # Act
    oldAddress = mtdContract._patrickCollinsAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._patrickCollinsAddress())
    mtdContract.SetPatrickCollinsAddress(newAddress,True,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == oldAddressBalance
    assert mtdContract._patrickCollinsAddress() == newAddress.address
    

def test_SetSecondInfluencerAddress_with_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._secondInfluencerAddress())!=0
    
    # Act
    oldAddress = mtdContract._secondInfluencerAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._secondInfluencerAddress())
    mtdContract.SetSecondInfluencerAddress(newAddress,False,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == 0
    assert mtdContract._secondInfluencerAddress() == newAddress.address
    
    
def test_SetSecondInfluencerAddress_without_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._secondInfluencerAddress())!=0
    
    # Act
    oldAddress = mtdContract._secondInfluencerAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._secondInfluencerAddress())
    mtdContract.SetSecondInfluencerAddress(newAddress,True,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == oldAddressBalance
    assert mtdContract._secondInfluencerAddress() == newAddress.address
    

def test_SetFirstInfluencerAddress_with_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._firstInfluencerAddress())!=0
    
    # Act
    oldAddress = mtdContract._firstInfluencerAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._firstInfluencerAddress())
    mtdContract.SetFirstInfluencerAddress(newAddress,False,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == 0
    assert mtdContract._firstInfluencerAddress() == newAddress.address
    
    
def test_SetFirstInfluencerAddress_without_preserve(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._firstInfluencerAddress())!=0
    
    # Act
    oldAddress = mtdContract._firstInfluencerAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._firstInfluencerAddress())
    mtdContract.SetFirstInfluencerAddress(newAddress,True,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == oldAddressBalance
    assert mtdContract._firstInfluencerAddress() == newAddress.address
    
    
def test_SetDeveloperTeamShareAddress(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    newAddress=get_account(5)
    # Act
    test_MemorizeThisDay_with_mint_price(mtdContract)
    # Assert
    assert mtdContract._wallet(mtdContract._developerTeamShareAddress())!=0
    
    # Act
    oldAddress = mtdContract._developerTeamShareAddress()
    oldAddressBalance=mtdContract._wallet(mtdContract._developerTeamShareAddress())
    mtdContract.SetDeveloperTeamShareAddress(newAddress,{"from":get_account()})
    # Assert
    assert mtdContract._wallet(oldAddress) == 0
    assert mtdContract._wallet(newAddress) == oldAddressBalance
    assert mtdContract._developerTeamShareAddress() == newAddress.address
    
def test_Adjustments(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    # Act
    beforeMintingPrice= mtdContract._mintPrice()
    beforeGiftPeriodInDays= mtdContract._airdropPeriodInDays()
    mint(1050,mtdContract)
    afterMintingPrice= mtdContract._mintPrice()
    afterGiftPeriodInDays= mtdContract._airdropPeriodInDays()
    # Asset
    assert beforeGiftPeriodInDays==7
    assert afterGiftPeriodInDays==30
    assert beforeMintingPrice==Web3.toWei(0.01,"ether")
    assert afterMintingPrice==Web3.toWei(0.04,"ether")
    

def mint(num,mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    
    # Arrange
    NUM_OF_MINTS=num
    dt = datetime(2010, 1, 1, 0, 0,0)
    
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    mintPrice= mtdContract._mintPrice()
    
    # Act    
    for Nmint in range(1, NUM_OF_MINTS):
        if Nmint % 365 == 0:
            mintPrice = mintPrice * 2
        dt += timedelta(days=1)  
        tx = mtdContract.MemorizeThisDay(dt.year,dt.month,dt.day,{"from":get_account(1),"value":mintPrice})

def test_WithdrawalSmartContractFee(mtdContract=None):
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
       pytest.skip()
    # Arrange
    mtdContract= mtdContract if mtdContract else deploy_BTC()
    mint(101,mtdContract)
    accWithdrawal=get_account(0)
    # Act
    smartContractBalance=mtdContract._wallet(mtdContract.address)
    accWithdrawalBeforeBalance=accWithdrawal.balance()
    mtdContract.WithdrawalSmartContractFee({"from":accWithdrawal})
    accWithdrawalAfterBalance=accWithdrawal.balance()
    # Assert
    assert smartContractBalance==Web3.toWei(0.01,"ether")
    assert accWithdrawalBeforeBalance+ smartContractBalance==accWithdrawalAfterBalance