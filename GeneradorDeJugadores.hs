module GeneradorDeJugadores where

import Jugador
import Control.Concurrent

main = do
    putStrLn "[GDJ]\tIniciando Generador De Jugadores"
    forkIO (Jugador.main)
    putStrLn "[GDJ]\tCerrando Generador De Jugadores"
