module Sysadmin
( Sysadmin.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger
import ListaPuntaje
import System.IO.Unsafe


-- Funcion que cada x segundos lee del canal de puntaje y actualiza el puntaje en TVAR
main :: Chan Int -> TVar [[Int]] -> IO ()
main puntajeChan puntajeTVar = do
    putStrLn "Leo canal para actualizar puntaje"

    actualizarPuntaje puntajeChan puntajeTVar
    imprimirPuntajes puntajeTVar

    threadDelay $ 3 * 10^(6 :: Int)
    main puntajeChan puntajeTVar


-- Lee del canal y suma 10 puntos al idJugador que leyo del canal
actualizarPuntaje :: Chan Int -> TVar [[Int]] -> IO ()
actualizarPuntaje puntajeChan puntajeTVar = do

    let idJ = unsafePerformIO $ readChan puntajeChan
    ListaPuntaje.updateListaPuntaje puntajeTVar idJ


-- Imprime la lista entera de Jugadores con sus puntajes.
imprimirPuntajes :: TVar [[Int]] -> IO()
imprimirPuntajes puntajeTVar = do
    dato <- atomically $ readTVar puntajeTVar
    putStrLn $ "Puntajes Actuales:" ++ show dato


-- TODO: Agregar log!