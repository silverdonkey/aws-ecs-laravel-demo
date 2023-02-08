#!/bin/sh
set -e

if [ ! -z "$WWWUID" ]; then
    # Set UID of user "node"
    usermod -u $WWWUID node > /dev/null 2>&1
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

if [ ! -z "$WWWUID" ]; then
    exec gosu node "$@"
else
    exec "$@"
fi
