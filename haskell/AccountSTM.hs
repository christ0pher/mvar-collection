module AccountSTM where

import Control.Concurrent.STM

type Account = TVar Int

newAccount :: STM Account
newAccount = do
	newTVar 0
	
getBalance :: Account -> STM Int
getBalance acc = do
	readTvar acc
	
deposit :: Account -> Int -> STM ()
deposit acc amount = do
	bal <- getBalance acc
	writeTVar acc (bal+amount)
	
withdraw :: Account -> Int -> STM ()
withdraw acc amount = deposit acc (-amount)

transfer :: Account -> Account -> Int -> STM ()
transfer from to amount = do
	withdraw from amount
	-- Inconsistent state, visible!
	deposit to amount
	
limitedWithdraw :: Account -> Int -> STM Bool
limitedWithdraw acc amount = do
	bal <- getBalance acc
	if bal >= amount then do
		withdraw acc amount
		return True
	else do
		return False

main = do
	acc1 <- newAccount
	acc2 <- newAccount
	atomically (do deposit acc1 100
					transfer acc1 acc2 500)
	bool <- atomically (limitedWithdraw acc1 600)
	bal1 <- atomically (getBalance acc1)
	bal2 <- atomically (getBalance acc2)
	print bal1
	print bal2
