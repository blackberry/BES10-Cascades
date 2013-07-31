
#.qml .hpp .cpp .h

QML=`find . -name '*.qml'`

for f in $QML
do
	cat ./header.tmp $f  > $f.tmp
	mv $f.tmp $f
done

HPP=`find . -name '*.hpp'`

for f in $HPP
do
	cat ./header.tmp $f  > $f.tmp
        mv $f.tmp $f
done

CPP=`find . -name '*.cpp'`

for f in $CPP
do
        cat ./header.tmp $f  > $f.tmp
        mv $f.tmp $f
done

HEADERFILES=`find . -name '*.h'`

for f in $HEADERFILES
do
        cat ./header.tmp $f  > $f.tmp
        mv $f.tmp $f
done

