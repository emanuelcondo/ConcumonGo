module Server where
import Control.Concurrent
import Control.Concurrent.STM

import Config


data Jugador = Jugador {
              nombre :: String,
              id :: Int
              }

-- Estructura que permite a un jugador solicitar logueo.
type SolicitudLogueo = TMVar Jugador

-- el main debería tener una especie de loop
-- en cada ciclo, primero hacer un waitQSem para no pasar
-- la cantidad de Máximos jugadores. Si pasa el waitQSem,
-- hacer un readChan de loginChannel y obtener el id y luego responder
-- mediante writeChan de acceptLoginChannel pasando las coordenadas de su ubicación

main :: QSem -> Chan String -> Chan String -> IO ()
main semMaxJug loginChannel acceptLoginChannel = do
    putStrLn "[SVR]\tEmpezando server"
--    maxJug <- maxJugadores
--    putStrLn $ "[SVR]\tMáxima cantidad de jugadores es " ++ (show semMaxJug)
    esperandoLogueo semMaxJug loginChannel acceptLoginChannel
    threadDelay $ 5 * 10^(6 :: Int)

-- Función que espera logueos nuevos de jugadores
esperandoLogueo :: QSem -> Chan String -> Chan String -> IO ()
esperandoLogueo semMaxJug loginChannel acceptLoginChannel = do
        putStrLn "[SVR]\tEsperando logueos de Jugadores"
        waitQSem semMaxJug
        id_Jug <- readChan loginChannel
        -- Usar takeTMVar SolicitudLogueo

        writeChan acceptLoginChannel id_Jug
        -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.
        threadDelay $ 5 * 10^(6 :: Int)
