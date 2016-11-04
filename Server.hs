module Server where

data Server = Server {
                        init::Bool
                    } deriving Show



inicializado :: Server -> Bool
inicializado (Server init) = init
