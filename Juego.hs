module Juego where

import Config
import NidoConcumones
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad


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

type Tablero = TVar [Casillero]


main :: IO ()
main = do
    putStrLn "[JGO]\tIniciando Juego ConcumonGo"
    _ <- forkIO NidoConcumones.main
    tamMapa <- tamGrilla
    putStrLn ("[JGO]\tTamaño de la grilla: " ++ show tamMapa)
    putStrLn "[JGO]\tTerminando Juego"


