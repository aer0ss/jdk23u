#!/bin/bash

set -e -x -u -o pipefail

output_suffix=$1

shift

bash configure \
  --with-jvm-features=-zero,-dtrace,-epsilongc,-parallelgc,-shenandoahgc,-zgc,-management,-services,-jvmti,-jvmci,-jfr,-vm-structs,-jni-check \
  --with-native-debug-symbols=none \
  --disable-manpages \
  $@

make images

jlink=(build/*/images/jdk/bin/jlink)

"${jlink[@]}" \
  --add-modules java.base,java.management,java.naming,java.security.jgss,java.sql,jdk.unsupported \
  --no-header-files --no-man-pages \
  --output build/jre

tar -C build -cf "jre-${output_suffix}.tar" jre
gzip -9 "jre-${output_suffix}.tar"

