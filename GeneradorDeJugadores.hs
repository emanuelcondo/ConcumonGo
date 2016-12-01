module GeneradorDeJugadores
( GeneradorDeJugadores.main
) where

import Jugador
import Grilla
import Logger
import ListaPuntaje

import Control.Concurrent
import Control.Concurrent.STM

-- Cada vez que hay lugar para loggear un nuevo jugador, lo genera, id creciente
-- Esto se media entre los canales de login, para requestear y ser aceptado

main :: QSem -> QSem -> TVar [[Int]] -> TChan Int -> TChan Int -> TChan Int -> TChan String -> IO ()
main semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan puntajeChan logChan = do
    log' "Iniciando Generador de Jugadores" logChan
    myAcceptLoginChan <- atomically $ dupTChan acceptLoginChan
    generarJugador 1 semMaxJug semLeer sharedGrid requestLoginChan myAcceptLoginChan puntajeChan logChan
    log' "Cerrando Generador De Jugadores" logChan

generarJugador :: Int -> QSem -> QSem -> TVar [[Int]] -> TChan Int -> TChan Int -> TChan Int -> TChan String -> IO ()
generarJugador idJug semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan puntajeChan logChan
    | idJug >= maxGenJug = do
        log' "Límite de jugadores para generar alcanzado" logChan
        putStrLn "Límite de jugadores para generar alcanzado"
    | otherwise = do
        log' ("Genero Jugador con id " ++ show idJug) logChan
        atomically $ writeTChan requestLoginChan idJug
        -- No escribo más al RLChan hasta que sea aceptado este,
        -- por lo que no hace falta chequear que sea para él en el retorno {1}
        _ <- atomically $ readTChan acceptLoginChan
        pos <- generarPosRand
        _ <- forkIO (Jugador.main idJug pos semMaxJug semLeer sharedGrid puntajeChan logChan)
        log' (show idJug ++ " ingresó en " ++ show pos) logChan
        generarJugador (idJug + 1) semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan puntajeChan logChan

log' :: String -> TChan String -> IO ()
log' = cgLog "GDJ"

-- {1} En caso de que se crearan por separado y cada Jugador
-- esperara su propio login, estos leerían del canal y se fijarían
-- si fueron ellos los aceptados. Como es un broadcast channel,
-- y cada uno tendría una copia (dupTChan) de este,
-- leer no le quitaría el item al canal de los demás clientes.

-- Otra forma de hacer la espera de login sería con un simple
-- semáforo, tal vez hasta el mismo que ya usa el servidor.
-- De igual manera, esto limitaría pasarle info al Jugador
-- recién loggeado.
