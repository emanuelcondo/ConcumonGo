module Sysadmin
( Sysadmin.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger

-- Tipo que contabilizara la sumatoria de puntaje del los jugadores en la partida.

data Jugador = Jugador {
      id :: Int,
      puntaje :: Int
    }

type ListaJugadores = TVar [Jugador]


-- Sysadmin cada cierto tiempo envía un mensaje mediante el canal para ver los
-- scores de los Jugadores.

main :: Chan String -> IO ()
main eventChannel = do
    log' "Iniciando Sysadmin"
    -- TODO
    threadDelay $ 3 * 10^(6 :: Int)


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    log' "Actualizando puntaje Jugador"
    -- TODO

imprimirPuntajes :: IO ()
imprimirPuntajes = do
    log' "Puntajes jugadores:"
    -- TODO

log' :: String -> IO ()
log' = cgLog "SYS"
