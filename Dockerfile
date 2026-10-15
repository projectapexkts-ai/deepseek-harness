
FROM node:22.19.0-trixie

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    git \
    ca-certificates \
    curl \
    wget \
    chromium \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libxss1 \
    libgtk-3-0 \
    libxshmfence1 \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install --global pnpm@11.7.0

COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm run build

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3080

EXPOSE 3080

CMD ["node", "--expose-internals", "--import", "tsx/esm", "apps/cli/src/bin.ts", "web", "--host", "0.0.0.0", "--port", "3080"]
