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
main :: QSem -> TVar [[Int]] -> Chan String -> TChan String -> IO ()
main semLeer sharedGrid eventChannel logChan = do
    log' "Iniciando Nido de Concumones" logChan
    maxConcu <- maxConcumons
    semMaxConcu <- newQSem maxConcu
    log' ("Hasta " ++ show maxConcu ++ " concumons al mismo tiempo") logChan

    generarConcumon semLeer sharedGrid semMaxConcu eventChannel logChan

    log' "Cerrando Nido de Concumones" logChan

generarConcumon :: QSem -> TVar [[Int]] -> QSem -> Chan String -> TChan String -> IO ()
generarConcumon semLeer sharedGrid semMaxConcu eventChannel logChan = do
    waitQSem semMaxConcu
    waitQSem semLeer
--  TODO
--   - grid <- atomically $ readTVar sharedGrid
--   - pos_ini <- buscarPosiciónLibre grid (*)
--   - escribir sharedGrid (Grilla.updateGrid sharedGrid x y 1)
--   - pasar la posición inicial al concumón
    -- chequear que está libre?
    log' "Creando nuevo concumon al mismo tiempo" logChan
    --_ <- forkIO (Concumon.main semLeer sharedGrid semMaxConcu eventChannel logChan)
    signalQSem semLeer
    threadDelay $ 10 * 10^(6 :: Int)
    generarConcumon semLeer sharedGrid semMaxConcu eventChannel logChan

--  TODO
buscarPosicionLibre :: TVar [[Int]] -> IO Posicion
buscarPosicionLibre grid = do
    pos <- generarPosRand
    -- verificar hasta encontrar uno libre
    return pos

log' :: String -> TChan String -> IO ()
log' = cgLog "NID"
