module Jugador where

-- Tipo que contabilizara la sumatoria de puntaje del jugador en la partida
newtype Puntaje = Puntaje Int
    deriving (Eq, Ord, Show)

data Posicion = Posicion
    { x :: Int
    , y :: Int
    }
    deriving (Show)


main :: IO ()
main = do
    putStrLn "[JUG]\tSoy un nuevo jugador"

    putStrLn "[JUG]\tLogue correcto."

    moverse

    putStrLn "[JUG]\tSaliendo del juego"



-- Funcion que permite loguear el jugador en el Servidor.module
loguearse = do
    putStrLn "[JUG]\tMe intento loguear."
        -- Usar putTMVar


-- Funcion que pone a mover el jugador en en tablero.
moverse = do
    putStrLn "[JUG]\t Estoy en posicion: (x,y) me muevo A: "
    --Elijo aleatoreamente alguna direccion de casillero contiguo
    --Hago un readTvar para ver si el casillero esta libre, sino repito.module

