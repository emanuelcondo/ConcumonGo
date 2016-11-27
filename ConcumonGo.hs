import qualified Juego
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Config
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad
import Data.Maybe


data Jugador = Jugador {
              nombre :: String,
              id :: Int
              }

-- Estructura que permite a un jugador solicitar logueo.
type SolicitudLogueo = TMVar Jugador


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
    maxJug <- maxJugadores
    putStrLn $ "[Main]\tMáxima cantidad de jugadores es " ++ show maxJug

    esperandoLogueo

    interfaz

    putStrLn "[Main]\tCerrando ConcumonGo"

-- Función que espera logueos nuevos de jugadores
esperandoLogueo :: IO ()
esperandoLogueo = do
        putStrLn "[SVR]\tEsperando logueos de Jugadores"
        -- Usar takeTMVar SolicitudLogueo
        -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.
        threadDelay $ 5 * 10^(6 :: Int)


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
