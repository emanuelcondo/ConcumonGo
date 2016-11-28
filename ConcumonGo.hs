import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Config
import Logger

import System.IO
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import Data.Maybe


main :: IO ()
main = do
    putStrLn "Concumon GO! v0.3"
    log' "Iniciando ConcumonGo"
    threadDelay $ 2 * 10^(6 :: Integer)

    maxJug <- maxJugadores      -- Cantidad Máxima de jugadores
    semMaxJug <- newQSem maxJug     --Semáforo para el Server (para aceptar jugadores de manera acotada)
    requestLoginChannel <- atomically newTChan      -- Canal de mensajes para login de jugadores
    acceptLoginChannel <- atomically newBroadcastTChan      -- Canal de mensajes para aceptar login de jugadores, de tipo Broadcast
    eventChannel <- newChan     -- Canal para movimientos (Concumones y jugadores) y pedidos de scores desde Sysadmin

    _ <- forkIO (Juego.main eventChannel)
    _ <- forkIO (Server.main semMaxJug requestLoginChannel acceptLoginChannel)
    _ <- forkIO (GeneradorDeJugadores.main semMaxJug requestLoginChannel acceptLoginChannel eventChannel)
    _ <- forkIO (Sysadmin.main eventChannel)
    -- estaría bueno ver la forma de que este main espere
    -- a que termine los 2 threads anteriores (el delay es temporal, ya que si
    -- termina este thread se "matan" a los otros thread sin terminar)
    --threadDelay $ 2 * 10^(6 :: Int)
    log' "Cargando parámetros de configuración"

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
