module Jugador
( Jugador.main
) where

import Logger
import Juego
import Grilla
import System.Random
import Control.Concurrent
import Control.Concurrent.STM
-- import System.IO.Error
-- import Control.Exception


-- el Jugador va a ejecutar movimientos cada cierto tiempo al azar y lo envía por el canal
-- haciendo un writeChan de eventChannel y el Juego se va a encargar de procesar
-- lo que haga falta. Debe haber un random (0,1) para ver si el jugador quiere seguir
-- jugando. Una vez que deja el juego se hace un signalQSem de semMaxJug para habilitar
-- al Server para que pueda entrar otro jugador, si es que hay.

main :: Int -> Posicion -> QSem -> QSem -> TVar [[Int]] -> Chan String -> TChan String -> IO ()
main = jugar
-- main :: Int -> Posicion -> QSem -> Chan String -> IO ()
-- main idJug pos semMaxJug eventChannel =
--     jugar idJug pos semMaxJug eventChannel `catchIOError` handler
--
-- ----- TODO: Borrar si no se termina usando
-- handler :: IOError -> IO ()
-- handler e
--     | isEOFError e = putStrLn "wooops"
--     | otherwise = ioError e

jugar :: Int -> Posicion -> QSem -> QSem -> TVar [[Int]] -> Chan String -> TChan String -> IO ()
jugar idJug pos semMaxJug semLeer sharedGrid eventChannel logChan = do

    log' ("Soy un nuevo jugador (id " ++ show idJug ++ ")") logChan
    --loguearse
    --log' "Logueo correcto."
    log' ("Comienzo en " ++ show pos ++ " (id " ++ show idJug ++ ")") logChan
    --TODO escribir en eventChannel dónde comienzo
    moverse idJug semLeer sharedGrid pos eventChannel logChan

    threadDelay $ 2 * 10^(6 :: Int)---

    signalQSem semMaxJug
    log' ("Saliendo del juego (id " ++ show idJug ++ ")") logChan


-- -- Funcion que permite loguear el jugador en el Servidor.module
-- loguearse :: IO ()
-- loguearse = do
--     log' "Me intento loguear."
--     -- Usar putTMVar
-- // El jugador ya se logueó desde Server

-- Funcion que pone a mover el jugador en en tablero.
moverse :: Int -> QSem -> TVar [[Int]] -> Posicion -> Chan String ->TChan String -> IO ()
moverse idJug semLeer sharedGrid posActual eventChannel logChan = do
    -- tiro la moneda para ver si quiero seguir jugando
    gen <- newStdGen
    let rdm = (numRand gen 2)

    if rdm == 0
        then
            log' ("Ya me cansé (id " ++ show idJug ++ ")") logChan
        else do
            -- Elijo aleatoreamente alguna direccion de casillero contiguo
            waitQSem semLeer
            log' ("Intentando hacer movimiento! (" ++ show idJug ++ ")") logChan
            grid <- atomically $ readTVar sharedGrid

            -- El jugador sólo revisa cuando se mueve (o sea, no se fija si hay un
            -- concumón en su posición actual, sólo en su siguiente posición)
            let posicionesVecinas = (Grilla.getPosicionesVecinas grid posActual)
            posElegida <- elegirPosicionRandom posicionesVecinas -- TODO debería ser el POSTA
            --let posElegida = Posicion (getX posActual) (getY posActual) -- TODO hardcodeado
            let hayConcumon = (Grilla.getValorPosicion grid (getX posElegida) (getY posElegida))
            log' ("Estoy en posición: "++ show posActual ++" me muevo a "++ show posElegida++" (" ++ show idJug ++ ")") logChan
            if hayConcumon == 1
                then do
                    log' ("Encontre un Concumon en "++ show posElegida ++". Tirando pokebolaaa!!!.ATRAPADO :) (" ++ show idJug ++ ")") logChan
                    Grilla.updateGrid sharedGrid (getX posElegida) (getY posElegida) 0
                    actualizarPuntaje eventChannel idJug logChan
                else
                    log' ("No había nada :( (idJug: " ++ show idJug ++ ")") logChan
            signalQSem semLeer
            threadDelay $ 4 * 10^(6 :: Int) -- TODO sleep debería ser random

            moverse idJug semLeer sharedGrid posElegida eventChannel logChan

            -- Hago un readTvar para ver si el casillero está libre, sino repito.module
            -- mc: Se puede hacer con retry (https://en.wikipedia.org/wiki/Concurrent_Haskell)
            -- Con writeTvar escribo mi nueva posicion en tablero.

elegirPosicionRandom :: [Posicion] -> IO Posicion
elegirPosicionRandom posiciones = do
    gen <- newStdGen
    let tam = length posiciones - 1
        index = numRand gen tam
    return (posiciones !! index)


actualizarPuntaje :: Chan String -> Int -> TChan String -> IO ()
actualizarPuntaje eventChannel idJug logChan = do
    log' "Encontré concumón, actualizo puntaje" logChan

    --Envio Puntaje al Sysadmin
    let idJugS = show idJug
    writeChan eventChannel idJugS
    -- Actualiza su puntaje en el Sysadmin.


log' :: String -> TChan String -> IO ()
log' = cgLog "JUG"
