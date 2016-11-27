module Juego
( Juego.main
) where

import Config
import Logger
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
-- Tipo que define el tablero para usar con bloques atomically
type Tablero = TVar [Casillero]


main :: IO ()
main = do
    log' "Iniciando Juego ConcumonGo"
    _ <- forkIO NidoConcumones.main
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
