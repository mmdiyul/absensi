FROM golang:1.24-alpine

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o absensi-app main.go

CMD ["./absensi-app"]