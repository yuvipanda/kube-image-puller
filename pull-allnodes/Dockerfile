FROM alpine:3.5

RUN apk add --no-cache jq
ADD allnodes.sh /usr/local/bin/allnodes.sh
# AAAAHACKS

WORKDIR /tmp
ADD https://storage.googleapis.com/kubernetes-release/release/v1.5.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl && chmod +x /usr/local/bin/allnodes.sh

ADD pulljob.yaml pulljob.yaml

ENTRYPOINT ["/usr/local/bin/allnodes.sh"]
