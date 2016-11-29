module NidoConcumones
( NidoConcumones.main
) where

import Config
import Logger
import Concumon
import Grilla
import Control.Concurrent
import Control.Concurrent.STM


-- El NidoConcumones va a loopear generando concumones de manera acotada por maxConcu
-- usando el semáforo semMaxConcu (haciendo waitQSem). Cuando se atrapa a un Concumon
-- se hace un signalQSem (esto se hace desde Juego, el que lo sabe todo)
main :: QSem -> TVar [[Int]] -> Chan String -> IO ()
main semLeer sharedGrid eventChannel = do
    log' "Iniciando Nido de Concumones"
    maxConcu <- maxConcumons
    semMaxConcu <- newQSem maxConcu
    log' $ "Hasta " ++ show maxConcu ++ " concumons al mismo tiempo"

    generarConcumon semLeer sharedGrid semMaxConcu eventChannel

    log' "Cerrando Nido de Concumones"

generarConcumon semLeer sharedGrid semMaxConcu eventChannel = do
    waitQSem semMaxConcu
    waitQSem semLeer

    grid <- atomically $ readTVar sharedGrid
    pos_ini <- buscarPosicionLibre grid
    Grilla.updateGrid sharedGrid (getX pos_ini) (getY pos_ini) 1 -- ocupamos la grilla

    log' $ "Creando nuevo concumon"
    _ <- forkIO (Concumon.main pos_ini semLeer sharedGrid semMaxConcu eventChannel)
    signalQSem semLeer
    threadDelay (2 * 1000000)
    generarConcumon semLeer sharedGrid semMaxConcu eventChannel


buscarPosicionLibre :: [[Int]] -> IO Posicion
buscarPosicionLibre grid = do
    pos <- generarPosRand
    let x = (getX pos)
        y = (getY pos)
        value = (Grilla.getValorPosicion grid x y)
    if value == 1 --si está ocupado, seguimos buscando
        then
            buscarPosicionLibre grid
        else
            return pos

log' :: String -> IO ()
log' = cgLog "NID"
