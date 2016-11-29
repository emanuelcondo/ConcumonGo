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
--  TODO
--   - grid <- atomically $ readTVar sharedGrid
--   - pos_ini <- buscarPosiciónLibre grid (*)
--   - escribir sharedGrid (Grilla.updateGrid sharedGrid x y 1)
--   - pasar la posición inicial al concumón
    -- chequear que está libre?
    log' $ "Creando nuevo concumon al mismo tiempo"
    _ <- forkIO (Concumon.main semLeer sharedGrid semMaxConcu eventChannel)
    signalQSem semLeer
    threadDelay (2 * 1000000)
    generarConcumon semLeer sharedGrid semMaxConcu eventChannel

--  TODO
buscarPosicionLibre :: TVar [[Int]] -> IO Posicion
buscarPosicionLibre grid = do
    pos <- generarPosRand
    -- verificar hasta encontrar uno libre
    return pos

log' :: String -> IO ()
log' = cgLog "NID"
