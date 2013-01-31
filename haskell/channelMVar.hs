-- channel.hs
import Control.Concurrent.MVar
import Test.HUnit

data Chan a = Chan (MVar (Stream a)) (MVar (Stream a))

type Stream a = MVar (ChanElem a)

data ChanElem a = ChanElem a (Stream a)

newChan :: IO (Chan a)
newChan = do
	empty <- newEmptyMVar
	r 		<- newMVar empty
	w 		<- newMVar empty
	return $ Chan r w

readChan :: Chan a -> IO a
readChan (Chan r _) = do
	rEnd 		<- takeMVar r
	ChanElem v n 	<- takeMVar rEnd
	putMVar r n
	return v

writeChan :: Chan a -> a -> IO ()
writeChan (Chan _ w) v = do
	wEnd 		<- takeMVar w
	newEmpty 	<- newEmptyMVar
	putMVar wEnd (ChanElem v newEmpty)
	putMVar w newEmpty

isEmptyChan :: Chan a -> IO Bool
isEmptyChan (Chan r _) = do
	rEnd <- takeMVar r
	isEmpty <- isEmptyMVar rEnd
	putMVar r rEnd
	return isEmpty

-- maybe other values will be interleaved by other writers
writeList2Chan :: Chan a -> [a] -> IO ()
writeList2Chan ch = mapM_ (writeChan ch)

ungetChan :: Chan a -> a -> IO ()
ungetChan (Chan r _) v = do
	rEnd <- takeMVar r
	newREnd <- newEmptyMVar
	putMVar newREnd (ChanElem v rEnd)
	putMVar r newREnd
