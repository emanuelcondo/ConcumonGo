module Juego where

import Config
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
    putStrLn "[JGO]\tIniciando Juego ConcumonGo"

    let scores = Map.empty -- map para guardar puntajes

    _ <- forkIO (NidoConcumones.main eventChannel)
    tamMapa <- tamGrilla
    putStrLn ("[JGO]\tTamaño de la grilla: " ++ show tamMapa)
    putStrLn "[JGO]\tTerminando Juego"
