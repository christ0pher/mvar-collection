import Control.Concurrent (forkIO)
import Control.Concurrent.STM

type Stick = TVar Bool

newStick :: STM Stick
newStick = newTVar True

takeStick :: Stick -> STM ()
takeStick stick = do
	available <- readTVar stick
	if available then
		writeTVar stick False
	else
		retry

putStick :: Stick -> STM ()
putStick stick = writeTVar stick True


main :: IO ()
main = do
	sticks <- builtSticks 5
	startPhils 1 sticks
	phil 0 (last sticks) (head sticks)
	
builtSticks :: Int -> IO [Stick]
builtSticks 0 = return []
builtSticks n = do
	stick <- atomically newStick
	sticks <- builtSticks (n-1)
	return (stick:sticks)
	
startPhils :: Int -> [Stick] -> IO ()
startPhils n (l:r:sticks) = do
	forkIO (phil n l r)
	startPhils (n+1) (r:sticks)
startPhils _ _ = return ()

phil :: Int -> Stick -> Stick -> IO ()
phil n l r = do
	atomically (do
		takeStick l
		takeStick r)
	putStrLn (show n++" eats")
	atomically (putStick l)
	atomically (putStick r)
	phil n l r
