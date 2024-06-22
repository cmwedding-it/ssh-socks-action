#!/usr/bin/env bash

set -e

mkdir "$HOME/.ssh"

if [ -n "$INPUT_SOCKS5_PWD" ]; then
  export SOCKS5_PASSWD="$INPUT_SOCKS5_PWD"
fi

if [[ ! "$INPUT_PROXY_SERVER" =~ ^\d ]]; then
  echo "The proxy host doesn't seem to be an IP, resolving via dig..."
  INPUT_PROXY_SERVER=$(dig +short "$INPUT_PROXY_SERVER")
fi

config="$HOME/.ssh/config"

echo "Host ${INPUT_HOST}" > "$config"
echo "  User ${INPUT_USERNAME}" >> "$config"
echo "  Port ${INPUT_PORT}" >> "$config"

if [ -n "$INPUT_PROXY_USERNAME" ]; then
  INPUT_PROXY_USERNAME="$INPUT_PROXY_USERNAME@"
fi

echo "  ProxyCommand connect -S ${INPUT_PROXY_USERNAME}${INPUT_PROXY_SERVER}:${INPUT_PROXY_PORT} %h %p" >> "$config"

if [ -z "$INPUT_KEY" ]
then
  echo "Using password"
  export SSHPASS="$PASS"
  sshpass -e ssh -o StrictHostKeyChecking=accept-new "$INPUT_HOST" "$INPUT_RUN"
else
  echo "Using private key"
  echo "$INPUT_KEY" > "$HOME/.ssh/id_rsa"
  chmod 400 "$HOME/.ssh/id_rsa"

  echo "  IdentityFile $HOME/.ssh/id_rsa" >> "$config"
  cat "$HOME/.ssh/config"

  ssh -o StrictHostKeyChecking=accept-new "$INPUT_HOST" "$INPUT_RUN"
fi
