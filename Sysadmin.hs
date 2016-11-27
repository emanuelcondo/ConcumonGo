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

main :: IO ()
main = do
    log' "Iniciando Sysadmin"
    threadDelay $ 3 * 10^(6 :: Int)


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    log' "Actualizando puntaje Jugador"

imprimirPuntajes :: IO ()
imprimirPuntajes = do
    log' "Puntajes jugadores:"

log' :: String -> IO ()
log' = cgLog "SYS"
