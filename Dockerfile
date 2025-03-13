FROM alpine:latest

WORKDIR /app

RUN sed -i 's/\r$//' /app/main.sh

COPY . .

RUN chmod +x main.sh

RUN chmod +x function.sh

CMD ["./main.sh"]