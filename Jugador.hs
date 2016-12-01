module Jugador
( Jugador.main
) where

import Logger
import Grilla
import System.Random
import Control.Concurrent
import Control.Concurrent.STM

-- El Jugador va a ejecutar movimientos cada cierto tiempo al azar y lo envía por el canal
-- haciendo un writeChan de eventChannel y el Juego se va a encargar de procesar
-- lo que haga falta. Debe haber un random (0,1) para ver si el jugador quiere seguir
-- jugando. Una vez que deja el juego se hace un signalQSem de semMaxJug para habilitar
-- al Server para que pueda entrar otro jugador, si es que hay.

main :: Int -> Posicion -> QSem -> QSem -> TVar [[Int]] -> TChan Int -> TChan String -> IO ()
main idJug pos semMaxJug semLeer sharedGrid puntajeChan logChan = do

    log' ("Soy un nuevo jugador (id " ++ show idJug ++ "). Comienzo en " ++ show pos) logChan
    -- Me inicializo para el sistema de puntaje
    atomically $ writeTChan puntajeChan idJug

    -- Me muevo hasta que me aburra (rándom)
    moverse idJug semLeer sharedGrid pos puntajeChan logChan
    -- Libero una posición para otro jugador
    signalQSem semMaxJug
    log' ("Saliendo del juego (id " ++ show idJug ++ ")") logChan

-- Mueve al jugador en el tablero (buscando un concumón) o deja de jugar
moverse :: Int -> QSem -> TVar [[Int]] -> Posicion -> TChan Int ->TChan String -> IO ()
moverse idJug semLeer sharedGrid posActual puntajeChan logChan = do
    -- tiro la moneda para ver si quiero seguir jugando
    gen <- newStdGen
    if numRand gen 2 == 0
        then
            log' ("Ya me cansé (id " ++ show idJug ++ ")") logChan
        else do
            -- Elijo aleatoriamente alguna dirección de casillero contiguo
            waitQSem semLeer  -- {2}
            log' ("Intentando hacer movimiento! (" ++ show idJug ++ ")") logChan
            grid <- atomically $ readTVar sharedGrid

            -- El jugador sólo revisa cuando se mueve (o sea, no se fija si hay un
            -- concumón en su posición actual, sólo en su siguiente posición)
            let posicionesVecinas = Grilla.getPosicionesVecinas grid posActual
            posElegida <- elegirPosicionRandom posicionesVecinas

            let hayConcumon = Grilla.getValorPosicion grid (getX posElegida) (getY posElegida)
            log' ("Estoy en posición "++ show posActual ++" y me muevo a "++ show posElegida++" (" ++ show idJug ++ ")") logChan
            if hayConcumon == 1
                then do
                    log' ("Encontré un concumón en "++ show posElegida ++". Tirando pokebolaaa ... ATRAPADO! :) (" ++ show idJug ++ ")") logChan
                    -- Atrapo al concumón
                    Grilla.updateGrid sharedGrid (getX posElegida) (getY posElegida) 0
                    actualizarPuntaje puntajeChan idJug logChan
                else
                    log' ("No había nada :( ... (idJug: " ++ show idJug ++ ")") logChan
            signalQSem semLeer

            threadDelay $ numRand gen 10 * 10^(6 :: Int)
            moverse idJug semLeer sharedGrid posElegida puntajeChan logChan

elegirPosicionRandom :: [Posicion] -> IO Posicion
elegirPosicionRandom posiciones = do
    gen <- newStdGen
    let tam = length posiciones - 1
        index = numRand gen tam
    return (posiciones !! index)

actualizarPuntaje :: TChan Int -> Int -> TChan String -> IO ()
actualizarPuntaje puntajeChan idJug logChan = do
    log' ("Encontré un concumón!!!!!!!!!!!!!! Actualizo mi puntaje (" ++ show idJug ++ ")") logChan
    --Envío puntaje al Sysadmin
    atomically $ writeTChan puntajeChan idJug

log' :: String -> TChan String -> IO ()
log' = cgLog "JUG"

-- {2} Acá usamos un semáforo para asegurar que un Jugador se moviera
-- a la vez y no se pisaran. Otra forma posible era mediante una acción
-- STM con el sharedGrid ya que es un TVar.
