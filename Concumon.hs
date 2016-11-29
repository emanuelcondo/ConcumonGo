module Concumon
( Concumon.main
) where

import Config
import Logger
import Grilla
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad.Cont
import Data.Foldable (for_)
import Data.Maybe

-- <<<<<<< HEAD
main :: Posicion -> QSem -> TVar [[Int]] -> QSem -> Chan String -> TChan String -> IO ()
main posicion semLeer sharedGrid semMaxConcu eventChannel logChan = do
    log' "Soy un nuevo concumón ... atrapame!!!" logChan

    delay <- delayConcumons

    moverse posicion semLeer sharedGrid semMaxConcu delay logChan


moverse :: Posicion -> QSem -> TVar [[Int]] -> QSem -> Int -> TChan String -> IO ()
moverse posActual semLeer sharedGrid semMaxConcu delay logChan = do
    log' "Intentando hacer movimiento!" logChan
    let x = (getX posActual)
        y = (getY posActual)
    waitQSem semLeer
    grid <- atomically $ readTVar sharedGrid
    let value = (Grilla.getValorPosicion grid x y)
    if value == 1 -- Verificamos que el concumón no fue atrapado
        then do
            let proxPos = (buscarPosicionLibreAlrededor grid posActual)
            if proxPos /= posActual
                then do
                    Grilla.updateGrid sharedGrid (getX posActual) (getY posActual) 0
                    Grilla.updateGrid sharedGrid (getX proxPos) (getY proxPos) 1
                    log' "me movi a la Posición ...." logChan
                else
                    log' "No hay posiciones libres alrededor" logChan
            log' ("Delay de " ++ show delay ++ " para moverme de nuevo") logChan
            signalQSem semLeer
            threadDelay $ delay * 10^(6 :: Int)
            moverse posActual semLeer sharedGrid semMaxConcu delay logChan
        else do
            log' "Fui atrapado :(" logChan
            signalQSem semLeer
            signalQSem semMaxConcu

buscarPosicionLibreAlrededor :: [[Int]] -> Posicion -> Posicion
buscarPosicionLibreAlrededor grid posActual = do
    let posVecinos = (Grilla.getPosicionesVecinas grid posActual)
        proxPos = (elegirProximaPosicion grid posVecinos)
    if isJust proxPos
        then
            fromJust proxPos
        else
            posActual

elegirProximaPosicion :: [[Int]] -> [Posicion] -> Maybe Posicion
elegirProximaPosicion grid posiciones = do
    if length posiciones == 0
        then
            Nothing
        else do
            let posAux = head posiciones
                x = (getX posAux)
                y = (getY posAux)
                value = (Grilla.getValorPosicion grid x y)
            if value == 0
                then
                    return posAux
                else
                    elegirProximaPosicion grid (tail posiciones)
{-
=======
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
>>>>>>> 6f71fadfbe422da07ea87bfbd4e86d07d490690c
-}
log' :: String -> TChan String -> IO ()
log' = cgLog "CMN"
