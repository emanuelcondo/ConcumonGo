module Concumon
( Concumon.main
) where

import Config
import Logger
import Control.Concurrent

main :: IO ()
main = do
    log' "Soy un nuevo concumón... atrapame!!!"

    tamX <- xGrilla
    tamY <- yGrilla

    delay <- delayConcumons
    log' $ "Delay de " ++ show delay ++ " antes de moverme"
    threadDelay $ delay * 10^(6 :: Int)
    moverse


moverse = do
    log' $ "Soy un concumon, me movi!"
    --Generar RND punto destino (x,y)
    --Consultar en tablero si el destino esta ocupado. Usar

log' :: String -> IO ()
log' = cgLog "CMN"
