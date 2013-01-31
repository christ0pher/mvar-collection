import Control.Concurrent(forkIO, killThread)
import Control.Concurrent.Chan
import Test.HUnit
import System.Timeout
import Data.Maybe(isJust)

twoSeconds :: Int
twoSeconds = 2 * 10 ^ 6

testIsEmptyChan :: Test
testIsEmptyChan = TestCase (do
	ch <- newChan
	rPid <- forkIO $ do
		_ <- readChan ch
		return ()
	maybeEmpty <- timeout twoSeconds $ isEmptyChan ch
	assertBool "deadlock" (isJust maybeEmpty)
	killThread rPid
	)
	
testWriteList2Chan :: Test
testWriteList2Chan = undefined -- ??

testUngetChan :: Test
testUngetChan = TestCase (do
	ch <- newChan
	rPid <- forkIO $ do
		_ <- readChan ch
		return ()
		
	maybeEmpty <- timeout twoSeconds $ unGetChan ch (42 :: Int)
	assertBool "deadlock" (isJust maybeEmpty)
	killThread rPid
	)
	
tests :: Test
tests = TestList 	[TestLabel "deadlock of isEmptyChan" testIsEmptyChan,
					--- TestLabel "deadlock if writeList2Chan" testWriteList2Chan,
					 TestLabel "deadlock of ungetChan" testUngetChan
					]