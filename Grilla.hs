module Grilla where
import Control.Concurrent
import Control.Concurrent.STM
import Data.List

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
