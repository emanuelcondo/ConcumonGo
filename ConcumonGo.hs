import Server
import Client

{- comentario -}
-- TODO otro comentario

main = do
    let server = Server True
    if inicializado server
        then
            putStrLn "iniciando Server"
        else
            putStrLn "chau...MIAMEEEE"
