module Server where

import LoginJugadores
import Control.Concurrent

main = do
    putStrLn "[SVR]\tIniciando Servidor"
    forkIO (LoginJugadores.main)
    putStrLn "[SVR]\tCerrando Servidor"
