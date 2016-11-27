module Concurrencia
where

import System.IO.Unsafe
import Control.Concurrent

children :: MVar [MVar ()]
children = unsafePerformIO (newMVar [])
{-# NOINLINE children #-}

--- Antes de que esta función sea usada
-- Hay que hacer que los hilos padre hagan terminar a sus hijos
-- Y si es usada por más de un hilo, que no se pisen de alguna forma mágica
-- (ConcumonGo no tendría que esperar a los hijos de NidoConcumones)
waitForChildren :: IO ()
waitForChildren = do
  cs <- takeMVar children
  case cs of
    []   -> return ()
    m:ms -> do
       putMVar children ms
       takeMVar m
       waitForChildren

forkChild :: IO () -> IO ThreadId
forkChild io = do
    mvar <- newEmptyMVar
    childs <- takeMVar children
    putMVar children (mvar:childs)
    forkFinally io (\_ -> putMVar mvar ())
