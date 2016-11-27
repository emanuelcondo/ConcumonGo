import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Logger

import System.IO
import Control.Concurrent
import Control.Monad
import Data.Maybe


main :: IO ()
main = do
    putStrLn "Concumon GO! v0.2"
    log' "Iniciando ConcumonGo"
    threadDelay $ 2 * 10^(6 :: Integer)
    _ <- forkIO Juego.main
    _ <- forkIO GeneradorDeJugadores.main
    _ <- forkIO Sysadmin.main
    -- estaría bueno ver la forma de que este main espere
    -- a que termine los 2 threads anteriores (el delay es temporal, ya que si
    -- termina este thread se "matan" a los otros thread sin terminar)
    --threadDelay $ 2 * 10^(6 :: Int)
    log' "Cargando parámetros de configuración"

    -- O empezar desde juego??
    _ <- forkIO Server.main

    interfaz

    log' "Cerrando ConcumonGo"
    Logger.endRun


interfaz :: IO ()
interfaz = do
    putStr "> "
    hFlush stdout
    input <- getLine
    let action = lookup input commands
    --when (action /= Nothing) $ do
    fromMaybe (putStrLn "Comando desconocido, 'help' para ayuda") action
    when (input /= "quit" && input /= "q")
        interfaz
    -- Alternativa: en vez de recursivo, forever con exitSuccess

commands :: [(String, IO ())]
commands =  [ ("sysadmin", sysadmin)
            , ("s", sysadmin)
            , ("help", mostrarAyuda)
            , ("h", mostrarAyuda)
            , ("quit", terminar)
            , ("q", terminar)
            ]

sysadmin :: IO ()
sysadmin = putStrLn "not implemented"

mostrarAyuda :: IO ()
mostrarAyuda = do
    log' "Imprimo ayuda"
    putStrLn "ConcumonGo help:"
    putStrLn "\thelp - mostrar esta ayuda"
    putStrLn "\tquit - terminar el juego"
    putStrLn "\tsysadmin - verificar las estadísticas de los jugadores"

terminar :: IO ()
terminar = log' "Terminar"
-- falta hacer que terminen todos los threads

log' :: String -> IO ()
log' = cgLog "Main"
