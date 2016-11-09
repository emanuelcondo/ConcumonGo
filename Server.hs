module Server where

import Config
import Control.Concurrent
import Control.Concurrent.STM

data Jugador = Jugador {
              nombre :: String,
              id :: Int
              }

-- Estructura que permite a un jugador solicitar logueo.
type SolicitudLogueo = TMVar Jugador


main :: IO ()
main = do
    putStrLn "[SVR]\tIniciando Servidor"

    putStrLn ("[SVR]\tCargando parametros de configuracion")
    maxJug <- maxJugadores
    putStrLn ("[SVR]\tMáxima cantidad de jugadores es " ++ show maxJug)

    esperandoLogueo

    putStrLn "[SVR]\tCerrando Servidor"


-- Funcion que espera logueos nuevos de jugadores
esperandoLogueo = do
        putStrLn ("[SVR]\tEsperando Logueos de Jugadores")
            -- Usar takeTMVar SolicitudLogueo
            -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.
        threadDelay $ 5 * 10^(6 :: Int)


