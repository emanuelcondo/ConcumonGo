module GeneradorDeJugadores
( GeneradorDeJugadores.main
) where

import Jugador
import Logger
import Control.Concurrent

main :: IO ()
main = do
    log' "Iniciando Generador De Jugadores"
    _ <- forkIO Jugador.main
    threadDelay $ 10 * 10^(6 :: Int)
    log' "Cerrando Generador De Jugadores"


log' :: String -> IO ()
log' = cgLog "GDJ"
