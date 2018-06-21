#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for sparklecoind"

  set -- sparklecoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "sparklecoind" ]; then
  mkdir -p "$SPRK_DATA"
  chmod 700 "$SPRK_DATA"
  chown -R coin "$SPRK_DATA"

  echo "$0: setting data directory to $SPRK_DATA"

  set -- "$@" -datadir="$SPRK_DATA"
fi

if [ ! -f $SPRK_DATA/sparklecoin.conf ]; then
  	cat <<-EOF > "$SPRK_DATA/sparklecoin.conf"
      rpcpassword=${SPRK_RPC_PASSWORD:-password}
      rpcuser=${SPRK_RPC_USER:-bitcoin}
		EOF
fi

if [ "$1" = "sparklecoind" ]; then
  echo
  exec gosu coin "$@"
fi

echo
exec "$@"
