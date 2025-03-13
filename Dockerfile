FROM alpine:latest

WORKDIR /app

COPY . .

RUN chmod +x main.sh

RUN chmod +x function.sh

RUN sed -i 's/\r$//' /app/main.sh

CMD ["./main.sh"]