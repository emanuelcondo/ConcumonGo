module Sysadmin where

import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[SYS]\tIniciando Sysadmin"
    threadDelay $ 3 * 10^(6 :: Int)
