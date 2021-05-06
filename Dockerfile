FROM golang:1.16-alpine as sources
RUN apk add wget unzip

RUN mkdir /src
WORKDIR /src

ADD . .
RUN go generate
RUN go build .


FROM debian:stable-slim as ssl
RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates


FROM alpine
COPY --from=sources /src/coredns /etc/coredns/coredns
COPY --from=sources /src/Corefile /etc/coredns/Corefile
COPY --from=ssl /etc/ssl/certs /etc/ssl/certs

EXPOSE 53 53/udp
EXPOSE 8080
EXPOSE 8081
CMD /etc/coredns/coredns -conf /etc/coredns/Corefile
