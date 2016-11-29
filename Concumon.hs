module Concumon
( Concumon.main
) where

import Config
import Logger
import Control.Concurrent
import Control.Concurrent.STM

main :: QSem -> TVar [[Int]] -> QSem -> Chan String -> IO ()
main semLeer sharedGrid semMaxConcu eventChannel = do
    log' "Soy un nuevo concumón... atrapame!!!"

    --tamX <- xGrilla
    --tamY <- yGrilla

    delay <- delayConcumons
    log' $ "Delay de " ++ show delay ++ " antes de moverme"
    threadDelay $ delay * 10^(6 :: Int)
    moverse semLeer sharedGrid semMaxConcu

    -- Cuando es capturado, se "libera" un lugar para que pueda crearse otro concumón
    signalQSem semMaxConcu


moverse :: QSem -> TVar [[Int]] -> QSem -> IO ()
moverse semLeer sharedGrid semMaxConcu = do
    log' $ "Soy un concumon, me movi!"
    --Generar RND punto destino (x,y)
    --Consultar en tablero si el destino esta ocupado. Usar

log' :: String -> IO ()
log' = cgLog "CMN"
