module ListaPuntaje where

import Control.Concurrent.STM


valorAtrapada :: Int
valorAtrapada = 10

maxGenJug :: Int
maxGenJug = 500

-- La lista de puntaje comienza con los valores en -10
-- para identificar a los jugadores que no se loggearon

crearListaPuntaje :: (Num t, Enum t) => t -> [[Int]]
crearListaPuntaje alto = [ [-valorAtrapada] | _ <- [1 .. alto] ]

replaceAtIndex :: Int -> a -> [a] -> [a]
replaceAtIndex n item list = a ++ (item:b)
    where (a, _:b) = splitAt n list

replaceElementMatrix :: Int -> Int -> a -> [[a]] -> [[a]]
replaceElementMatrix x y item matrix = a ++ (replaceAtIndex y item (matrix !! x):b)
    where (a, _:b) = splitAt x matrix

-- suma 10 puntos al Jugador pasado por parámetro, devuelve su nuevo puntaje
updateListaPuntaje :: TVar [[Int]] -> Int -> IO Int
updateListaPuntaje listaPuntaje idJugador =
    atomically $ do
        let y = 0
        dato <- readTVar listaPuntaje
        let oldvalue = head $ dato !! idJugador
        let value = oldvalue + valorAtrapada
        writeTVar listaPuntaje (replaceElementMatrix idJugador y value dato)
        return value
