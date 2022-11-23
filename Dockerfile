
FROM node:16-alpine AS deps
WORKDIR /app
# В зависимости от используемого пакетного менеджера, устанавливаем зависимости разными способами.
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Мультистедж сборка для билда
FROM node:16-alpine AS builder
WORKDIR /app
COPY --from=deps ./app/node_modules ./node_modules
COPY . .
RUN npm run build


# Мультистейдж сборка для продакшена
# Production image, copy all the files and run next
FROM node:16-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static


USER nextjs

CMD [ "npm", "run", "dev" ]

