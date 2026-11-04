FROM alpine:3.24
RUN apk add --no-cache curl
COPY app.sh /app/
CMD ["sh", "/app/app.sh"]
