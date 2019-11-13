FROM golang:1.9-alpine

WORKDIR /go/src/github.com/abutaha/aws-es-proxy
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

WORKDIR /home/
COPY --from=0 /go/src/github.com/abutaha/aws-es-proxy/aws-es-proxy /usr/local/bin/
COPY run.sh .
RUN apk --no-cache add ca-certificates && chmod +x /home/run.sh

EXPOSE 9200

ENTRYPOINT ["/home/run.sh"]
