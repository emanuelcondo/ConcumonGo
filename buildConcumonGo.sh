# /usr/bin/env sh
ghc --make ConcumonGo.hs
rm *.o
rm *.hi
rm logtemp* 2> /dev/null
