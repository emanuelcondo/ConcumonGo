module Jugador where
import Control.Monad
import Control.Concurrent

data Posicion = Posicion
    { x :: Int
    , y :: Int
    }
    deriving (Show)

-- el Jugador va a ejecutar movimientos cada cierto tiempo al azar y lo envía por el canal
-- haciendo un writeChan de eventChannel y el Juego se va a encargar de procesar
-- lo que haga falta. Debe haber un random (0,1) para ver si el jugador quiere seguir
-- jugando. Una vez que deja el juego se hace un signalQSem de semMaxJug para habilitar
-- al Server para que pueda entrar otro jugador, si es que hay.

main :: QSem -> Chan String -> IO ()
main semMaxJug eventChannel = do
    putStrLn "[JUG]\tSoy un nuevo jugador"

    loguearse

    putStrLn "[JUG]\tLogueo correcto."

    moverse
    signalQSem semMaxJug
    putStrLn "[JUG]\tSaliendo del juego"


-- Funcion que permite loguear el jugador en el Servidor.module
loguearse :: IO ()
loguearse = do
    putStrLn "[JUG]\tMe intento loguear."
    -- Usar putTMVar


-- Funcion que pone a mover el jugador en en tablero.
moverse :: IO ()
moverse = do
    putStrLn "[JUG]\t Estoy en posicion: (x,y) me muevo A: "
    -- Elijo aleatoreamente alguna direccion de casillero contiguo
    -- Hago un readTvar para ver si el casillero esta libre, sino repito.module
    -- Con writeTvar escribo mi nueva posicion en tablero.


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    putStrLn "[JUG]\t Encontre pokemon, Actualizo Puntaje"
    -- Actualiza su puntaje en el Sysadmin.
