module Sysadmin
( Sysadmin.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger
import ListaPuntaje

-- Sysadmin cada cierto tiempo envía un mensaje mediante el canal para ver los
-- scores de los Jugadores.

main :: Chan String -> TVar [[Int]] -> IO ()
main eventChannel puntaje = do
    putStrLn "Leo canal para actualizar puntaje"

    actualizarPuntaje eventChannel puntaje
    imprimirPuntajes puntaje

    threadDelay $ 3 * 10^(6 :: Int)
    main eventChannel puntaje

--
actualizarPuntaje :: Chan String -> TVar [[Int]] -> IO ()
actualizarPuntaje eventChannel puntajeTVar = do
    putStrLn "Actualizando puntaje Jugador"
    --Leo Canal de puntaje
    let idJugador = readChan eventChannel

    ListaPuntaje.updateListaPuntaje puntajeTVar 3 1 0

-- Imprime la lista entera de Jugadores con sus puntajes.
imprimirPuntajes :: TVar [[Int]] -> IO()
imprimirPuntajes puntajeTVar = do
    dato <- atomically $ readTVar puntajeTVar

    putStrLn $ "Puntaje Actual:" ++ show dato