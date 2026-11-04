FROM alpine:3.24
COPY app.sh /app/
CMD ["sh", "/app/app.sh"]
