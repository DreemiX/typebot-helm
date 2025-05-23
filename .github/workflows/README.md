# CI/CD для Helm Chart

Цей каталог містить GitHub Actions workflows для автоматизації процесів CI/CD для Helm chart.

## release.yaml

Workflow `release.yaml` виконує перевірку і публікує Helm chart на GitHub Pages.

### Як це працює

1. При пуші змін в файли Chart.yaml, values.yaml або будь-які файли в директорії templates запускається workflow.
2. Workflow виконує наступні кроки:
   
   **Перевірка (lint-test job):**
   - Перевірка синтаксису Helm chart за допомогою `helm lint`
   - Валідація залежностей за допомогою `helm dependency build`
   - Перевірка генерації шаблонів за допомогою `helm template`
   
   **Публікація (release job):**
   - Workflow використовує [helm/chart-releaser-action](https://github.com/helm/chart-releaser-action) для:
     - Створення архіву Helm chart (.tgz)
     - Оновлення індексу Helm charts (index.yaml)
     - Публікації релізу на GitHub
     - Публікації chart на GitHub Pages

3. У випадку pull request'ів виконується тільки перевірка, без публікації.

### Налаштування репозиторію

Для правильної роботи цього workflow потрібно:

1. Переконатися, що GitHub Pages налаштовано:
   - Перейдіть у налаштування репозиторію (Settings)
   - Виберіть "Pages" в бічному меню
   - У розділі "Build and deployment" виберіть "Deploy from a branch"
   - Виберіть гілку "gh-pages" і каталог "/ (root)"
   - Натисніть "Save"

2. Надати дозволи для workflow:
   - Перейдіть у налаштування репозиторію (Settings)
   - Виберіть "Actions" > "General" в бічному меню
   - У розділі "Workflow permissions" виберіть "Read and write permissions"
   - Натисніть "Save"

3. Внести зміни для запуску workflow:
   - Змініть версію у файлі Chart.yaml (наприклад, з `0.1.0` на `0.1.1`)
   - Пушніть зміни в головну гілку репозиторію
   - Перевірте статус виконання workflow у вкладці "Actions" репозиторію

### Статус CI/CD

На даний момент Helm chart доступний за URL:

```
https://dreemix.github.io/typebot-helm/
```

Якщо ви отримуєте помилку "failed to fetch index.yaml", це означає, що workflow ще не виконано успішно. Можливі причини:

1. GitHub Actions workflow ще не був запущений або не завершився
2. GitHub Pages не налаштовано правильно
3. Відсутні потрібні дозволи для GitHub Actions

### Використання опублікованого chart

Після успішного запуску workflow, Helm chart доступний за адресою:

```
https://dreemix.github.io/typebot-helm/
```

Ви можете додати цей репозиторій в Helm:

```bash
helm repo add typebot-helm https://dreemix.github.io/typebot-helm/
helm repo update
helm search repo typebot-helm
```

І встановити chart:

```bash
helm install my-typebot typebot-helm/typebot
``` 