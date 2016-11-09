module GeneradorDeJugadores where

import Jugador
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[GDJ]\tIniciando Generador De Jugadores"
    _ <- forkIO Jugador.main
    threadDelay $ 10 * 10^(6 :: Int)
    putStrLn "[GDJ]\tCerrando Generador De Jugadores"
