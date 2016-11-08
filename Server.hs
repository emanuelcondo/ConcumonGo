module Server where

import LoginJugadores
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[SVR]\tIniciando Servidor"
    _ <- forkIO LoginJugadores.main
    putStrLn "[SVR]\tCerrando Servidor"
