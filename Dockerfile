# build stage
FROM golang:1.10 AS builder
LABEL maintainer = "ekiny018@gmail.com"
ADD https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 /usr/bin/dep
RUN chmod +x /usr/bin/dep
RUN mkdir -p /go/src/go_rest_api
WORKDIR /go/src/go_rest_api
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -vendor-only
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /app .

# final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app ./
RUN chmod +x ./app
ENTRYPOINT ["./app"] 
EXPOSE 3030
