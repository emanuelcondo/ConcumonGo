module GeneradorDeJugadores where

import Jugador
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[GDJ]\tIniciando Generador De Jugadores"
    _ <- forkIO Jugador.main
    putStrLn "[GDJ]\tCerrando Generador De Jugadores"
