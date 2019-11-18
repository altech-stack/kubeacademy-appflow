FROM golang:alpine as builder

RUN apk update && apk add --no-cache ca-certificates && update-ca-certificates

COPY main.go .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o go-app

##########################

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/go-app /

ENTRYPOINT ["./go-app"]