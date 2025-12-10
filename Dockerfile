# --- Stage 1: Build the Go application ---
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
# CGO_ENABLED=0 is often used to create statically linked binaries
# -o /app/absensi specifies the output path and name of the binary
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o /app/absensi ./main.go

# --- Stage 2: Create a minimal final image ---
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/absensi /app/absensi
# Copy configuration files (like database.go or others in 'configs') if needed
COPY configs/ /app/configs/

# Set environment variables (optional, but good practice)
ENV PORT=8080

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["/app/absensi"]