FROM alpine:3.21

LABEL "com.github.actions.name"="ssh-socks-action"
LABEL "com.github.actions.description"="Setup ssh socks5 proxy that use proxy-connect"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="black"

RUN apk add --no-cache \
  bash \
  openssh \
  sshpass \
  bind-tools \
  netcat-openbsd

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
