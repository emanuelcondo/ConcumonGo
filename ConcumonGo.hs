import qualified Juego
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Config
import Control.Concurrent
import Control.Concurrent.STM


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
    putStrLn ("[Main]\tCargando parametros de configuracion")
    maxJug <- maxJugadores
    putStrLn ("[Main]\tMáxima cantidad de jugadores es " ++ show maxJug)

    esperandoLogueo

    putStrLn "[Main]\tCerrando ConcumonGo"



-- Funcion que espera logueos nuevos de jugadores
esperandoLogueo = do
        putStrLn ("[SVR]\tEsperando Logueos de Jugadores")
        -- Usar takeTMVar SolicitudLogueo
        -- En caso de no haber solicitudes de logueo se queda bloquedo esperando nuevas solicitudes.

        threadDelay $ 5 * 10^(6 :: Int)