import qualified NidoConcumones
import qualified Server
import qualified Sysadmin
import qualified GeneradorDeJugadores
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
    putStrLn "Concumon GO! v0.9"

    logChan <- atomically newTChan      -- Canal para imprimir en el log
    _ <- forkIO $ Logger.loggerThread logChan
    log' "Iniciando ConcumonGo" logChan

    log' "Cargando parámetros de configuración" logChan
    ancho  <- xGrilla
    alto   <- yGrilla
    maxJug <- maxJugadores      -- Cantidad máxima de jugadores loggeados

    log' "Creando estructuras de itc" logChan
    semMaxJug <- newQSem maxJug     -- Semáforo para el Server (para aceptar jugadores de manera acotada)
    requestLoginChannel <- atomically newTChan      -- Canal de mensajes para pedir login de jugadores
    acceptLoginChannel <- atomically newBroadcastTChan      -- Canal de mensajes para aceptar login de jugadores, de tipo broadcast
    puntajeChannel <- atomically newTChan      -- Canal que usa un jugador para avisar que suma puntaje

    -- Estructura para manejar el puntaje acumulado de Jugadores
    let listaPuntaje = crearListaPuntaje maxGenJug
    puntajeTVar <- atomically $ newTVar listaPuntaje

    -- Matriz de {0,1} -> 0: no hay concumón
    --                    1: hay un concumón
    let grid = Grilla.crearGrilla ancho alto
    log' ("Tamaño de la grilla: " ++ show ancho ++ " x " ++ show alto) logChan

    sharedGrid <- atomically $ newTVar grid
    semLeer <- newQSem 1    -- semáforo para leer sharedGrid

    _ <- forkIO (Server.main semMaxJug requestLoginChannel acceptLoginChannel logChan)
    _ <- forkIO (NidoConcumones.main semLeer sharedGrid logChan)
    _ <- forkIO (GeneradorDeJugadores.main semMaxJug semLeer sharedGrid requestLoginChannel acceptLoginChannel puntajeChannel logChan)
    _ <- forkIO (Sysadmin.main puntajeChannel puntajeTVar logChan)

    interfaz puntajeTVar logChan

    log' "Cerrando ConcumonGo" logChan
    Logger.endRun logChan

interfaz :: TVar [[Int]] -> TChan String -> IO ()
interfaz puntajeTVar logChan = do
    putStr "> "
    hFlush stdout
    input <- getLine
    let action = lookup input $ commands puntajeTVar logChan
    fromMaybe (putStrLn "Comando desconocido, 'help' para ayuda") action
    unless (input == "quit" || input == "q") $
        interfaz puntajeTVar logChan

commands :: TVar [[Int]] -> TChan String -> [(String, IO ())]
commands puntajeTVar logChan =
            [ ("sysadmin", sys)
            , ("s", sys)
            , ("help", ayuda)
            , ("h", ayuda)
            , ("quit", terminar)
            , ("q", terminar)
            ]
            where ayuda = mostrarAyuda logChan
                  sys = sysadmin puntajeTVar

sysadmin :: TVar [[Int]] -> IO ()
sysadmin = Sysadmin.imprimirPuntajes

mostrarAyuda :: TChan String -> IO ()
mostrarAyuda logChan = do
    log' "Imprimo ayuda" logChan
    putStrLn "ConcumonGo help:"
    putStrLn "\thelp - mostrar esta ayuda"
    putStrLn "\tquit - terminar el juego"
    putStrLn "\tsysadmin - verificar las estadísticas de los jugadores"

terminar :: IO ()
terminar = putStrLn "Cerrando Concumon GO!"

log' :: String -> TChan String -> IO ()
log' = cgLog "Main"
