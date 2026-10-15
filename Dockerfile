
FROM node:22.19-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    musl-tools \
    git \
    python3 \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable \
    && corepack prepare pnpm@11.7.0 --activate

WORKDIR /app

COPY . .

ARG DSH_CLIENT_COMMIT_HASH
ENV DSH_CLIENT_COMMIT_HASH=${DSH_CLIENT_COMMIT_HASH}

RUN pnpm install --frozen-lockfile
RUN pnpm run build

EXPOSE 3080

CMD ["pnpm", "dsh", "web", "--no-open"]
