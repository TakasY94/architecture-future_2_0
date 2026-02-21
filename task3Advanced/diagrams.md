# Task 3: Проектирование целевой архитектуры и оценка рисков внедрения


## Уровень 2: Диаграмма контейнеров

```mermaid
graph TB
    subgraph "Пользователи"
        patient[Пациент]
        staff[Персонал компании]
    end
    
    subgraph "Клиентские приложения"
        mobile[Мобильное приложение<br/>React Native]
        spa[Веб-портал самообслуживания<br/>React/TypeScript]
    end
    
    subgraph "Платформа «Будущее 2.0»"
        api[API Gateway<br/>Kong/NGINX]
        
        subgraph "Бизнес-домены"
            medical[Медицинский домен<br/>Java/Spring Boot]
            financial[Финансовый домен<br/>Golang]
            ai[ИИ-сервисы домен<br/>Python/FastAPI]
            analytics[Аналитический домен<br/>Java/Python]
        end
        
        subgraph "Инфраструктура"
            event_bus[Event Bus<br/>Apache Kafka]
            cache[Кэш<br/>Redis]
        end
        
        subgraph "Хранилища данных"
            medical_db[Медицинская БД<br/>PostgreSQL]
            financial_db[Финансовая БД<br/>PostgreSQL]
            data_lake[Data Lake<br/>Apache Iceberg/S3]
            data_warehouse[Data Warehouse<br/>ClickHouse]
        end
    end
    
    subgraph "Внешние системы"
        legacy[Легаси системы<br/>SQL Server, PowerBuilder, Camel]
        partners[Внешние партнеры<br/>Фармацевтические компании, банки]
    end
    
    patient --> mobile
    staff --> spa
    
    mobile --> api
    spa --> api
    
    api --> medical
    api --> financial
    api --> ai
    api --> analytics
    
    medical --> medical_db
    financial --> financial_db
    
    medical --> event_bus
    financial --> event_bus
    ai --> event_bus
    analytics --> event_bus
    
    analytics --> data_lake
    analytics --> data_warehouse
    
    medical --> cache
    financial --> cache
    
    platform -.-> legacy
    platform -.-> partners
    
    style patient fill:#e1f5fe
    style staff fill:#e1f5fe
    style mobile fill:#f3e5f5
    style spa fill:#f3e5f5
    style api fill:#fff3e0
    style medical fill:#e8f5e8
    style financial fill:#e8f5e8
    style ai fill:#e8f5e8
    style analytics fill:#e8f5e8
    style medical_db fill:#ffebee
    style financial_db fill:#ffebee
    style data_lake fill:#ffebee
    style data_warehouse fill:#ffebee
    style event_bus fill:#f3e5f5
    style cache fill:#f3e5f5
    style legacy fill:#f5f5f5
    style partners fill:#f5f5f5
```

## Уровень 3: Диаграмма компонентов (Медицинский домен)

```mermaid
graph TB
    subgraph "Внешние компоненты"
        spa[Веб-портал]
        api[API Gateway]
        event_bus[Event Bus]
    end
    
    subgraph "Медицинский домен"
        subgraph "Сервисы"
            patient_service[Patient Service<br/>Java/Spring Boot<br/>Управление данными пациентов]
            appointment_service[Appointment Service<br/>Java/Spring Boot<br/>Запись на приемы и расписание]
            medical_record_service[Medical Record Service<br/>Java/Spring Boot<br/>Электронные медицинские карты]
            diagnostic_service[Diagnostic Service<br/>Java/Spring Boot<br/>Результаты исследований и диагностики]
            auth_service[Authentication Service<br/>Java/Spring Boot<br/>Аутентификация и авторизация]
        end
        
        subgraph "Базы данных"
            patient_db[Patient Database<br/>PostgreSQL<br/>Таблицы пациентов, записей, назначений]
            medical_records_db[Medical Records DB<br/>PostgreSQL<br/>Медицинские карты и истории болезней]
        end
    end
    
    spa --> api
    api --> patient_service
    api --> appointment_service
    api --> medical_record_service
    api --> diagnostic_service
    api --> auth_service
    
    patient_service --> patient_db
    appointment_service --> patient_db
    medical_record_service --> medical_records_db
    diagnostic_service --> medical_records_db
    
    patient_service -.-> event_bus
    appointment_service -.-> event_bus
    medical_record_service -.-> event_bus
    diagnostic_service -.-> event_bus
    
    auth_service -.-> patient_service
    auth_service -.-> medical_record_service
    
    style spa fill:#f3e5f5
    style api fill:#fff3e0
    style event_bus fill:#f3e5f5
    style patient_service fill:#e8f5e8
    style appointment_service fill:#e8f5e8
    style medical_record_service fill:#e8f5e8
    style diagnostic_service fill:#e8f5e8
    style auth_service fill:#e8f5e8
    style patient_db fill:#ffebee
    style medical_records_db fill:#ffebee
```

