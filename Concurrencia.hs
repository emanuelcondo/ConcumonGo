module Concurrencia
where

import System.IO.Unsafe
import Control.Concurrent

-- Esto no se usó al final, pero eran acciones ayuda
-- para registrar a los hijos y después esperarlos.
-- Al no haber necesidad de ellas, no se usaron.

children :: MVar [MVar ()]
children = unsafePerformIO (newMVar [])
{-# NOINLINE children #-}

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
