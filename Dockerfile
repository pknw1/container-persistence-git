FROM ubuntu:latest

RUN apt update && apt install -y git

COPY ./start.sh /start.sh

ENTRYPOINT ["/start.sh"]
