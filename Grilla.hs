module Grilla where

import Data.List

crearGrilla ancho alto = [ [0 | y <-[1..ancho]] | x <- [1..alto]]

getValorPosicion grilla x y = grilla !! x !! y

setValorPosicion grilla x y nuevoValor = do
    replaceElementMatrix x y nuevoValor grilla

replaceAtIndex n item list = a ++ (item:b) where (a, (_:b)) = splitAt n list

replaceElementMatrix x y item matrix = a ++ (replaceAtIndex y item (matrix !! x):b) where (a, (_:b)) = splitAt x matrix
