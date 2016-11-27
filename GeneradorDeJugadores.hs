module GeneradorDeJugadores where

import Jugador
import Control.Concurrent

-- el main tiene debe tener un loop donde cada cierto tiempo se intenta loggear
-- un nuevo jugador (incrementando el id, más fácil), hace un writeChan de loginChannel
-- y luego hace un readChan a acceptLoginChannel (este último canal podría estar dentro de
-- Jugador.hs ya que sino se bloquearía el GeneradorDeJugadores).

main :: QSem -> Chan String -> Chan String -> Chan String -> IO ()
main semMaxJug loginChannel acceptLoginChannel eventChannel = do
    putStrLn "[GDJ]\tIniciando Generador De Jugadores"
    let id_Jug = "1"
    writeChan loginChannel "ID_JUGADOR"
    _ <- readChan acceptLoginChannel
    _ <- forkIO (Jugador.main semMaxJug eventChannel)
    threadDelay $ 10 * 10^(6 :: Int)
    putStrLn "[GDJ]\tCerrando Generador De Jugadores"
