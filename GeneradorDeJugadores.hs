module GeneradorDeJugadores
( GeneradorDeJugadores.main
) where

import Jugador
import Juego
import Logger

import Control.Concurrent
import Control.Concurrent.STM

-- el main debe tener un loop donde cada cierto tiempo se intenta loggear
-- un nuevo jugador (incrementando el id, más fácil), hace un writeChan de requestLoginChannel
-- y luego hace un readChan a acceptLoginChannel (este último canal podría estar dentro de
-- Jugador.hs ya que sino se bloquearía el GeneradorDeJugadores).

main :: QSem -> QSem -> TVar [[Int]] -> TChan Int -> TChan Int -> Chan String -> IO ()
main semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan eventChan = do
    log' "Iniciando Generador de Jugadores"
    myAcceptLoginChan <- atomically $ dupTChan acceptLoginChan
    generarJugador 1 semMaxJug semLeer sharedGrid requestLoginChan myAcceptLoginChan eventChan
    -- TODO: waitChildren
    log' "Cerrando Generador De Jugadores"

generarJugador :: Int -> QSem -> QSem -> TVar [[Int]] -> TChan Int -> TChan Int -> Chan String -> IO ()
generarJugador idJug semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan eventChan = do
    log' $ "Genero Jugador con id " ++ show idJug
    atomically $ writeTChan requestLoginChan idJug
    -- No escribo más al RLChan hasta que sea aceptado este,
    -- por lo que no me hace falta chequear que sea para él en el retorno {1}
    _ <- atomically $ readTChan acceptLoginChan
    pos <- generarPosRand
    thrId <- forkIO (Jugador.main idJug pos semMaxJug semLeer sharedGrid eventChan)
    -- TODO: Reemplazar por método que los guarde y espere al final
    log' $ show idJug ++ " ingresó en " ++ show pos ++ ", con " ++ show thrId
    generarJugador (idJug + 1) semMaxJug semLeer sharedGrid requestLoginChan acceptLoginChan eventChan


log' :: String -> IO ()
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
