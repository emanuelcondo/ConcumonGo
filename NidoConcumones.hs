module NidoConcumones where

import Config
import Concumon
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[NID]\tIniciando Nido de Concumones"
    _ <- forkIO Concumon.main
    maxConcu <- maxConcumons
    putStrLn ("[NID]\tHasta " ++ show maxConcu ++ " concumons al mismo tiempo")
    putStrLn "[NID]\tCerrando Nido de Concumones"
