module Jugador
( Jugador.main
) where

import Logger
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

    log' "Soy un nuevo jugador"
    loguearse
    log' "Logueo correcto."
    moverse
    signalQSem semMaxJug
    log' "Saliendo del juego"


-- Funcion que permite loguear el jugador en el Servidor.module
loguearse :: IO ()
loguearse = do
    log' "Me intento loguear."
    -- Usar putTMVar


-- Funcion que pone a mover el jugador en en tablero.
moverse :: IO ()
moverse = do
    -- Elijo aleatoreamente alguna direccion de casillero contiguo
    log' "Estoy en posicion: (x,y) me muevo a: "
    -- Hago un readTvar para ver si el casillero está libre, sino repito.module
    -- mc: Se puede hacer con retry (https://en.wikipedia.org/wiki/Concurrent_Haskell)
    -- Con writeTvar escribo mi nueva posicion en tablero.


actualizarPuntaje :: IO ()
actualizarPuntaje = do
    log' "Encontre pokemon, Actualizo Puntaje"
    -- Actualiza su puntaje en el Sysadmin.


log' :: String -> IO ()
log' = cgLog "JUG"
