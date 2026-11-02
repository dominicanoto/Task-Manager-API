# Task Manager API

Простий REST API для керування задачами на Java 17 і Spring Boot.
Задачі зберігаються в пам'яті та скидаються після перезапуску.

## Запуск у Docker

Потрібні запущений Docker, Docker Compose та Bash (Linux, WSL або Git Bash).

```bash
bash deploy.sh
```

Запускаються два контейнери: API та Nginx. Адреси:

- API: http://localhost:8080/tasks
- Через Nginx: http://localhost:8081/tasks

```bash
bash deploy.sh status  # стан контейнерів
bash deploy.sh logs    # перегляд логів (Ctrl+C для виходу)
bash deploy.sh down    # зупинка та видалення контейнерів
```

## Запуск без Docker

Потрібні JDK 17+ і Maven.

```bash
mvn package
java -jar target/task-manager-1.0.0.jar
```

## API

| Метод | Шлях | Опис |
|---|---|---|
| GET | `/` | Перевірка роботи API |
| GET | `/tasks` | Список задач |
| POST | `/tasks` | Додати задачу, тіло: `{"title":"Вивчити Docker"}` |
| DELETE | `/tasks/{id}` | Видалити задачу |

Порожня назва задачі повертає HTTP 400.

Приклад додавання задачі в Bash:

```bash
curl -X POST http://localhost:8080/tasks \
  -H 'Content-Type: application/json' \
  -d '{"title":"Вивчити Docker"}'
```
