FROM golang:1.16-alpine as sources

RUN mkdir /src
WORKDIR /src

ADD . .
RUN go build .


FROM debian:stable-slim as ssl
RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates


FROM alpine
COPY --from=sources /src/hello /etc/hello
COPY --from=ssl /etc/ssl/certs /etc/ssl/certs

EXPOSE 9080
CMD /etc/hello
