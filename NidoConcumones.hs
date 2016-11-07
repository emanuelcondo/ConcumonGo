module NidoConcumones where

import Concumon
import Control.Concurrent

main = do
    putStrLn "[NID]\tIniciando Nido de Concumones"
    forkIO (Concumon.main)
    putStrLn "[NID]\tCerrando Nido de Concumones"
