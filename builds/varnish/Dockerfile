FROM ubuntu:16.04

RUN apt update -y && apt upgrade -y

RUN apt install -y varnish

CMD ["service", "varnish", "start"]
