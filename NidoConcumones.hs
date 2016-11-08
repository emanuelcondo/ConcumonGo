module NidoConcumones where

import Concumon
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[NID]\tIniciando Nido de Concumones"
    _ <- forkIO Concumon.main
    putStrLn "[NID]\tCerrando Nido de Concumones"
