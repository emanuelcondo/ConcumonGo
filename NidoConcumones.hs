module NidoConcumones
( NidoConcumones.main
) where

import Config
import Logger
import Concumon
import Grilla
import Control.Concurrent
import Control.Concurrent.STM


-- Loopea generando concumones de manera acotada por maxConcu
-- usando el semáforo semMaxConcu

main :: QSem -> TVar [[Int]] -> TChan String -> IO ()
main semLeer sharedGrid logChan = do
    log' "Iniciando Nido de Concumones" logChan
    maxConcu <- maxConcumons
    semMaxConcu <- newQSem maxConcu
    log' ("Hasta " ++ show maxConcu ++ " concumones al mismo tiempo") logChan

    generarConcumon 0 semLeer sharedGrid semMaxConcu logChan

    log' "Cerrando Nido de Concumones" logChan

generarConcumon :: Int -> QSem -> TVar [[Int]] -> QSem -> TChan String -> IO ()
generarConcumon idConcu semLeer sharedGrid semMaxConcu logChan = do
    waitQSem semMaxConcu
    waitQSem semLeer

    grid <- atomically $ readTVar sharedGrid
    pos_ini <- buscarPosicionLibre grid
    Grilla.updateGrid sharedGrid (getX pos_ini) (getY pos_ini) 1  -- ocupamos la grilla

    log' "Creando nuevo concumón" logChan
    _ <- forkIO (Concumon.main idConcu pos_ini semLeer sharedGrid semMaxConcu logChan)

    signalQSem semLeer
    -- Espero 3 segundos antes de volver a generar uno
    threadDelay $ 3 * 10^(6 :: Int)
    generarConcumon (idConcu+1) semLeer sharedGrid semMaxConcu logChan

buscarPosicionLibre :: [[Int]] -> IO Posicion
buscarPosicionLibre grid = do
    pos <- generarPosRand
    let x = getX pos
        y = getY pos
        value = Grilla.getValorPosicion grid x y
    if value == 1  -- si está ocupado, seguimos buscando
        then
            buscarPosicionLibre grid
        else
            return pos

log' :: String -> TChan String -> IO ()
log' = cgLog "NID"
