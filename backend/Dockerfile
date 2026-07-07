FROM node:24-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

RUN chown -R node:node /app

USER node

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD wget --quiet --tries=1 --spider http://localhost:5000/health || exit 1

CMD ["node", "server.js"]