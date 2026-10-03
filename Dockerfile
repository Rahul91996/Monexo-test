FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY .npmrc ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY package*.json ./
COPY .npmrc ./
RUN npm install --omit=dev --legacy-peer-deps
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/admin.html ./admin.html
COPY --from=builder /app/index.html ./index.html
COPY --from=builder /app/assets ./assets
COPY --from=builder /app/static ./static
COPY --from=builder /app/public ./public
COPY --from=builder /app/rsCfg.json ./rsCfg.json
COPY --from=builder /app/favicon.ico ./favicon.ico
COPY --from=builder /app/server.ts ./server.ts

EXPOSE 3000
CMD ["npm", "start"]