#### Финансовый домен (уровень компонентов):

```mermaid
graph TB
    subgraph "Внешние компоненты"
        spa_f[Веб-портал]
        api_f[API Gateway]
        event_bus_f[Event Bus]
        medical_domain[Медицинский домен]
    end
    
    subgraph "Финансовый домен"
        subgraph "Сервисы"
            account_service[Account Service<br/>Golang<br/>Управление счетами клиентов]
            transaction_service[Transaction Service<br/>Golang<br/>Обработка финансовых операций]
            loan_service[Loan Service<br/>Golang<br/>Кредитные продукты и расчёты]
            payment_service[Payment Service<br/>Golang<br/>Платежи и переводы]
            fraud_service[Fraud Detection Service<br/>Python<br/>Обнаружение мошеннических операций]
        end
        
        subgraph "Базы данных"
            accounts_db[Accounts Database<br/>PostgreSQL<br/>Таблицы счетов и балансов]
            transactions_db[Transactions Database<br/>PostgreSQL<br/>Финансовые транзакции]
            loans_db[Loans Database<br/>PostgreSQL<br/>Кредитные договоры и платежи]
        end
        
        subgraph "Интеграции"
            banking_api[Banking API Gateway<br/>Внешние банковские системы]
            payment_gateways[Payment Gateways<br/>Платёжные шлюзы]
        end
    end
    
    spa_f --> api_f
    api_f --> account_service
    api_f --> transaction_service
    api_f --> loan_service
    api_f --> payment_service
    api_f --> fraud_service
    
    account_service --> accounts_db
    transaction_service --> transactions_db
    loan_service --> loans_db
    payment_service --> transactions_db
    
    account_service -.-> event_bus_f
    transaction_service -.-> event_bus_f
    loan_service -.-> event_bus_f
    payment_service -.-> event_bus_f
    fraud_service -.-> event_bus_f
    
    medical_domain -.-> event_bus_f
    
    payment_service --> payment_gateways
    transaction_service --> banking_api
    
    style spa_f fill:#f3e5f5
    style api_f fill:#fff3e0
    style event_bus_f fill:#f3e5f5
    style medical_domain fill:#e8f5e8
    style account_service fill:#e8f5e8
    style transaction_service fill:#e8f5e8
    style loan_service fill:#e8f5e8
    style payment_service fill:#e8f5e8
    style fraud_service fill:#e8f5e8
    style accounts_db fill:#ffebee
    style transactions_db fill:#ffebee
    style loans_db fill:#ffebee
    style banking_api fill:#f3e5f5
    style payment_gateways fill:#f3e5f5
```

#### Аналитический домен (уровень компонентов):

```mermaid
graph TB
    subgraph "Внешние компоненты"
        event_bus_a[Event Bus]
        data_lake[Data Lake]
        data_warehouse[Data Warehouse]
    end
    
    subgraph "Аналитический домен"
        subgraph "Сервисы обработки данных"
            etl_service[ETL Service<br/>Python/Java<br/>Извлечение, трансформация и загрузка данных]
            streaming_service[Streaming Service<br/>Apache Flink<br/>Обработка событий в реальном времени]
            data_quality_service[Data Quality Service<br/>Python<br/>Валидация и очистка данных]
        end
        
        subgraph "Сервисы отчётности"
            report_generator[Report Generator<br/>Java<br/>Генерация стандартных отчётов]
            adhoc_query_service[Ad-hoc Query Service<br/>Python<br/>Выполнение произвольных запросов]
            dashboard_service[Dashboard Service<br/>Node.js<br/>Создание и управление дашбордами]
            alert_service[Alert Service<br/>Python<br/>Мониторинг и оповещения]
        end
        
        subgraph "Хранилища"
            staging_db[Staging Database<br/>PostgreSQL<br/>Промежуточное хранение данных]
            metadata_db[Metadata Database<br/>PostgreSQL<br/>Метаданные и lineage]
            cache_a[Cache<br/>Redis<br/>Кэширование результатов запросов]
        end
    end
    
    subgraph "Потребители"
        spa_a[Веб-портал]
        business_users[Бизнес-пользователи]
        external_systems[Внешние системы]
    end
    
    event_bus_a --> streaming_service
    event_bus_a --> etl_service
    
    etl_service --> data_lake
    streaming_service --> data_warehouse
    
    data_lake --> etl_service
    data_warehouse --> adhoc_query_service
    data_warehouse --> report_generator
    
    etl_service --> staging_db
    data_quality_service --> metadata_db
    adhoc_query_service --> cache_a
    
    report_generator --> spa_a
    dashboard_service --> spa_a
    adhoc_query_service --> spa_a
    alert_service --> external_systems
    
    spa_a --> business_users
    
    style event_bus_a fill:#f3e5f5
    style data_lake fill:#ffebee
    style data_warehouse fill:#ffebee
    style etl_service fill:#e8f5e8
    style streaming_service fill:#e8f5e8
    style data_quality_service fill:#e8f5e8
    style report_generator fill:#e8f5e8
    style adhoc_query_service fill:#e8f5e8
    style dashboard_service fill:#e8f5e8
    style alert_service fill:#e8f5e8
    style staging_db fill:#ffebee
    style metadata_db fill:#ffebee
    style cache_a fill:#ffebee
    style spa_a fill:#f3e5f5
    style business_users fill:#e1f5fe
    style external_systems fill:#f3e5f5
```

