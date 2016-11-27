import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Control.Concurrent
import Control.Monad
import Data.Maybe


main :: IO ()
main = do
    putStrLn "[Main]\tIniciando ConcumonGo"
    threadDelay $ 2 * 10^(6 :: Integer)
    _ <- forkIO Juego.main
    _ <- forkIO GeneradorDeJugadores.main
    _ <- forkIO Sysadmin.main
    -- estaría bueno ver la forma de que este main espere
    -- a que termine los 2 threads anteriores (el delay es temporal, ya que si
    -- termina este thread se "matan" a los otros thread sin terminar)
    threadDelay $ 2 * 10^(6 :: Int)
    putStrLn "[Main]\tCargando parámetros de configuración"

    -- O empezar desde juego??
    _ <- forkIO Server.main

    interfaz

    putStrLn "[Main]\tCerrando ConcumonGo"


interfaz :: IO ()
interfaz = do
    input <- getLine
    let action = lookup input commands
    --when (action /= Nothing) $ do
    fromMaybe (putStrLn "Comando desconocido") action
    when (input /= "quit")
        interfaz

commands :: [(String, IO ())]
commands =  [ ("sysadmin", sysadmin)
            , ("help", mostrarAyuda)
            , ("quit", terminar)
            ]

sysadmin :: IO ()
sysadmin = putStrLn "not implemented"

mostrarAyuda :: IO ()
mostrarAyuda = do
    putStrLn "[Main]\tConcumonGo help:"
    putStrLn "\thelp - mostrar esta ayuda"
    putStrLn "\tquit - terminar el juego"
    putStrLn "\tsysadmin - verificar las estadísticas de los jugadores"

terminar :: IO ()
terminar = putStrLn "[Main]\tTerminar"
-- falta hacer que terminen todos los threads
