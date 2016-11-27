module Jugador where
import Control.Monad
import Control.Concurrent
import Control.Concurrent.STM


data Posicion = Posicion
    { x :: Int
    , y :: Int
    }
    deriving (Show)

main :: IO ()
main = do
    putStrLn "[JUG]\tSoy un nuevo jugador"

    loguearse

    putStrLn "[JUG]\tLogueo correcto."

    moverse

    putStrLn "[JUG]\tSaliendo del juego"


-- Funcion que permite loguear el jugador en el Servidor.module
loguearse :: IO ()
loguearse = do
    putStrLn "[JUG]\tMe intento loguear."
    -- Usar putTMVar


-- Funcion que pone a mover el jugador en en tablero.
moverse :: IO ()
moverse = do
    putStrLn "[JUG]\t Estoy en posicion: (x,y) me muevo A: "
    -- Elijo aleatoreamente alguna direccion de casillero contiguo
    -- Hago un readTvar para ver si el casillero esta libre, sino repito.module
    -- Con writeTvar escrivo mi nueva posicion en tablero.


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    putStrLn "[JUG]\t Encontre pokemon, Actualizo Puntaje"
    -- Actualiza su puntaje en el Sysadmin.
