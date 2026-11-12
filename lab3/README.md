## Лабораторная работа 3

Запуск трех контейнеров: Ansible master, приложения и Nginx.

### Запуск:

```bash
cd lab3
docker compose up -d --build
```

### Проверка:

```bash
docker compose ps
docker compose logs --tail=100 ansible
curl -i http://localhost:8080/health
```

В логе Ansible должен быть `failed=0`, а `/health` должен возвращать HTTP 200.

### Остановка:

```bash
docker compose down
```
