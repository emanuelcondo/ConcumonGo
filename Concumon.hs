module Concumon
( Concumon.main
) where

import Config
import Logger
import Control.Concurrent
import Control.Concurrent.STM

main :: QSem -> TVar [[Int]] -> QSem -> Chan String -> TChan String -> IO ()
main semLeer sharedGrid semMaxConcu eventChannel logChan = do
    log' "Soy un nuevo concumón... atrapame!!!" logChan

    delay <- delayConcumons
    log' ("Delay de " ++ show delay ++ " antes de moverme") logChan
    threadDelay $ delay * 10^(6 :: Int)
    moverse semLeer sharedGrid semMaxConcu logChan

    -- Cuando es capturado, se "libera" un lugar para que pueda crearse otro concumón
    log' "Fui atrapado :(" logChan
    signalQSem semMaxConcu


moverse :: QSem -> TVar [[Int]] -> QSem -> TChan String -> IO ()
moverse semLeer sharedGrid semMaxConcu logChan = do
    log' "Soy un concumon, me movi!" logChan
{-    waitQSem semLeer
    if (posActual == 0)
        then do
            return()
    grid <- readTVar sharedGrid
    pos <- buscarPosicionLibreAlrededor grid posActual
    Grilla.updateGrid sharedGrid xi yi 0
    Grilla.updateGrid sharedGrid xf yf 1
    if (xi /= xf || yi /= yf)
        log' $ "me movi a la Posición" xf xi
    signalQSem semLeer
-}
    moverse semLeer sharedGrid semMaxConcu logChan

-- TODO
-- buscarPosicionLibreAlrededor grid posActual = do
-- buscar hasta encontrar alguna posición libre
-- si no hay lugares libre volver con la misma Posicion
-- y no moverse

log' :: String -> TChan String -> IO ()
log' = cgLog "CMN"
