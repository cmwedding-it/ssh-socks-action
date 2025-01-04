#!/usr/bin/env bash

set -e

mkdir -p "$HOME/.ssh"

if [ -n "$INPUT_SOCKS5_PWD" ]; then
  export SOCKS5_PASSWD="$INPUT_SOCKS5_PWD"
fi

if [[ ! "$INPUT_PROXY_SERVER" =~ ^\d ]]; then
  echo "The proxy host doesn't seem to be an IP, resolving via dig..."
  INPUT_PROXY_SERVER=$(dig +short "$INPUT_PROXY_SERVER")
fi

if [ -n "$INPUT_PROXY_USERNAME" ]; then
  INPUT_PROXY_USERNAME="$INPUT_PROXY_USERNAME@"
fi

cat >"$HOME/.ssh/config" <<EOL
Host ${INPUT_HOST}
    User ${INPUT_USERNAME}
    Port ${INPUT_PORT}
    ProxyCommand nc -X connect -x ${INPUT_PROXY_USERNAME}${INPUT_PROXY_SERVER}:${INPUT_PROXY_PORT} %h %p
EOL

if [ -z "$INPUT_KEY" ]
then
  echo "Using password"

  export SSHPASS="$PASS"
  sshpass -e ssh -o StrictHostKeyChecking=accept-new "$INPUT_HOST" "$INPUT_RUN"
else
  echo "Using private key"

  echo "$INPUT_KEY" > "$HOME/.ssh/id_rsa"
  chmod 400 "$HOME/.ssh/id_rsa"

  echo "    IdentityFile $HOME/.ssh/id_rsa" >> "$HOME/.ssh/config"

  ssh -o StrictHostKeyChecking=accept-new "$INPUT_HOST" "$INPUT_RUN"
fi
