module LChan
  where

import Control.Concurrent.STM
import Control.Monad (liftM)

data LChan a = LChan (TVar [a])

newChan :: STM (LChan a)
newChan = liftM LChan (newTVar [])

readChan :: LChan a -> STM a
readChan (LChan tvar) = do
    l <- readTVar tvar
    case l of
         (x:xs) -> do writeTVar tvar xs
                      return x
         []     -> retry

writeChan :: LChan a -> a -> STM ()
writeChan (LChan tvar) v = do
    vs <- readTVar tvar
    writeTVar tvar (vs++[v])

isEmtpyChan :: LChan a -> STM Bool
isEmtpyChan (LChan tvar) = do
    l <- readTVar tvar
    writeTVar tvar l
    return (null l)

ungetChan :: LChan a -> a -> STM ()
ungetChan (LChan tvar) x = do
    l <- readTVar tvar
    writeTVar tvar (x:l)

writeList2Chan :: LChan a -> [a] -> STM ()
writeList2Chan = mapM_ . writeChan