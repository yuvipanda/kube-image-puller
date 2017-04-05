FROM alpine:3.5

RUN apk add --no-cache curl jq

ADD pull-image /usr/local/bin/pull-image

ENTRYPOINT ["/usr/local/bin/pull-image"]
