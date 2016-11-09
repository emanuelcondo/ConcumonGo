module Concumon where

import Config
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[CMN]\tSoy un nuevo concumón... atrapame!!!"

    tamX <- xGrilla
    tamY <- yGrilla

    delay <- delayConcumons
    putStrLn ("[CMN]\tDelay de " ++ show delay ++ " antes de moverme")
    threadDelay $ delay * 10^(6 :: Int)
    moverse


moverse = do
    putStrLn "[CMN]\tSoy un concumon, me movi!"
    --Generar RND punto destino (x,y)
    --Consultar en tablero si el destino esta ocupado. Usar


