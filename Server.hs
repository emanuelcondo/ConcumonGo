module Server
( Server.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger

-- data Jugador = Jugador {
--               nombre :: String,
--               id :: Int
--               }

-- Estructura que permite a un jugador solicitar logueo.
--type SolicitudLogueo = TMVar Jugador

-- el main debería tener una especie de loop
-- en cada ciclo, primero hacer un waitQSem para no pasar
-- la cantidad de Máximos jugadores. Si pasa el waitQSem,
-- hacer un readChan de requestLoginChannel y obtener el id y luego responder
-- mediante writeChan de acceptLoginChannel pasando las coordenadas de su ubicación

-- Más tarde se pensó en directamente esperar los logins
-- mediante un QSem, lo cual es más simple de cierta manera
-- pero no provee una forma directa de darle al Jugador
-- recién loggeado una posición. TODO: revisar comentario

main :: QSem -> TChan Int -> TChan Int -> IO ()
main semMaxJug requestLoginChan acceptLoginChan = do
    log' "Empezando server"
    esperarLogueo semMaxJug requestLoginChan acceptLoginChan
    log' "Cerrando server"

esperarLogueo :: QSem -> TChan Int -> TChan Int -> IO ()
esperarLogueo semMaxJug requestLoginChan acceptLoginChan = do
        -- En caso de que la capacidad esté llena o...
        waitQSem semMaxJug
        -- ...de no haber solicitudes de logueo...
        idJug <- atomically $ readTChan requestLoginChan
        -- ...se queda bloquedo esperando nuevas.
        log' $ show idJug ++ " inicia sesión"
        atomically $ writeTChan acceptLoginChan idJug
        esperarLogueo semMaxJug requestLoginChan acceptLoginChan

log' :: String -> IO ()
log' = cgLog "SVR"
