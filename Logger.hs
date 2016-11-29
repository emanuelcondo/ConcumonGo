module Logger
( loggerThread
, cgLog
, endRun
) where

import System.IO
import System.Directory
import Control.Concurrent.STM
import Control.Monad

logFilename :: FilePath
logFilename = "cg.log"

lastLine :: String
lastLine = "\n"

loggerThread :: TChan String -> IO ()
loggerThread logChan = do
    logfileExists <- doesFileExist logFilename
    unless logfileExists $
        withFile logFilename WriteMode $ \fh ->
            hPutStrLn fh "LOGFILE CONCUMON GO"
    forever $ do
        logLine <- atomically $ readTChan logChan
        appendFile logFilename logLine
        when (logLine == lastLine) $
            return ()

cgLog :: String -> String -> TChan String -> IO ()
cgLog tag output logChan = do
    let line = "[" ++ tag ++ "]\t" ++ output ++ "\n"
    atomically $ writeTChan logChan line

endRun :: TChan String -> IO ()
endRun logChan = atomically $ writeTChan logChan lastLine
--endRun :: Either SomeException () -> IO ()
--endRun _ = appendFile logFilename "\n"
