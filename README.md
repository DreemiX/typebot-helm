# Typebot Helm Chart

Цей Helm chart розгортає [Typebot](https://typebot.io/) на Kubernetes.

## Передумови

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner (якщо використовуються локальні бази даних)

## Встановлення

### З локального репозиторію

```bash
# Спочатку додайте залежні репозиторії
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Встановіть chart
helm install my-typebot . -f values.yaml
```

### З GitHub Pages репозиторію

Якщо chart опубліковано на GitHub Pages:

```bash
# Додайте репозиторій Helm
helm repo add typebot-helm https://[ім'я користувача].github.io/[назва репозиторію]/
helm repo update

# Перегляньте доступні версії
helm search repo typebot-helm

# Встановіть chart
helm install my-typebot typebot-helm/typebot -f values.yaml
```

## Конфігурація

### Мінімальна конфігурація

Мінімальна конфігурація, яка використовує локальні бази даних (PostgreSQL, Redis) та MinIO для зберігання:

```yaml
typebot:
  encryption:
    secret: "your-32-character-encryption-key"
  nextauth:
    url: "https://typebot.example.com"
  viewerUrl: "https://bot.example.com"

ingress:
  enabled: true
  hosts:
    builder:
      host: typebot.example.com
    viewer:
      host: bot.example.com
```

### Використання зовнішніх сервісів

Приклад конфігурації з віддаленими сервісами:

```yaml
# Відключення локальних сервісів
postgresql:
  enabled: false
redis:
  enabled: false
minio:
  enabled: false

# Налаштування зовнішніх сервісів
externalDatabase:
  host: "your-postgres-host"
  port: 5432
  user: "postgres"
  password: "your-password"
  database: "typebot"

externalRedis:
  host: "your-redis-host"
  port: 6379
  password: "your-password"

externalStorage:
  type: "s3"  # або "gcp"
  # Для S3
  s3:
    accessKey: "your-access-key"
    secretKey: "your-secret-key"
    bucket: "typebot"
    endpoint: "s3.amazonaws.com"
    region: "us-east-1"
    ssl: true
  # Для GCP
  # gcp:
  #   bucket: "your-gcp-bucket"
  #   credentials: "{JSON credentials content}"

typebot:
  encryption:
    secret: "your-32-character-encryption-key"
  nextauth:
    url: "https://typebot.example.com"
  viewerUrl: "https://bot.example.com"
```

### Використання зовнішніх секретів

Для більш безпечного керування секретами:

```yaml
typebot:
  encryption:
    existingSecret: "typebot-secrets"
    existingSecretKey: "encryption-secret"

externalStorage:
  type: "s3"
  s3:
    existingSecret: "s3-credentials"
    existingSecretAccessKeyKey: "access-key"
    existingSecretSecretKeyKey: "secret-key"
```

## Параметри

### Загальні параметри

| Назва                  | Опис                                                                                                | Значення за замовчуванням    |
|------------------------|-----------------------------------------------------------------------------------------------------|------------------------------|
| `replicaCount.builder` | Кількість реплік для builder сервісу                                                                | `1`                          |
| `replicaCount.viewer`  | Кількість реплік для viewer сервісу                                                                 | `1`                          |
| `image.registry`       | Реєстр Docker для образів Typebot                                                                   | `docker.io`                  |
| `image.builder.repository` | Репозиторій Docker для образу builder                                                           | `baptistearno/typebot-builder` |
| `image.builder.tag`    | Тег Docker для образу builder                                                                       | `latest`                     |
| `image.viewer.repository` | Репозиторій Docker для образу viewer                                                             | `baptistearno/typebot-viewer` |
| `image.viewer.tag`     | Тег Docker для образу viewer                                                                        | `latest`                     |

### База даних PostgreSQL

| Назва                 | Опис                                                                                                | Значення за замовчуванням    |
|-----------------------|-----------------------------------------------------------------------------------------------------|------------------------------|
| `postgresql.enabled`  | Розгортати PostgreSQL як частину цього chart                                                        | `true`                       |
| `postgresql.auth.username` | Ім'я користувача PostgreSQL                                                                    | `postgres`                   |
| `postgresql.auth.password` | Пароль користувача PostgreSQL                                                                  | `typebot`                    |
| `postgresql.auth.database` | Назва бази даних PostgreSQL                                                                    | `typebot`                    |

### Зовнішня база даних

| Назва                       | Опис                                                                                          | Значення за замовчуванням    |
|-----------------------------|-----------------------------------------------------------------------------------------------|------------------------------|
| `externalDatabase.host`     | Хост зовнішньої бази даних PostgreSQL                                                         | `""`                         |
| `externalDatabase.port`     | Порт зовнішньої бази даних PostgreSQL                                                         | `5432`                       |
| `externalDatabase.user`     | Користувач зовнішньої бази даних PostgreSQL                                                   | `postgres`                   |
| `externalDatabase.password` | Пароль зовнішньої бази даних PostgreSQL                                                       | `""`                         |
| `externalDatabase.database` | Назва зовнішньої бази даних PostgreSQL                                                        | `typebot`                    |

### Redis

| Назва                | Опис                                                                                                | Значення за замовчуванням    |
|----------------------|-----------------------------------------------------------------------------------------------------|------------------------------|
| `redis.enabled`      | Розгортати Redis як частину цього chart                                                             | `true`                       |

### Зовнішній Redis

| Назва                     | Опис                                                                                          | Значення за замовчуванням    |
|---------------------------|-----------------------------------------------------------------------------------------------|------------------------------|
| `externalRedis.host`      | Хост зовнішнього Redis                                                                        | `""`                         |
| `externalRedis.port`      | Порт зовнішнього Redis                                                                        | `6379`                       |
| `externalRedis.password`  | Пароль зовнішнього Redis                                                                      | `""`                         |

### MinIO (S3-сумісне сховище)

| Назва               | Опис                                                                                                | Значення за замовчуванням    |
|---------------------|-----------------------------------------------------------------------------------------------------|------------------------------|
| `minio.enabled`     | Розгортати MinIO як частину цього chart                                                             | `true`                       |
| `minio.auth.rootUser` | Користувач MinIO                                                                                  | `minio`                      |
| `minio.auth.rootPassword` | Пароль MinIO                                                                                  | `minio123`                   |
| `minio.defaultBuckets` | Бакети MinIO за замовчуванням                                                                    | `typebot`                    |

### Зовнішнє об'єктне сховище

| Назва                          | Опис                                                                                     | Значення за замовчуванням    |
|--------------------------------|------------------------------------------------------------------------------------------|------------------------------|
| `externalStorage.type`         | Тип зовнішнього сховища (`s3` або `gcp`)                                                | `s3`                         |
| `externalStorage.s3.accessKey` | Ключ доступу до S3                                                                       | `""`                         |
| `externalStorage.s3.secretKey` | Секретний ключ S3                                                                        | `""`                         |
| `externalStorage.s3.bucket`    | Назва бакету S3                                                                          | `typebot`                    |
| `externalStorage.s3.endpoint`  | Ендпоінт S3                                                                              | `""`                         |
| `externalStorage.s3.region`    | Регіон S3                                                                                | `""`                         |
| `externalStorage.gcp.bucket`   | Назва бакету GCP                                                                         | `""`                         |
| `externalStorage.gcp.credentials` | JSON з GCP credentials                                                                | `""`                         |

## Розгортання

1. Якщо ви використовуєте віддалений S3-сумісний сервіс, переконайтеся, що бакет створено заздалегідь.
2. Налаштуйте свій `values.yaml` відповідно до потреб.
3. Встановіть chart:

```bash
helm install my-typebot . -f values.yaml
```

4. Якщо ingress включено, перейдіть до вказаних URL-адрес. В іншому випадку використовуйте port-forwarding для доступу до сервісів.

## CI/CD

Цей репозиторій містить GitHub Actions workflow для автоматичної публікації Helm chart на GitHub Pages при пуші змін у файли Chart.yaml, values.yaml або шаблони.

Після налаштування GitHub Pages у вашому репозиторії, ви зможете використовувати Helm chart за URL:
```
https://[ім'я користувача].github.io/[назва репозиторію]/
```

Для деталей налаштування дивіться файл [.github/workflows/README.md](.github/workflows/README.md). 