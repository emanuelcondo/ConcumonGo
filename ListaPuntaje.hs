module ListaPuntaje where

import System.Random
import Control.Concurrent.STM
import Config

crearListaPuntaje alto = [ [0 | y <-[1..2]] | x <- [1..alto]]

replaceAtIndex n item list = a ++ (item:b) where (a, (_:b)) = splitAt n list

replaceElementMatrix x y item matrix = a ++ (replaceAtIndex y item (matrix !! x):b) where (a, (_:b)) = splitAt x matrix

-- funcion que suma 10 puntos al Jugador pasado por parametro
updateListaPuntaje :: TVar [[Int]] -> Int -> IO ()
updateListaPuntaje listaPuntaje idJugador = do
    atomically ( do
        let y = 1
        dato <- readTVar listaPuntaje
        let oldvalue = dato !! idJugador !! 1
        let value = oldvalue + 10

        writeTVar listaPuntaje (replaceElementMatrix idJugador y value dato) )

