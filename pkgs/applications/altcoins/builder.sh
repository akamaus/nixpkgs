source $stdenv/setup

mkdir -p $out/jars
ls $src
cp $src $out/jars

mkdir -p $out/bin
cat > $out/bin/ergo <<EOF
exec $jre/bin/java -jar $out/jars/$(basename $src) \$*
EOF
chmod +x $out/bin/ergo
