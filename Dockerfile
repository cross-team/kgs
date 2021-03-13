FROM golang:1.13.1-alpine AS builder

WORKDIR /clublink

RUN apk add --no-cache git bash

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Verify dependencies
RUN go mod verify

COPY . .

RUN go build -o build/app main.go

FROM alpine:3.10 as production

WORKDIR /clublink

RUN apk add --no-cache bash

COPY --from=builder /clublink/build/app ./build/app
COPY --from=builder /clublink/scripts/wait-for-it ./scripts/wait-for-it
COPY --from=builder /clublink/app/adapter/db/migration ./app/adapter/db/migration
COPY --from=builder /clublink/app/adapter/template/*.gohtml ./app/adapter/template/

CMD ["./scripts/wait-for-it", "-s", "-t", "0", "db:5432", "--"]
CMD ["./build/app", "start"]
