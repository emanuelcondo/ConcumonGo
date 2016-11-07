import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Control.Concurrent

main = do
    putStrLn "[Main]\tIniciando ConcumonGo"
    threadDelay $ 2 * 10^6
    forkIO (Juego.main)
    forkIO (Server.main)
    forkIO (GeneradorDeJugadores.main)
    forkIO (Sysadmin.main)
    -- estaría bueno ver la forma de que este main espere
    -- a que termine los 2 threads anteriores (el delay es temporal, ya que si
    -- termina este thread se "matan" a los otros thread sin terminar)
    threadDelay $ 2 * 10^6
    putStrLn "[Main]\tCerrando ConcumonGo"
