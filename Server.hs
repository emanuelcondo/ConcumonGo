module Server where

import Config
import LoginJugadores
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[SVR]\tIniciando Servidor"
    _ <- forkIO LoginJugadores.main
    maxJug <- maxJugadores
    putStrLn ("[SVR]\tMáxima cantidad de jugadores es " ++ show maxJug)
    putStrLn "[SVR]\tCerrando Servidor"
