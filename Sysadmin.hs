module Sysadmin where
import Control.Concurrent
import Control.Concurrent.STM

-- Tipo que contabilizara la sumatoria de puntaje del los jugadores en la partida.

data Jugador = Jugador {
      id :: Int,
      puntaje :: Int
    }

type ListaJugadores = TVar [Jugador]


-- Sysadmin cada cierto tiempo envía un mensaje mediante el canal para ver los
-- scores de los Jugadores.

main :: Chan String -> IO ()
main eventChannel = do
    putStrLn "[SYS]\tIniciando Sysadmin"
    threadDelay $ 3 * 10^(6 :: Int)


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    putStrLn "[SYS]\t Actualizando puntaje Jugador"

imprimirPuntajes :: IO ()
imprimirPuntajes = do
    putStrLn "[SYS] Puntajes jugadores:"
