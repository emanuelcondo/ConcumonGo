module Juego where

import NidoConcumones
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[JGO]\tIniciando Juego ConcumonGo"
    _ <- forkIO NidoConcumones.main
    putStrLn "[JGO]\tTerminando Juego"
