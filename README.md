# 2° Proyecto de Técnicas de Programación Concurrente I

## Instalación de GHC

Para descargar el compilador GHC, pueden hacerlo desde [aquí](https://www.haskell.org/platform/).

## Dependencias
```sh
$ sudo cabal install ConfigFile
```

## Generación de ejecutable
Para generar el ejecutable, se debe ejecutar el siguiente comando.
En caso de error, verifique que el archivo posea los permisos de ejecución.
```sh
$ ./buildConcumonGo.sh
```

## Ejecución de la simulación
```sh
$ ./ConcumonGo
```
