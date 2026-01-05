# Container image that runs your code
FROM debian:stable-slim

RUN apt update && apt install -y \
    wget

ARG VERSION=v4.30.6
ARG BINARY=yq_linux_amd64

RUN wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
