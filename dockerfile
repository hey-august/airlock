FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache \
    git \
    nethogs \
    curl

CMD ["/bin/sh"]
