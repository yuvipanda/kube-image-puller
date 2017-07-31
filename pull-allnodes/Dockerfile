FROM alpine:3.5

RUN apk add --no-cache jq

WORKDIR /tmp

ADD https://storage.googleapis.com/kubernetes-release/release/v1.7.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ADD pulljob.yaml pulljob.yaml
ADD allnodes.sh /usr/local/bin/allnodes.sh

RUN chmod +x /usr/local/bin/kubectl && chmod +x /usr/local/bin/allnodes.sh

ENTRYPOINT ["/usr/local/bin/allnodes.sh"]
