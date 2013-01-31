module AccountSTM where

import Control.Concurrent.STM

type Account = TVar Int

newAccount :: STM Account
newAccount = do
	newTVar 0
	
getBalance :: Account -> STM Int
getBalance acc = do
	readTVar acc
	
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

collectedLimitedTransfer :: [Account] -> Account -> Int -> STM Bool
collectedLimitedTransfer [] _ _ =
	return False
collectedLimitedTransfer (headAcc:accs) to am = do
	bal <- getBalance headAcc
	if bal >= am then do
		transfer headAcc to am
		return True
	else do
		res <- collectedLimitedTransfer accs to (am - (max bal 0))
		if res == True then do
			transfer headAcc to (max bal 0)
			return True
		else do
			return False
	
		
main = do
	acc1 <- atomically(newAccount)
	acc2 <- atomically(newAccount)
	acc3 <- atomically (newAccount)
	atomically (do deposit acc1 100; transfer acc1 acc2 500)
	bool <- atomically (limitedWithdraw acc1 600)
	-- acc1 -400
	-- acc2 500
	-- acc3 0
	bal1 <- atomically (getBalance acc1)
	bal2 <- atomically (getBalance acc2)	
	let fromList = [acc1, acc2, acc1]
	transferSuccess <- atomically(collectedLimitedTransfer fromList acc3 501)

	bal3 <- atomically (getBalance acc3)	

	
	putStrLn ("Transfer: " ++ show transferSuccess)
	print bal1
	print bal2
	print bal3