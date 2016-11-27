module Juego
( Juego.main
) where

import Config
import Logger
import NidoConcumones
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import Data.Map (Map, (!))
import qualified Data.Map as Map


--Estructura que define el tablero
data Posicion = Posicion
    { x :: Int
    , y :: Int
    }
    deriving (Show)

data Estado = Libre
            | Ocupado
            | Concumon
                deriving (Eq, Ord, Show)

data Casillero = Casillero {
        posicion :: Posicion,
        estado :: Estado
        }
-- Tipo que define el tablero para usar con bloques atomically
type Tablero = TVar [Casillero]


-- Juego va a loopear esperando eventos (pueden movimientos de concumones ó jugadores) ó
-- consultas de Sysadmin, asi que hay que hacer un check cuando se haga un readChan
-- de eventChannel. En caso de que sea un evento de Sysadmin, deberíamos hacer un print de
-- los scores (que mejor que usar un hash).
main :: Chan String -> IO ()
main eventChannel = do

    log' "Iniciando Juego ConcumonGo"
    let scores = Map.empty -- map para guardar puntajes
    -- Alguna matriz de (0,1) -> 0: no hay Concumon
    --                           1: hay un Concumon

    _ <- forkIO (NidoConcumones.main eventChannel)
    tamMapa <- tamGrilla
    log' $ "Tamaño de la grilla: " ++ show tamMapa
    log' "Terminando Juego"

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


log' :: String -> IO ()
log' = cgLog "JGO"
