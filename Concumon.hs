module Concumon where

import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[CMN]\tSoy un nuevo concumón... atrapame!!!"
    threadDelay 3
