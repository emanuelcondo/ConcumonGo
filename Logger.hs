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
    handle <- openFile logFilename ReadMode
    (tempName, tempHandle) <- openTempFile "." "logtemp"
    contents <- hGetContents handle
    hPutStr tempHandle $ contents ++ line ++ "\n"
    hClose handle
    hClose tempHandle
    removeFile logFilename
    renameFile tempName logFilename
    -- Hacer simplemente appendFile logFilename (line ++ "\n")
    -- sufre las consecuencias de la concurrencia y el lazyness
    -- TODO Discutir si esto todavía es insuficiente

endRun :: IO ()
endRun = appendFile logFilename "\n"
