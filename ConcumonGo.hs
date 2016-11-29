import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Config
import Logger
import Grilla

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
    log' "Cargando parámetros de configuración"
    ancho <- xGrilla
    alto <- yGrilla
    maxJug <- maxJugadores      -- Cantidad Máxima de jugadores
    semMaxJug <- newQSem maxJug     --Semáforo para el Server (para aceptar jugadores de manera acotada)
    requestLoginChannel <- atomically newTChan      -- Canal de mensajes para pedir login de jugadores
    acceptLoginChannel <- atomically newBroadcastTChan      -- Canal de mensajes para aceptar login de jugadores, de tipo Broadcast
    eventChannel <- newChan     -- Canal para movimientos (Concumones y jugadores) y pedidos de scores desde Sysadmin

    -- Alguna matriz de (0,1) -> 0: no hay Concumon
    --                           1: hay un Concumon
    let grid = (Grilla.crearGrilla ancho alto)
    sharedGrid <- atomically $ newTVar grid
    semLeer <- newQSem 1 -- semáforo para leer sharedGrid

    _ <- forkIO (Juego.main semLeer sharedGrid eventChannel)
    _ <- forkIO (Server.main semMaxJug requestLoginChannel acceptLoginChannel)
    _ <- forkIO (GeneradorDeJugadores.main semMaxJug semLeer sharedGrid requestLoginChannel acceptLoginChannel eventChannel)
    _ <- forkIO (Sysadmin.main eventChannel)

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
