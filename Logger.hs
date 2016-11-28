module Logger
( cgLog
, endRun
) where

import System.IO
import System.Directory

logFilename :: String
logFilename = "cg.log"

cgLog :: String -> String -> IO ()
cgLog tag output = do
    let line = "[" ++ tag ++ "]\t" ++ output
    (tempName, tempHandle) <- openTempFile "." "logtemp"
    logfileExists <- doesFileExist logFilename
    if logfileExists
        then do
            handle <- openFile logFilename ReadMode
            contents <- hGetContents handle
            hPutStr tempHandle $ contents ++ line ++ "\n"
            hClose handle
            removeFile logFilename
    else
            hPutStr tempHandle $ line ++ "\n"
    hClose tempHandle
    renameFile tempName logFilename
    -- TODO Discutir si esto todavía es insuficiente
    -- para óptima concurrencia

endRun :: IO ()
endRun = appendFile logFilename "\n"
