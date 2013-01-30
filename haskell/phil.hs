module Main where

import Control.Concurrent

main :: IO ()
main = startPhil 5

startPhil :: Int -> IO ()
startPhil n = do
  sticks <- mapM (const (newMVar ())) [1..n]
  mapM_ (\ (n,(l,r)) -> forkIO (phil n l r))
        (zip [1..] (zip sticks (tail sticks)))
  phil 0 (last sticks) (head sticks)

phil :: Int -> MVar () -> MVar () -> IO ()
phil n l r = do
  takeMVar l
  fork <- tryTakeMVar r
  case fork of
	Nothing -> do
		putMVar l ()
		phil n l r 
	_ -> print n
  -- eat
  putMVar l ()
  putMVar r ()
  phil n l r
