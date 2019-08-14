#!/bin/bash

readonly TARGET=$(basename $(pwd))
SRC="./main.d"
SRC="$SRC ./system/core.d ./system/functional.d ./system/linq.d"
SRC="$SRC ./project-euler/foundation.d"
SRC="$SRC ./project-euler/problem001.d"
SRC="$SRC ./project-euler/problem002.d"
SRC="$SRC ./project-euler/problem003.d"
SRC="$SRC ./project-euler/problem004.d"
SRC="$SRC ./project-euler/problem005.d"
SRC="$SRC ./project-euler/problem006.d"
SRC="$SRC ./project-euler/problem007.d"
SRC="$SRC ./project-euler/problem008.d"
SRC="$SRC ./project-euler/problem009.d"
SRC="$SRC ./project-euler/problem010.d"
SRC="$SRC ./project-euler/problem011.d"
SRC="$SRC ./project-euler/problem012.d"
SRC="$SRC ./project-euler/problem013.d"
SRC="$SRC ./project-euler/problem014.d"
SRC="$SRC ./project-euler/problem015.d"
SRC="$SRC ./project-euler/problem016.d"
SRC="$SRC ./project-euler/problem017.d"
SRC="$SRC ./project-euler/problem018.d"
SRC="$SRC ./project-euler/problem019.d"
SRC="$SRC ./project-euler/problem020.d"
SRC="$SRC ./project-euler/problem021.d"
SRC="$SRC ./project-euler/problem022.d"
SRC="$SRC ./project-euler/problem023.d"
SRC="$SRC ./project-euler/problem024.d"
SRC="$SRC ./project-euler/problem025.d"
SRC="$SRC ./project-euler/problem026.d"
SRC="$SRC ./project-euler/problem027.d"
SRC="$SRC ./project-euler/problem028.d"
SRC="$SRC ./project-euler/problem029.d"
SRC="$SRC ./project-euler/problem030.d"
SRC="$SRC ./project-euler/problem031.d"
SRC="$SRC ./project-euler/problem032.d"
SRC="$SRC ./project-euler/problem033.d"
SRC="$SRC ./project-euler/problem034.d"
SRC="$SRC ./project-euler/problem035.d"
SRC="$SRC ./project-euler/problem036.d"
SRC="$SRC ./project-euler/problem037.d"
SRC="$SRC ./project-euler/problem038.d"
SRC="$SRC ./project-euler/problem039.d"
SRC="$SRC ./project-euler/problem040.d"
SRC="$SRC ./project-euler/problem041.d"
SRC="$SRC ./project-euler/problem042.d"
SRC="$SRC ./project-euler/problem043.d"
SRC="$SRC ./project-euler/problem044.d"

DMD_DEBUG=1
DMD_RELEASE=0
DMD_UNITTEST=0
DMD_DDOC=0
while [ "$1" != '' ]
do
    case "$1" in
    debug)
        DMD_DEBUG=1
        DMD_RELEASE=0
        ;;
    release)
        DMD_DEBUG=0
        DMD_RELEASE=1
        ;;
    unittest)
        DMD_UNITTEST=1
        ;;
    ddoc|documentation)
        DMD_DDOC=1
        ;;
    *)
        echo "Unknown argument '$1'" >&2
        exit 1
        ;;
    esac
    shift
done

                         CFLAGS=""
                         CFLAGS="$CFLAGS -color=on"
[ $DMD_DDOC     = 1 ] && CFLAGS="$CFLAGS -D"
[ $DMD_DDOC     = 1 ] && CFLAGS="$CFLAGS -Dddoc"
                         CFLAGS="$CFLAGS -de"
[ $DMD_DEBUG    = 1 ] && CFLAGS="$CFLAGS -debug"
                         CFLAGS="$CFLAGS -fPIC"
                         CFLAGS="$CFLAGS -g"
[ $DMD_RELEASE  = 1 ] && CFLAGS="$CFLAGS -inline"
[ $DMD_RELEASE  = 1 ] && CFLAGS="$CFLAGS -O"
                         CFLAGS="$CFLAGS -odobj"
                         CFLAGS="$CFLAGS -of$TARGET"
[ $DMD_RELEASE  = 1 ] && CFLAGS="$CFLAGS -release"
[ $DMD_UNITTEST = 1 ] && CFLAGS="$CFLAGS -unittest"
                         CFLAGS="$CFLAGS -w"

echo dmd $CFLAGS $SRC
dmd $CFLAGS $SRC
