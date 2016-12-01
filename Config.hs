module Config
( xGrilla
, yGrilla
, tamGrilla
, delayConcumons
, maxConcumons
, maxJugadores
) where

import Data.ConfigFile
import Data.Either.Utils

configFileName :: FilePath
configFileName = "cg.cfg"

-- Para acceder a la configuración

xGrilla :: IO Int
xGrilla = getSetting "xgrilla"

yGrilla :: IO Int
yGrilla = getSetting "ygrilla"

tamGrilla :: IO Int
tamGrilla = do
  x <- xGrilla
  y <- yGrilla
  return (x * y)

delayConcumons :: IO Int
delayConcumons = getSetting "delayconcumons"

maxConcumons :: IO Int
maxConcumons = getSetting "maxconcumons"

maxJugadores :: IO Int
maxJugadores = getSetting "maxjugadores"


getSetting :: String -> IO Int
getSetting setting = do
    val <- readfile emptyCP configFileName
    let cp = forceEither val
    return . forceEither $ get cp "Default" setting
