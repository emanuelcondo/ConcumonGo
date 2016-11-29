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

    delay <- delayConcumons
    log' $ "Delay de " ++ show delay ++ " antes de moverme"
    threadDelay $ delay * 10^(6 :: Int)
    moverse semLeer sharedGrid semMaxConcu

    -- Cuando es capturado, se "libera" un lugar para que pueda crearse otro concumón
    log' $ "Fui atrapado :("
    signalQSem semMaxConcu


moverse :: QSem -> TVar [[Int]] -> QSem -> IO ()
moverse semLeer sharedGrid semMaxConcu = do
    log' $ "Soy un concumon, me movi!"
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
    moverse semLeer sharedGrid semMaxConcu

-- TODO
-- buscarPosicionLibreAlrededor grid posActual = do
-- buscar hasta encontrar alguna posición libre
-- si no hay lugares libre volver con la misma Posicion
-- y no moverse

log' :: String -> IO ()
log' = cgLog "CMN"
