module GeneradorDeJugadores
( GeneradorDeJugadores.main
) where

import Jugador
import Juego
import Logger
import Config

import System.Random
import Control.Concurrent
import Control.Concurrent.STM

-- el main debe tener un loop donde cada cierto tiempo se intenta loggear
-- un nuevo jugador (incrementando el id, más fácil), hace un writeChan de requestLoginChannel
-- y luego hace un readChan a acceptLoginChannel (este último canal podría estar dentro de
-- Jugador.hs ya que sino se bloquearía el GeneradorDeJugadores).

main :: QSem -> TChan Int -> TChan Int -> Chan String -> IO ()
main semMaxJug requestLoginChan acceptLoginChan eventChan = do
    log' "Iniciando Generador de Jugadores"
    myAcceptLoginChan <- atomically $ dupTChan acceptLoginChan
    generarJugador 1 semMaxJug requestLoginChan myAcceptLoginChan eventChan
    -- TODO: waitChildren
    log' "Cerrando Generador De Jugadores"

generarJugador :: Int -> QSem -> TChan Int -> TChan Int -> Chan String -> IO ()
generarJugador idJug semMaxJug requestLoginChan acceptLoginChan eventChan = do
    log' $ "Genero Jugador con id " ++ show idJug
    atomically $ writeTChan requestLoginChan idJug
    -- No escribo más al RLChan hasta que sea aceptado este,
    -- por lo que no me hace falta chequear que sea para él en el retorno {1}
    _ <- atomically $ readTChan acceptLoginChan
    pos <- generarPosRand
    thrId <- forkIO (Jugador.main idJug pos semMaxJug eventChan)
    -- TODO: Reemplazar por método que los guarde y espere al final
    log' $ show idJug ++ " ingresó en " ++ show pos ++ ", con " ++ show thrId
    generarJugador (idJug + 1) semMaxJug requestLoginChan acceptLoginChan eventChan


generarPosRand :: IO Posicion
generarPosRand = do
    genX <- newStdGen
    genY <- newStdGen
    maxX <- xGrilla
    maxY <- yGrilla
    let x = numRand genX (maxX - 1)
        y = numRand genY (maxY - 1)
    return $ Posicion x y

numRand :: StdGen -> Int -> Int
numRand gen max' = head $ randomRs (0, max') gen

-- generarPosRand :: Int -> IO Posicion
-- generarPosRand id'  = do
--     gen <- newStdGen
--     maxX <- xGrilla
--     maxY <- yGrilla
--     let pos = randomPos gen id' maxX maxY
--     print pos
--     return pos

-- randomPos :: StdGen -> Int -> Int -> Int -> Posicion
-- randomPos gen id' maxX maxY = Posicion x y
--     where x = (randomRs (maxX) gen) !! (2 * id')
--           y = rand !! (2 * id' + 1)
--           rand = randomRs (maxX, maxY) gen

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
