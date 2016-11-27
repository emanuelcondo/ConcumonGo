module NidoConcumones
( NidoConcumones.main
) where

import Config
import Logger
import Concumon
import Control.Concurrent

main :: IO ()
main = do
    log' "Iniciando Nido de Concumones"
    _ <- forkIO Concumon.main
    maxConcu <- maxConcumons
    log' $ "Hasta " ++ show maxConcu ++ " concumons al mismo tiempo"
    log' "Cerrando Nido de Concumones"

log' :: String -> IO ()
log' = cgLog "NID"
