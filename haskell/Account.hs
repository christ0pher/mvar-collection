module Account where

import Control.Concurrent
import Control.Monad

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

transfer :: Account -> Account -> Int -> IO ()
transfer from to amount = do
	withdraw from amount
	deposit to amount
		
limitedWithdraw :: Account -> Int -> IO Bool
limitedWithdraw acc amount = do
	bal <- takeMVar acc
	if bal >= amount then do
		putMVar acc (bal-amount)
		return True
	else do
		putMVar acc bal
		return False
		
collectedLimitedTransfer :: [Account] -> Account -> Int -> IO Bool
collectedLimitedTransfer [] _ _ = do
	return False
collectedLimitedTransfer (headAcc:restAccs) toAcc amount = do
	-- Hole Geld vom ersten Konto
	balanceHead <- takeMVar headAcc
	-- wenn Kontostand > Überweisungswert
	if balanceHead >= amount then do
		-- Überweise Geld und collected hat geklappt
		--transfer1 headAcc toAcc amount
		deposit toAcc amount
		putMVar headAcc (balanceHead-amount)
		return True
	else do
		-- Buche Beträge der anderen Konten ab
		result <- collectedLimitedTransfer restAccs toAcc (amount-(max balanceHead 0))
		-- hat Collected geklappt
		if result == True then do
			-- Buche Betrag ab
			deposit toAcc (max balanceHead 0)
			putMVar headAcc 0
			return True
		else do
			putMVar headAcc balanceHead
			return False
			
main :: IO ()
main = do
	to <- newAccount
	from1 <- newAccount
	deposit from1 100
	from2 <- newAccount
	deposit from2 100
	from3 <- newAccount
	deposit from3 100
	from4 <- newAccount
	deposit from4 100
	from5 <- newAccount
	deposit from5 100
	from6 <- newAccount
	deposit from6 100
	from7 <- newAccount
	deposit from7 100
	from8 <- newAccount
	deposit from8 100
	from9 <- newAccount
	deposit from9 100
	from10 <- newAccount
	deposit from10 100
	from11 <- newAccount
	deposit from11 100
	from12 <- newAccount
	deposit from12 100
	--   takeMVar from2

	let fromList = [from1,from2,from3,from4,from5,from6,from7,from8,from9,from10,from11,from12]
	transferSuccess <- collectedLimitedTransfer fromList to 1200

	putStrLn ("Transfer: " ++ show transferSuccess)

	--   putMVar from2 100

	balTo <- getBalance to
	balFrom1 <- getBalance from1
	putStrLn (show balTo)
	mapM_ (putStrLn . show <=< getBalance) fromList
