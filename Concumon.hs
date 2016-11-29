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

main :: Posicion -> QSem -> TVar [[Int]] -> QSem -> Chan String -> IO ()
main posicion semLeer sharedGrid semMaxConcu eventChannel = do
    log' "Soy un nuevo concumón ... atrapame!!!"

    delay <- delayConcumons

    moverse posicion semLeer sharedGrid semMaxConcu delay


moverse :: Posicion -> QSem -> TVar [[Int]] -> QSem -> Int -> IO ()
moverse posActual semLeer sharedGrid semMaxConcu delay = do
    log' $ "Intentando hacer movimiento!"
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
                    log' $ "me movi a la Posición ...."
                else
                    log' $ "No hay posiciones libres alrededor"
            log' $ "Delay de " ++ show delay ++ " para moverme de nuevo"
            signalQSem semLeer
            threadDelay $ delay * 10^(6 :: Int)
            moverse posActual semLeer sharedGrid semMaxConcu delay
        else do
            log' $ "Fui atrapado :("
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

log' :: String -> IO ()
log' = cgLog "CMN"
