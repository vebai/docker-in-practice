FROM golang:1.27-alpine
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp main.go
EXPOSE 8080
CMD ["./myapp"]
