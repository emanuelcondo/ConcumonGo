module Juego where

import Config
import NidoConcumones
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[JGO]\tIniciando Juego ConcumonGo"
    _ <- forkIO NidoConcumones.main
    tamMapa <- tamGrilla
    putStrLn ("[JGO]\tTamaño de la grilla: " ++ show tamMapa)
    putStrLn "[JGO]\tTerminando Juego"
