module Sysadmin
( Sysadmin.main
, imprimirPuntajes
) where

import Control.Monad
import Control.Concurrent
import Control.Concurrent.STM
import Logger
import ListaPuntaje


-- Lee del canal de puntaje y actualiza el puntaje en el TVar; se imprimen cada 15 s
main :: TChan Int -> TVar [[Int]] -> TChan String -> IO ()
main puntajeChan puntajeTVar logChan = do
    log' "Inicio. Leo del canal de puntos para actualizar puntaje" logChan
    -- Loggeo el puntaje cada 15 segundos
    _ <- forkIO $ forever $ do
        loggearPuntajes puntajeTVar logChan
        threadDelay $ 15 * 10^(6 :: Int)
    -- Actualizo el puntaje continuamente
    forever $
        actualizarPuntaje puntajeChan puntajeTVar logChan


-- Lee del canal y suma 10 puntos al idJugador leído del canal
actualizarPuntaje :: TChan Int -> TVar [[Int]] -> TChan String -> IO ()
actualizarPuntaje puntajeChan puntajeTVar logChan = do
    idJ <- atomically $ readTChan puntajeChan
    nuevoPuntaje <- ListaPuntaje.updateListaPuntaje puntajeTVar idJ
    if nuevoPuntaje > 0
        then log' ("Agregué puntos a jugador #" ++ show idJ) logChan
        else log' ("Inicializo puntaje de jugador #" ++ show idJ) logChan


-- Imprime la lista entera de Jugadores con sus puntajes
imprimirPuntajes :: TVar [[Int]] -> IO()
imprimirPuntajes puntajeTVar = do
    dato <- atomically $ readTVar puntajeTVar
    putStr "\nPuntajes actuales\n-----------------\nId\tPuntaje"
    putStrLn $ appendFilaPuntaje 0 dato "" ++ "\n"


-- Loggea la lista entera de Jugadores con sus puntajes
loggearPuntajes :: TVar [[Int]] -> TChan String -> IO()
loggearPuntajes puntajeTVar logChan = do
    dato <- atomically $ readTVar puntajeTVar
    log' ("Puntajes actuales\n-----------------\nId\tPuntaje"
            ++ appendFilaPuntaje 0 dato "" ++ "\n") logChan


appendFilaPuntaje :: Int -> [[Int]] -> String -> String
appendFilaPuntaje _ [] s = s
appendFilaPuntaje n (x:xs) s
    | head x < 0 = appendFilaPuntaje (n+1) xs s
    | otherwise = appendFilaPuntaje (n+1) xs (s ++ "\n" ++ show n ++ "\t" ++ show (head x))


log' :: String -> TChan String -> IO ()
log' = cgLog "SYS"
