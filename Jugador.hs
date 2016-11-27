module Jugador
( Jugador.main
) where

import Logger
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
    log' "Soy un nuevo jugador"
    loguearse
    log' "Logueo correcto."
    moverse
    log' "Saliendo del juego"


-- Funcion que permite loguear el jugador en el Servidor.module
loguearse :: IO ()
loguearse = do
    log' "Me intento loguear."
    -- Usar putTMVar


-- Funcion que pone a mover el jugador en en tablero.
moverse :: IO ()
moverse = do
    -- Elijo aleatoreamente alguna direccion de casillero contiguo
    log' "Estoy en posicion: (x,y) me muevo a: "
    -- Hago un readTvar para ver si el casillero está libre, sino repito.module
        -- mc: Se puede hacer con retry (https://en.wikipedia.org/wiki/Concurrent_Haskell)
    -- Con writeTvar escribo mi nueva posicion en tablero.


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    log' "Encontre pokemon, Actualizo Puntaje"
    -- Actualiza su puntaje en el Sysadmin.


log' :: String -> IO ()
log' = cgLog "JUG"
