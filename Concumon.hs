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

log' :: String -> TChan String -> IO ()
log' = cgLog "CMN"
