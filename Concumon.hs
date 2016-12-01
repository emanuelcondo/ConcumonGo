module Concumon
( Concumon.main
) where

import Config
import Logger
import Grilla
import Control.Concurrent
import Control.Concurrent.STM
import Data.Maybe


main :: Int -> Posicion -> QSem -> TVar [[Int]] -> QSem -> TChan String -> IO ()
main idConcu pos semLeer sharedGrid semMaxConcu logChan = do
    log' ("Soy un nuevo concumón, iniciando en: "++ show pos ++" ... atrapame!!! (idConcu: " ++ show idConcu ++ ")") logChan
    delay <- delayConcumons
    moverse idConcu pos semLeer sharedGrid semMaxConcu delay logChan


moverse :: Int -> Posicion -> QSem -> TVar [[Int]] -> QSem -> Int -> TChan String -> IO ()
moverse idConcu posActual semLeer sharedGrid semMaxConcu delay logChan = do
    let x = getX posActual
        y = getY posActual
    waitQSem semLeer
    grid <- atomically $ readTVar sharedGrid
    let value = Grilla.getValorPosicion grid x y
    if value == 1  -- Verificamos que el concumón no fue atrapado
        then do
            log' ("Intentando hacer movimiento! (idConcu: " ++ show idConcu ++ ")") logChan
            let proxPos = buscarPosicionLibreAlrededor grid posActual
            if proxPos /= posActual
                then do
                    Grilla.updateGrid sharedGrid (getX posActual) (getY posActual) 0
                    Grilla.updateGrid sharedGrid (getX proxPos) (getY proxPos) 1
                    log' ("Me moví a la "++show proxPos++". (idConcu: " ++ show idConcu ++ ")") logChan
                else
                    log' ("No hay posiciones libres alrededor. (idConcu: "  ++ show idConcu ++ ")") logChan
            log' ("Delay de " ++ show delay ++ " para moverme de nuevo (idConcu: "  ++ show idConcu ++ ")") logChan
            signalQSem semLeer
            threadDelay $ delay * 10^(6 :: Int)
            moverse idConcu proxPos semLeer sharedGrid semMaxConcu delay logChan
        else do
            log' ("Fui atrapado :( en "++ show posActual ++". (idConcu: " ++ show idConcu ++ ")")  logChan
            signalQSem semLeer
            signalQSem semMaxConcu

buscarPosicionLibreAlrededor :: [[Int]] -> Posicion -> Posicion
buscarPosicionLibreAlrededor grid posActual = do
    let posVecinos = Grilla.getPosicionesVecinas grid posActual
        proxPos = elegirProximaPosicion grid posVecinos
    fromMaybe posActual proxPos

elegirProximaPosicion :: [[Int]] -> [Posicion] -> Maybe Posicion
elegirProximaPosicion grid posiciones =
    if null posiciones
        then
            Nothing
        else do
            let posAux = head posiciones
                x = getX posAux
                y = getY posAux
                value = Grilla.getValorPosicion grid x y
            if value == 0
                then
                    return posAux
                else
                    elegirProximaPosicion grid (tail posiciones)

log' :: String -> TChan String -> IO ()
log' = cgLog "CMN"
