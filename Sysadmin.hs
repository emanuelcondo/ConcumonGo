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

main :: Chan String -> TChan String -> IO ()
main eventChannel logChan = do
    log' "Iniciando Sysadmin" logChan
    -- TODO
    threadDelay $ 3 * 10^(6 :: Int)


actualizarPuntaje :: Chan String -> TChan String -> IO ()
actualizarPuntaje eventChannel logChan = do
    log' "Actualizando puntaje Jugador" logChan
    --Leo Canal de puntaje
    readChan eventChannel >>= print

    -- TODO

imprimirPuntajes :: TChan String -> IO ()
imprimirPuntajes logChan = do
    log' "Puntajes jugadores:" logChan
    -- TODO

log' :: String -> TChan String -> IO ()
log' = cgLog "SYS"
