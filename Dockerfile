FROM golang:1.24-alpine@sha256:9a9ecb55b1826d81e53d85f9833abca9c89342e277329315b992dce1ae7ba703

RUN apk add --no-cache git bash

WORKDIR /repo

COPY src/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
