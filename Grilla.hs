module Grilla where

import System.Random
import Control.Concurrent.STM
--import Control.Monad
--import Data.Map (Map, (!))

import Config


--Estructura que define el tablero
data Posicion = Posicion Int Int deriving (Show)

instance Eq Posicion where
    (Posicion a b) == (Posicion c d) = (a == c && b == d)

getX :: Posicion -> Int
getX (Posicion x _) = x

getY :: Posicion -> Int
getY (Posicion _ y) = y

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


crearGrilla ancho alto = [ [0 | y <-[1..ancho]] | x <- [1..alto]]

getValorPosicion grilla x y = grilla !! x !! y

replaceAtIndex n item list = a ++ (item:b) where (a, (_:b)) = splitAt n list

replaceElementMatrix x y item matrix = a ++ (replaceAtIndex y item (matrix !! x):b) where (a, (_:b)) = splitAt x matrix

-- sharedGrid: grilla compartida (TVar)
-- x: posición x
-- y: posición y
-- value: nuevo valor a setear en la grilla
updateGrid sharedGrid x y value = do
    atomically ( do
        dato <- readTVar sharedGrid
        writeTVar sharedGrid (replaceElementMatrix x y value dato) )

getPosicionesVecinas :: [[Int]] -> Posicion -> [Posicion]
getPosicionesVecinas grid posicion = [] --TODO agregar funcionalidad


generarPosRand :: IO Posicion
generarPosRand = do
    genX <- newStdGen
    genY <- newStdGen
    maxX <- xGrilla
    maxY <- yGrilla
    let x = numRand genX (maxX - 1)
        y = numRand genY (maxY - 1)
    return $ Posicion x y

numRand :: StdGen -> Int -> Int
numRand gen max' = head $ randomRs (0, max') gen
