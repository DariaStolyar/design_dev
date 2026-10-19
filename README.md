## Лабораторная работа Docker

### Шаг 1:

Сборка и запуск приложения:

```bash
cd docker1
docker compose -f docker_compose.yml up -d --build
```

Проверка:

```bash
docker compose -f docker_compose.yml ps
curl -i http://localhost:8080/health
```

Эндпоинт `/health` должен возвращать HTTP 200

Сборка и публикация образа в Docker Registry после `docker login`:

```bash
./build_and_push.sh <registry-user>/health-app 1.0
```

### Шаг 2:

Создание файла с переменными окружения:

```bash
cd docker2
cp .env.example .env
```

Запуск контейнеров:

```bash
docker compose up -d --build
```

Проверка:

```bash
docker compose ps
curl -i http://localhost/health
```

Приложение должно возвращать HTTP 200 через Nginx

Наружу открыт только порт Nginx — `80`

Остановка контейнеров:

```bash
docker compose down
```

Данные PostgreSQL сохраняются в томе `pgdata`
