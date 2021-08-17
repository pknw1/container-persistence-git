FROM alpine:latest

RUN apk update && apk add git openssh bash

COPY ./start.sh /start.sh

ENTRYPOINT ["/start.sh"]
