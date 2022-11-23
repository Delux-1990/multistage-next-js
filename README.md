## Задача 2 - организовать локальную разработку next.js-приложения в контейнере
Шаблон приложения был создан основе инструкции: https://nextjs.org/docs/api-reference/create-next-app

Командой:
```bash
npx create-next-app@latest
```
Создание образа:
```bash
sudo docker build -t webapp .
```
Запуск контейнера:
```bash
sudo docker run -d 3000:3000 webapp
```
```bash
user@user-def:~/development/github/dev_ops/nextappdocker/app$ sudo docker run -p  3000:3000 webapp 
Listening on port 3000 url: http://localhost:3000
```
Тело html страницы
```bash
curl http://localhost:3000 -i
HTTP/1.1 200 OK
X-Powered-By: Next.js
ETag: "j4tw0xd7hc271"
Date: Sun, 20 Nov 2022 19:15:35 GMT
Connection: keep-alive
Keep-Alive: timeout=5
```

# dev-loop (сохранение кода вызывает пересборку)
Реализовано, задание через строку  "restart: unless-stopped" в docker-compose.yaml файле. При редактировнаии файлов снаружи контейера в проекте, которые были импоритрованы внуть, их изменения тутуже повлияют на запущеный проект в самом докер контейнере.

Если было нужно через client side hooks, то вот реакиция на "git commit" команду.
Реализовано через редактирование файла .git/hooks/pre-commit.sample.
 * Если хотите пересобрать образ
 ```bash
sudo docker-compose up --build -d 
```
 * Если хотите пересобрать проект.
 ```bash
sudo npx next dev
```
Возможно выбрать, что конкретно вы подразумеваете под "пересборкой". Если образа, то первая команда, проекта - вторая.

# Единый Dockerfile для разработки и продакшена
Находится в репозитории.

# Мультистедж-сборка для билда в Dockerfile
далее пиведены три строки - начала для разных типов сборок: deps, builder, runner
=  FROM node:16-alpine AS deps
 
или Мультистейдж сборка для продакшена
- FROM node:16-alpine AS runner

# Эффективное кеширование на уровне докерфайла; 
 включено по умолчанию в докере. Когда изменются файлы в проекте, докер пересобирает только затронутые. 
 Кеширование можно видеть через консоль в процессе сборки контейнера

# package.lock и package-lock.json в репозитории
в репозитории
