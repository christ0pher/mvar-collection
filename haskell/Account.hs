module Account where

import Control.Concurrent

type Account = MVar Int

newAccount :: IO Account
newAccount = do
	newMVar 0
	
	
getBalance :: Account -> IO Int
getBalance acc = do
	readMVar acc

deposit	:: Account -> Int -> IO()
deposit acc amount = do
	bal <- takeMVar acc
	putMVar acc (bal+amount)

withdraw :: Account -> Int -> IO ()
withdraw acc amount = deposit acc (-amount)

transfer0 :: Account -> Account -> Int -> IO ()
transfer0 from to amount = do
	putMVar from amount
	-- Inconsistent state, visible!
	deposit to amount

transfer1 :: Account -> Account -> Int -> IO ()
transfer1 from to amount = do
	fromBal <- takeMVar from
	toBal <- takeMVar to
	putMVar from (fromBal-amount)
	-- Inconsistnent state, not visible!
	putMVar to (toBal+amount)
	-- But two philosophers, it transfer a b || transfer b a =< Deadlock
	
transfer2 :: Account -> Account -> Int -> IO ()
transfer2 from to amount = do
	-- test of address, this doesnt work!!!
	if from < to then do
		fromBal <- takeMVar from
		toBal <- takeMVar to
		putMVar from (fromBal-amount)
		putMVar to (toBal+amount)
	else if from == to then do
			return ()
		else do
			toBal <- takeMVar to
			fromBal <- takeMVar from
			putMVar from (fromBal-amount)
			putMVar to (toBal+amount)
	
limitedWithdraw0 :: Account -> Int -> IO Bool
limitedWithdraw0 acc amount = do
	bal <- getBalance acc
	-- it is not thread save, balance can be modified by other
	if bal >= amount then do
		putMVar acc amount
		return True
	else
		return False
		
limitedWithdraw1 :: Account -> Int -> IO Bool
limitedWithdraw1 acc amount = do
	bal <- takeMVar acc
	if bal >= amount then do
		putMVar acc (bal-amount)
		return True
	else do
		putMVar acc bal
		return False
		
collectedLimitedTransfer :: [Account] -> Account -> Int -> IO Bool
collectedLimitedTransfer (headAcc:restAccs) toAcc amount = do
	balanceHead <- getBalance headAcc
	
