source $stdenv/setup

mkdir -p $out/jars
ls $src
cp $src $out/jars

mkdir -p $out/bin
cat > $out/bin/ergo <<EOF
#!/bin/sh
exec $jre/bin/java \$JAVA_OPTS -jar $out/jars/$(basename $src) \$*
EOF
chmod +x $out/bin/ergo
