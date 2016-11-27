module NidoConcumones
( NidoConcumones.main
) where

import Config
import Logger
import Concumon
import Control.Concurrent


-- El NidoConcumones va a loopear generando concumones de manera acotada por maxConcu
-- usando el semáforo semMaxConcu (haciendo waitQSem). Cuando se atrapa a un Concumon
-- se hace un signalQSem (esto se hace desde Juego, el que lo sabe todo)
main :: Chan String -> IO ()
main eventChannel = do
    log' "Iniciando Nido de Concumones"
    maxConcu <- maxConcumons
    semMaxConcu <- newQSem maxConcu

    waitQSem semMaxConcu
    _ <- forkIO (Concumon.main semMaxConcu eventChannel)

    log' $ "Hasta " ++ show maxConcu ++ " concumons al mismo tiempo"
    log' "Cerrando Nido de Concumones"



log' :: String -> IO ()
log' = cgLog "NID"
