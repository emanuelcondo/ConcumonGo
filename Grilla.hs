module Grilla where

import System.Random
import Control.Concurrent.STM
--import Control.Monad
--import Data.Map (Map, (!))

import Config


--Estructura que define el tablero
data Posicion = Posicion Int Int deriving (Show)

instance Eq Posicion where
    (Posicion a b) == (Posicion c d) = a == c && b == d

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


crearGrilla :: (Num t, Enum t) => t -> t -> [[t]]
crearGrilla ancho alto = [ [0 | _ <- [1 .. ancho]] | _ <- [1 .. alto]]

getValorPosicion :: [[a]] -> Int -> Int -> a
getValorPosicion grilla x y = grilla !! x !! y

replaceAtIndex :: Int -> a -> [a] -> [a]
replaceAtIndex n item list = a ++ (item:b)
    where (a, _:b) = splitAt n list

replaceElementMatrix :: Int -> Int -> a -> [[a]] -> [[a]]
replaceElementMatrix x y item matrix = a ++ (replaceAtIndex y item (matrix !! x):b) where (a, _:b) = splitAt x matrix

-- sharedGrid: grilla compartida (TVar)
-- x: posición x
-- y: posición y
-- value: nuevo valor a setear en la grilla
updateGrid :: TVar [[a]] -> Int -> Int -> a -> IO ()
updateGrid sharedGrid x y value =
    atomically ( do
        dato <- readTVar sharedGrid
        writeTVar sharedGrid (replaceElementMatrix x y value dato) )

getPosicionesVecinas :: [[Int]] -> Posicion -> [Posicion]
getPosicionesVecinas grid pos =
    filtrarPosicionesValidas grid posicionesAlrededor pos []
    where x_ini = getX pos - 1
          x_fin = getX pos + 1
          y_ini = getY pos - 1
          y_fin = getY pos + 1
          posicionesAlrededor = [Posicion x y | y <- [y_ini..y_fin], x <- [x_ini..x_fin]]


filtrarPosicionesValidas :: [[Int]] -> [Posicion] -> Posicion -> [Posicion]-> [Posicion]
filtrarPosicionesValidas grid posiciones posActual result =
    if null posiciones
        then
            result
        else do
            let posAux = head posiciones
            if posAux == posActual
                then
                    filtrarPosicionesValidas grid (tail posiciones) posActual result
                else do
                    let maxX = length grid - 1
                        maxY = length (head grid) - 1
                        x = getX posAux
                        y = getY posAux
                    if x > maxX || x < 0 || y > maxY || y < 0
                        then
                            filtrarPosicionesValidas grid (tail posiciones) posActual result
                        else do
                            let posValida = head posiciones
                            filtrarPosicionesValidas grid (tail posiciones) posActual (result ++ [posValida])

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
