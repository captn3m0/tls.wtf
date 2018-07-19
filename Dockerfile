FROM alpine:3.8

WORKDIR /tls.wtf

RUN apk update && apk add openssl curl ca-certificates nano \
	man man-pages openssl-doc && \
	apk upgrade && apk add --no-cache cfssl  \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

COPY . /tls.wtf

COPY markdown.nanorc /root/.nanorc

ENTRYPOINT ["/bin/ash"]