FROM node:24-alpine
WORKDIR /app
RUN apk add --no-cache curl
COPY app.js .
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost:3000/health || exit 1
EXPOSE 3000
CMD ["node", "app.js"]