#### Ключевые контейнеры:

1. **Веб-портал самообслуживания** - Single Page Application для бизнес-пользователей
2. **API Gateway** - Единая точка входа для всех клиентских запросов
3. **Event Bus** (Kafka/Pulsar) - Центральная шина событий для междоменного взаимодействия
4. **Медицинский домен** - Микросервисы для управления медицинскими данными
5. **Финансовый домен** - Микросервисы для банковских и финтех-операций
6. **ИИ-сервисы домен** - Сервисы машинного обучения и аналитики
7. **Аналитический домен** - Обработка данных и формирование отчётов
8. **Data Lake** - Централизованное хранилище сырых данных
9. **Data Warehouse** - Оптимизированное хранилище для аналитики

### Компоненты C4-модели (Уровень 3)

#### Медицинский домен:
- **Patient Service** - Управление данными пациентов
- **Appointment Service** - Запись на приёмы и расписание
- **Medical Record Service** - Электронные медицинские карты
- **Diagnostic Service** - Результаты исследований и диагностики

#### Финансовый домен:
- **Account Service** - Управление счетами клиентов
- **Transaction Service** - Обработка финансовых операций
- **Loan Service** - Кредитные продукты и расчёты
- **Payment Service** - Платежи и переводы

#### ИИ-сервисы домен:
- **ML Pipeline Service** - Обучение и развёртывание моделей
- **Prediction Service** - Прогнозирование и рекомендации
- **Image Analysis Service** - Анализ медицинских изображений
- **Natural Language Service** - Обработка текстовых данных

#### Аналитический домен:
- **ETL Service** - Извлечение, трансформация и загрузка данных
- **Report Generator** - Генерация стандартных отчётов
- **Ad-hoc Query Service** - Выполнение произвольных запросов
- **Dashboard Service** - Создание и управление дашбордами

### Технологический стек (3-летняя перспектива)

#### Облачная инфраструктура:
- **Yandex Cloud** (основная платформа)
- **Kubernetes** (оркестрация контейнеров)
- **Terraform** (инфраструктура как код)
- **GitHub Actions** (CI/CD)

#### Хранилища данных:
- **PostgreSQL** (операционные БД)
- **Apache Kafka** (стриминг событий)
- **Apache Iceberg** (Data Lake формат)
- **ClickHouse** (OLAP для аналитики)
- **Redis** (кэширование)

#### Бэкенд-технологии:
- **Java/Spring Boot** (основные бизнес-сервисы)
- **Python/FastAPI** (ИИ-сервисы и аналитика)
- **Golang** (высоконагруженные финансовые сервисы)
- **Node.js** (API Gateway и некоторые микросервисы)

#### Фронтенд:
- **React/TypeScript** (веб-портал)
- **React Native** (мобильные приложения)

### Эволюция архитектуры

#### Текущее состояние → Целевое состояние:
1. **Монолит DWH** → **Распределённые доменные сервисы**
2. **Пакетная обработка** → **Стриминговая обработка**
3. **Жёсткие интеграции** → **Событийное взаимодействие**
4. **Локальное развёртывание** → **Облачная нативная архитектура**
5. **Ручное управление** → **Полная автоматизация CI/CD**

#### Ключевые изменения:
- Замена SQL Server 2008 на современные СУБД
- Миграция с PowerBuilder на React-интерфейсы
- Замена Apache Camel на Kafka для интеграций
- Внедрение Data Lake вместо монолитного DWH
- Реализация self-service аналитики через портал

### Принципы архитектуры

1. **Доменно-ориентированное проектирование** - Чёткое разделение на медицинский, финансовый и ИИ-домены
2. **Event-Driven Architecture** - Все домены взаимодействуют через события
3. **Cloud-Native** - Использование облачных сервисов и контейнеризации
4. **Data Mesh** - Децентрализованное владение данными доменами
5. **Zero-Trust Security** - Строгая аутентификация и авторизация
6. **Observability** - Полная наблюдаемость через метрики, логи и трассировку