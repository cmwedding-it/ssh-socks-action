FROM debian:trixie-slim

LABEL "com.github.actions.name"="ssh-socks-action"
LABEL "com.github.actions.description"="Setup ssh socks5 proxy that use proxy-connect"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="black"

RUN apt update && apt install -y sshpass dnsutils connect-proxy

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
