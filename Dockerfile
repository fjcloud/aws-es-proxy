FROM golang:1.9-alpine

WORKDIR /go/src/
COPY . .

RUN apk add --update bash curl git && \
    rm /var/cache/apk/*

RUN mkdir -p $$GOPATH/bin && \
    curl https://glide.sh/get | sh

RUN glide install
RUN CGO_ENABLED=0 GOOS=linux go build -o aws-es-proxy


FROM alpine:3.7
LABEL name="aws-es-proxy" \
      version="latest"

RUN apk --no-cache add ca-certificates
WORKDIR /home/
COPY --from=0 /go/src/aws-es-proxy /usr/local/bin/

EXPOSE 9200

ENTRYPOINT ["aws-es-proxy"] 
CMD ["-endpoint ${AWS_ES_ENDPOINT}"]
