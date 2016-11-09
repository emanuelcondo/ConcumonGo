import qualified Juego
import qualified Server
import qualified GeneradorDeJugadores
import qualified Sysadmin
import Control.Concurrent

main :: IO ()
main = do
    putStrLn "[Main]\tIniciando ConcumonGo"
    threadDelay $ 2 * 10^(6 :: Integer)
    _ <- forkIO Juego.main
    _ <- forkIO Server.main
    _ <- forkIO GeneradorDeJugadores.main
    _ <- forkIO Sysadmin.main
    -- estaría bueno ver la forma de que este main espere
    -- a que termine los 2 threads anteriores (el delay es temporal, ya que si
    -- termina este thread se "matan" a los otros thread sin terminar)
    threadDelay $ 2 * 10^(6 :: Int)
    putStrLn "[Main]\tCerrando ConcumonGo"
