FROM ubuntu:latest

RUN apt update && apt install -y git

COPY ./start.sh /start.sh
COPY ./sync-www.sh /sync-www.sh

ENTRYPOINT ["/start.sh"]
