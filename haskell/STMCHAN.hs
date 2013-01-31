module ChanSTM where

import Control.Concurrent.STM
import Control.Monad (lift)

data LChan a = LChan (TVar [a])


newEmptyChan :: STM (LChan a)
newEmptyChan = do
	newEmpty <- newTVar []
	return $ LChan newEmpty

writeChan :: LChan a -> a -> STM ()
writeChan (LChan chan) val = do
	list <- readTVar chan
	if null list then do
		writeTVar chan [val]
	else
		writeTVar chan ([val]++list)
		

readChan :: LChan a -> STM a
readChan (LChan chan) = do
	list <- readTVar chan
	list17 <- lift (reverse list)
	list1 <- do 
		lt <- newTVar $ reverse list
		readTVar lt
	if null list then
		retry
	else do
		list2 <- do
			lt2 <- newTVar $ reverse (tail list1)
			lt3 <- readTVar lt2
			writeTVar chan lt3
		return $ head list1
		
