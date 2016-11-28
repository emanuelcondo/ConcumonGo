module Concumon
( Concumon.main
) where

import Config
import Logger
import Control.Concurrent

main :: QSem -> Chan String -> IO ()
main semMaxConcu eventChannel = do
    log' "Soy un nuevo concumón... atrapame!!!"

    --tamX <- xGrilla
    --tamY <- yGrilla

    delay <- delayConcumons
    log' $ "Delay de " ++ show delay ++ " antes de moverme"
    threadDelay $ delay * 10^(6 :: Int)
    moverse

    -- Cuando es capturado, se "libera" un lugar para que pueda crearse otro concumón
    signalQSem semMaxConcu


moverse :: IO ()
moverse = do
    log' $ "Soy un concumon, me movi!"
    --Generar RND punto destino (x,y)
    --Consultar en tablero si el destino esta ocupado. Usar

log' :: String -> IO ()
log' = cgLog "CMN"
