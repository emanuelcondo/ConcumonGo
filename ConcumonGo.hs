import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Config
import Logger
import Grilla
import ListaPuntaje
import System.IO
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import Data.Maybe


main :: IO ()
main = do
    putStrLn "Concumon GO! v0.3"

    logChan <- atomically newTChan      -- Canal para imprimir en el log
    _ <- forkIO $ Logger.loggerThread logChan

    log' "Iniciando ConcumonGo" logChan
    --threadDelay $ 2 * 10^(6 :: Integer)
    log' "Cargando parámetros de configuración" logChan
    ancho <- xGrilla
    alto <- yGrilla
    maxJug <- maxJugadores      -- Cantidad Máxima de jugadores
    semMaxJug <- newQSem maxJug     -- Semáforo para el Server (para aceptar jugadores de manera acotada)
    requestLoginChannel <- atomically newTChan      -- Canal de mensajes para pedir login de jugadores
    acceptLoginChannel <- atomically newBroadcastTChan      -- Canal de mensajes para aceptar login de jugadores, de tipo Broadcast
    eventChannel <- newChan     -- Canal para movimientos (Concumones y jugadores) y pedidos de scores desde Sysadmin
    puntajeChan <- newChan      -- Canal que usa un jugador para avisar que suma puntaje.

    -- Estructura para manejar el puntaje acumulado de Jugadores.
    let listaPuntaje = (crearListaPuntaje 100)
    puntajeTVar <- atomically $ newTVar listaPuntaje

    -- Alguna matriz de (0,1) -> 0: no hay Concumon
    --                           1: hay un Concumon

    let grid = (Grilla.crearGrilla ancho alto)
    log' ("Tamaño de la grilla: " ++ show ancho ++ " x " ++ show alto) logChan

    sharedGrid <- atomically $ newTVar grid
    semLeer <- newQSem 1 -- semáforo para leer sharedGrid

    _ <- forkIO (Juego.main semLeer sharedGrid eventChannel logChan)
    _ <- forkIO (Server.main semMaxJug requestLoginChannel acceptLoginChannel logChan)
    _ <- forkIO (GeneradorDeJugadores.main semMaxJug semLeer sharedGrid requestLoginChannel acceptLoginChannel puntajeChan logChan)
    _ <- forkIO (Sysadmin.main puntajeChan puntajeTVar)

    interfaz logChan

    -- falta hacer que terminen todos los threads?
    log' "Cerrando ConcumonGo" logChan
    Logger.endRun logChan


interfaz :: TChan String -> IO ()
interfaz logChan = do
    putStr "> "
    hFlush stdout
    input <- getLine
    let action = lookup input $ commands logChan
    --when (action /= Nothing) $ do
    fromMaybe (putStrLn "Comando desconocido, 'help' para ayuda") action
    when (input /= "quit" && input /= "q") $
        interfaz logChan
    -- Alternativa: en vez de recursivo, forever con exitSuccess

commands :: TChan String -> [(String, IO ())]
commands logChan =  [ ("sysadmin", sysadmin)
            , ("s", sysadmin)
            , ("help", ayuda)
            , ("h", ayuda)
            , ("quit", terminar)
            , ("q", terminar)
            ]
            where ayuda = mostrarAyuda logChan

sysadmin :: IO ()
sysadmin = putStrLn "not implemented"
-- TODO: Hacer que este comando ejecute Sysadmin.imprimirPuntajes puntajeTVar""

mostrarAyuda :: TChan String -> IO ()
mostrarAyuda logChan = do
    log' "Imprimo ayuda" logChan
    putStrLn "ConcumonGo help:"
    putStrLn "\thelp - mostrar esta ayuda"
    putStrLn "\tquit - terminar el juego"
    putStrLn "\tsysadmin - verificar las estadísticas de los jugadores"

terminar :: IO ()
terminar = putStrLn "Cerrando Concumon GO!..."

log' :: String -> TChan String -> IO ()
log' = cgLog "Main"
