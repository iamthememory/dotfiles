#!/bin/sh

# Add JUnit to our CLASSPATH.

if [ -e "/usr/share/junit/lib/junit.jar" ]
then
  CLASSPATH="$(munge.sh "${CLASSPATH}" /usr/share/junit/lib/junit.jar tail)"
  export CLASSPATH
fi
