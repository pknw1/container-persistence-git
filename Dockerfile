FROM alpine:latest

RUN apk update && apk add git openssh bash

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
