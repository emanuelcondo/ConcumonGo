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


main :: IO ()
main = do
    putStrLn "[SVR]\tEmpezando server"
    maxJug <- maxJugadores
    putStrLn $ "[SVR]\tMáxima cantidad de jugadores es " ++ show maxJug
    esperandoLogueo
    threadDelay $ 5 * 10^(6 :: Int)

-- Función que espera logueos nuevos de jugadores
esperandoLogueo :: IO ()
esperandoLogueo = do
        putStrLn "[SVR]\tEsperando logueos de Jugadores"
        -- Usar takeTMVar SolicitudLogueo
        -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.
        threadDelay $ 5 * 10^(6 :: Int)
