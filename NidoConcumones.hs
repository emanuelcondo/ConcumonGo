module NidoConcumones
( NidoConcumones.main
) where

import Config
import Logger
import Concumon
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
    log' $ "Creando nuevo concumon al mismo tiempo"
    _ <- forkIO (Concumon.main semLeer sharedGrid semMaxConcu eventChannel)
    threadDelay (2 * 1000000)
    generarConcumon semLeer sharedGrid semMaxConcu eventChannel

log' :: String -> IO ()
log' = cgLog "NID"
