FROM alpine:3.20.3

RUN apk --no-cache add curl
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
RUN arduino-cli core install arduino:avr # put here all board tools you need

WORKDIR /app
