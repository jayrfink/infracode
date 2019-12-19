FROM golang:1.8-alpine
ADD . /go/src/simple-www
RUN go install simple-www

FROM alpine:latest
COPY --from=0 /go/bin/simple-www .
ENV PORT 8080
CMD ["./simple-www"]
