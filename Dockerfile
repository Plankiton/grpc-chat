FROM golang:1.14-alpine as builder
RUN apk --no-cache add git

WORKDIR /grpc-chat
COPY go.* ./

RUN go mod download

COPY . .
RUN go build -o server .

# --- Execution Stage

FROM alpine:latest
EXPOSE 6262/tcp

WORKDIR /bin
COPY --from=builder /grpc-chat/server /bin

ENTRYPOINT /bin/server -s -p $PASS -h "0.0.0.0:$PORT"
