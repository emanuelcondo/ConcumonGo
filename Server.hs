module Server
( Server.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger

-- En cada ciclo, primero hace un waitQSem para no pasar
-- la cantidad máxima de jugadores. Si pasa el waitQSem,
-- hace un readChan de requestLoginChannel, obtiene el id y luego respondee
-- mediante writeChan de acceptLoginChannel {3}

main :: QSem -> TChan Int -> TChan Int -> TChan String -> IO ()
main semMaxJug requestLoginChan acceptLoginChan logChan = do
    log' "Empezando server" logChan
    esperarLogueo semMaxJug requestLoginChan acceptLoginChan logChan
    log' "Cerrando server" logChan

esperarLogueo :: QSem -> TChan Int -> TChan Int -> TChan String-> IO ()
esperarLogueo semMaxJug requestLoginChan acceptLoginChan logChan = do
    -- En caso de que la capacidad esté llena o...
    waitQSem semMaxJug
    -- ...de no haber solicitudes de logueo...
    idJug <- atomically $ readTChan requestLoginChan
    -- ...se queda bloquedo esperando nuevas.
    log' (show idJug ++ " inicia sesión") logChan
    atomically $ writeTChan acceptLoginChan idJug
    esperarLogueo semMaxJug requestLoginChan acceptLoginChan logChan

log' :: String -> TChan String -> IO ()
log' = cgLog "SVR"

-- {3} Se pensó también en directamente esperar los logins
-- mediante un QSem, lo cual es más simple de cierta manera
-- pero no proveía una manera directa de enviarle algo.
