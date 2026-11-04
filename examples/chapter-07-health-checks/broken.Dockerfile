FROM node:24-alpine
WORKDIR /app
RUN apk add --no-cache curl
COPY app.js .
# Intentional: wrong endpoint "/not-healthy"
HEALTHCHECK --interval=5s --timeout=3s --retries=2 CMD curl -f http://localhost:3000/not-healthy || exit 1
EXPOSE 3000
CMD ["node", "app.js"]
