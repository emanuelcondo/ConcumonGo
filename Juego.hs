module Juego
( Juego.main
, Posicion(..)
, generarPosRand
) where

import Config
import Logger
import NidoConcumones
import Control.Concurrent
import Control.Concurrent.STM
import qualified Data.Map as Map
import Grilla


-- Juego va a loopear esperando eventos (pueden movimientos de concumones ó jugadores) ó
-- consultas de Sysadmin, asi que hay que hacer un check cuando se haga un readChan
-- de eventChannel. En caso de que sea un evento de Sysadmin, deberíamos hacer un print de
-- los scores (que mejor que usar un hash).
main :: QSem -> TVar [[Int]]-> Chan String -> TChan String -> IO ()
main semLeer sharedGrid eventChannel logChan = do

    log' "Iniciando Juego ConcumonGo" logChan

    let scores = Map.empty -- map para guardar puntajes

    _ <- forkIO (NidoConcumones.main semLeer sharedGrid eventChannel logChan)
    tamMapa <- tamGrilla
    log' ("Tamaño de la grilla: " ++ show tamMapa) logChan
    log' "Terminando Juego" logChan

-- Creación de mapa

--moverJugadorEnMapa :: STM Posicion
--moverJugadorEnMapa = do
--    putStrLn "[JGO]\tMuevo "
--    return 0

-- Devuelve True si hay concumón en la posición
--hayConcumon :: Posicion -> Bool
--hayConcumon = do
--    return False
    -- TODO

log' :: String -> TChan String -> IO ()
log' = cgLog "JGO"
