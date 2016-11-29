module Sysadmin
( Sysadmin.main
) where

import Control.Concurrent
import Control.Concurrent.STM
import Logger


-- Sysadmin cada cierto tiempo envía un mensaje mediante el canal para ver los
-- scores de los Jugadores.

main :: Chan String -> TVar Int -> IO ()
main eventChannel puntaje = do
    putStrLn "Leo canal para actualizar puntaje"

    actualizarPuntaje eventChannel puntaje
    imprimirPuntajes puntaje

    threadDelay $ 3 * 10^(6 :: Int)

actualizarPuntaje :: Chan String -> TVar Int -> IO ()
actualizarPuntaje eventChannel puntajeTVar = do
    putStrLn "Actualizando puntaje Jugador"
    --Leo Canal de puntaje
    let puntajeLeido = readChan eventChannel

    puntajeTVarAnterior<- atomRead puntajeTVar
   -- putStrLn $ "Puntaje Anterior: " ++ show puntajeTVarAnterior
    appV ((+) 10) puntajeTVar
    puntajeNuevo <- atomRead puntajeTVar
    putStrLn $ "PuntajeNuevo: " ++ show puntajeNuevo

atomRead = atomically . readTVar
appV fn x = atomically $ readTVar x >>= writeTVar x . fn

imprimirPuntajes :: TVar Int -> IO ()
imprimirPuntajes puntajeTVar= do
    puntaje<- atomRead puntajeTVar
    putStrLn $ "Puntaje Actual:" ++ show puntaje

