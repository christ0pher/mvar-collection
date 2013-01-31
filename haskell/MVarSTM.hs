module MVar where

import Control.Concurrent.STM
import Control.Concurrent (forkIO)
import Control.Monad (liftM)
import System.IO

data MVar a = MVar (TVar (Maybe a))
  deriving Eq


newEmptyMVar :: STM (MVar a)
newEmptyMVar = do {
  t <- newTVar Nothing;
  return (MVar t)
  }

newMVar :: a -> STM (MVar a)
newMVar v =  do {
  t <- newTVar (Just v);
  return (MVar t)
  }

takeMVar :: MVar a -> STM a
takeMVar (MVar t) = do {
  mv <- readTVar t;
  case mv of
    Nothing -> retry;
    Just x  -> do {
      writeTVar t Nothing;
      return x}
  } 

putMVar :: MVar a -> a -> STM ()
putMVar (MVar t) v = do {
  mv <- readTVar t;
  case mv of
    Just _  -> retry;
    Nothing -> writeTVar t (Just v)
  }

readMVar :: MVar a -> STM a
readMVar m = do {
  v <- takeMVar m;
  putMVar m v;
  return v}

runner mvar = do
	forkIO $ do 
		atomically(do
			putMVar mvar "Hallo"
			takeMVar mvar
			putMVar mvar "Bloed")
	forkIO $ do  
			mv <- atomically $ takeMVar mvar
			print mv
	forkIO $ do 
		atomically(do
			putMVar mvar "Hallo"
			takeMVar mvar
			putMVar mvar "Bloed")
		
	forkIO $ do
		atomically(do
			putMVar mvar "bloaed2"
			takeMVar mvar
			return ())
	runner mvar

main = do
	mvar <- atomically newEmptyMVar
	runner mvar


