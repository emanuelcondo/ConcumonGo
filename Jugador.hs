module Jugador
( Jugador.main
) where

import Logger
import Juego
import Control.Concurrent

-- el Jugador va a ejecutar movimientos cada cierto tiempo al azar y lo envía por el canal
-- haciendo un writeChan de eventChannel y el Juego se va a encargar de procesar
-- lo que haga falta. Debe haber un random (0,1) para ver si el jugador quiere seguir
-- jugando. Una vez que deja el juego se hace un signalQSem de semMaxJug para habilitar
-- al Server para que pueda entrar otro jugador, si es que hay.

main :: Int -> Posicion -> QSem -> Chan String -> IO ()
main idJug pos semMaxJug eventChannel = do

    log' $ "Soy un nuevo jugador (id " ++ show idJug ++ ")"
    --loguearse
    --log' "Logueo correcto."
    log' $ "Comienzo en " ++ show pos ++ " (id " ++ show idJug ++ ")"
    --TODO escribir en eventChannel dónde comienzo
    moverse

    actualizarPuntaje eventChannel

    threadDelay $ 10 * 10^(6 :: Int)---

    log' $ "Ya me cansé (id " ++ show idJug ++ ")"
    signalQSem semMaxJug
    log' $ "Saliendo del juego (id " ++ show idJug ++ ")"


-- -- Funcion que permite loguear el jugador en el Servidor.module
-- loguearse :: IO ()
-- loguearse = do
--     log' "Me intento loguear."
--     -- Usar putTMVar
-- // El jugador ya se logueó desde Server

-- Funcion que pone a mover el jugador en en tablero.
moverse :: IO ()
moverse = do
    -- Elijo aleatoreamente alguna direccion de casillero contiguo
    log' "Estoy en posición: (x1,y1) me muevo a (x2,y2)"
    -- Hago un readTvar para ver si el casillero está libre, sino repito.module
    -- mc: Se puede hacer con retry (https://en.wikipedia.org/wiki/Concurrent_Haskell)
    -- Con writeTvar escribo mi nueva posicion en tablero.


actualizarPuntaje :: Chan String -> IO ()

actualizarPuntaje eventChannel = do
    log' "Encontré concumón, actualizo puntaje"

    --Envio Puntaje al Sysadmin
    writeChan eventChannel "idJugador,Puntaje"
    -- Actualiza su puntaje en el Sysadmin.


log' :: String -> IO ()
log' = cgLog "JUG"
