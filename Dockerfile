FROM alpine:latest

WORKDIR /app

COPY . .

RUN chmod +x main.sh

RUN chmod +x function.sh

CMD ["./main.sh"]