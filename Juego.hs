module Juego where

import NidoConcumones
import Control.Concurrent

main = do
    putStrLn "[JGO]\tIniciando Juego ConcumonGo"
    forkIO (NidoConcumones.main)
    putStrLn "[JGO]\tTerminando Juego"
