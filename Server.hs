module Server where

import Config
import Control.Concurrent
import Control.Concurrent.STM

data Jugador = Jugador {
              nombre :: String,
              id :: Int
              }

type SolicitudLogueo = TMVar Jugador

main :: IO ()
main = do
    putStrLn "[SVR]\tIniciando Servidor"
    --_ <- forkIO LoginJugadores.main

    putStrLn ("[SVR]\tCargando parametros de configuracion")
    maxJug <- maxJugadores
    putStrLn ("[SVR]\tMáxima cantidad de jugadores es " ++ show maxJug)


    putStrLn ("[SVR]\tEsperando Logueos de Jugadores")
    -- Usar takeTMVar SolicitudLogueo
    -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.

    putStrLn "[SVR]\tCerrando Servidor"

