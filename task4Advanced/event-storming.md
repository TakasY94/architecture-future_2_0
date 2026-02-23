# Event Storming диаграмма для компании "Будущее 2.0"

## Обзор событийной архитектуры

Event Storming диаграмма отображает ключевые доменные события, их источники и подписчиков в рамках событийной архитектуры платформы "Будущее 2.0".

### Легенда диаграммы
- 🟡 **Событие (Event)**: Доменное событие, произошедшее в системе
- 🔵 **Агрегат (Aggregate)**: Источник события (агрегат, который публикует событие)
- 🟢 **Подписчик (Subscriber)**: Домен или сервис, который подписывается на событие
- 🔴 **Команда (Command)**: Действие, которое инициирует изменение состояния
- 🟣 **Политика (Policy)**: Бизнес-правило, которое реагирует на события

## Диаграмма Event Storming

```mermaid
graph LR
    %% Секция: Медицинский домен
    subgraph Медицинский_домен["Медицинский домен"]
        med_aggregate[Агрегат: Пациент<br/>Агрегат: Медицинская карта]
        
        med_event1[🟡 Событие: Пациент зарегистрирован]
        med_event2[🟡 Событие: Назначение создано]
        med_event3[🟡 Событие: Диагностическое исследование проведено]
        med_event4[🟡 Событие: Медицинская карта обновлена]
        med_event5[🟡 Событие: Лечение назначено]
        
        med_command1[🔴 Команда: Зарегистрировать пациента]
        med_command2[🔴 Команда: Создать назначение]
        med_command3[🔴 Команда: Записать результаты исследования]
        
        med_aggregate --> med_event1
        med_aggregate --> med_event2
        med_aggregate --> med_event3
        med_aggregate --> med_event4
        med_aggregate --> med_event5
        
        med_command1 --> med_event1
        med_command2 --> med_event2
        med_command3 --> med_event3
    end
    
    %% Секция: Финансовый домен
    subgraph Финансовый_домен["Финансовый домен"]
        fin_aggregate[Агрегат: Счет<br/>Агрегат: Кредитный договор]
        
        fin_event1[🟡 Событие: Счет открыт]
        fin_event2[🟡 Событие: Кредитный договор создан]
        fin_event3[🟡 Событие: Транзакция выполнена]
        fin_event4[🟡 Событие: Платеж получен]
        fin_event5[🟡 Событие: Кредит погашен]
        
        fin_command1[🔴 Команда: Открыть счет]
        fin_command2[🔴 Команда: Выдать кредит]
        fin_command3[🔴 Команда: Выполнить транзакцию]
        
        fin_aggregate --> fin_event1
        fin_aggregate --> fin_event2
        fin_aggregate --> fin_event3
        fin_aggregate --> fin_event4
        fin_aggregate --> fin_event5
        
        fin_command1 --> fin_event1
        fin_command2 --> fin_event2
        fin_command3 --> fin_event3
    end
    
    %% Секция: ИИ-сервисы домен
    subgraph ИИ_сервисы_домен["ИИ-сервисы домен"]
        ai_aggregate[Агрегат: Модель ИИ<br/>Агрегат: Анализ]
        
        ai_event1[🟡 Событие: Исследование проанализировано ИИ]
        ai_event2[🟡 Событие: Диагноз сгенерирован]
        ai_event3[🟡 Событие: Рекомендация по лечению создана]
        ai_event4[🟡 Событие: Аномалия обнаружена]
        
        ai_command1[🔴 Команда: Проанализировать исследование]
        ai_command2[🔴 Команда: Сгенерировать диагноз]
        
        ai_aggregate --> ai_event1
        ai_aggregate --> ai_event2
        ai_aggregate --> ai_event3
        ai_aggregate --> ai_event4
        
        ai_command1 --> ai_event1
        ai_command2 --> ai_event2
    end
    
    %% Секция: Аналитический домен
    subgraph Аналитический_домен["Аналитический домен"]
        analytics_aggregate[Агрегат: Отчет<br/>Агрегат: Дашборд]
        
        analytics_event1[🟡 Событие: Отчет сгенерирован]
        analytics_event2[🟡 Событие: KPI обновлен]
        analytics_event3[🟡 Событие: Аналитический срез создан]
        
        analytics_command1[🔴 Команда: Сгенерировать отчет]
        analytics_command2[🔴 Команда: Обновить дашборд]
        
        analytics_aggregate --> analytics_event1
        analytics_aggregate --> analytics_event2
        analytics_aggregate --> analytics_event3
        
        analytics_command1 --> analytics_event1
        analytics_command2 --> analytics_event2
    end
    
    %% Потоки событий между доменами
    %% Медицинский → ИИ-сервисы
    med_event3 -->|триггерит| ai_command1
    med_event4 -->|триггерит| ai_command1
    
    %% Медицинский → Финансовый
    med_event2 -->|триггерит| fin_command3
    med_event5 -->|триггерит| fin_command3
    
    %% ИИ-сервисы → Медицинский
    ai_event2 -->|триггерит| med_command3
    ai_event3 -->|триггерит| med_command2
    
    %% Все домены → Аналитический
    med_event1 -->|публикует| analytics_event2
    med_event2 -->|публикует| analytics_event2
    med_event3 -->|публикует| analytics_event2
    
    fin_event1 -->|публикует| analytics_event2
    fin_event3 -->|публикует| analytics_event2
    fin_event5 -->|публикует| analytics_event2
    
    ai_event1 -->|публикует| analytics_event2
    ai_event4 -->|публикует| analytics_event2
    
    %% Политики (бизнес-правила)
    policy1[🟣 Политика: При обнаружении аномалии<br/>уведомить медицинский персонал]
    policy2[🟣 Политика: При создании кредитного договора<br/>проверить кредитную историю]
    policy3[🟣 Политика: При обновлении медицинской карты<br/>синхронизировать с аналитикой]
    
    ai_event4 -->|активирует| policy1
    fin_event2 -->|активирует| policy2
    med_event4 -->|активирует| policy3
    
    %% Подписчики на события
    subgraph Подписчики["Подписчики"]
        subscriber1[🟢 Подписчик: Система уведомлений]
        subscriber2[🟢 Подписчик: Сервис аудита]
        subscriber3[🟢 Подписчик: Data Lake]
        subscriber4[🟢 Подписчик: Легаси DWH временно]
    end
    
    %% Подписки на ключевые события
    med_event1 -->|подписан| subscriber1
    med_event1 -->|подписан| subscriber2
    med_event1 -->|подписан| subscriber3
    med_event1 -->|подписан| subscriber4
    
    fin_event2 -->|подписан| subscriber1
    fin_event2 -->|подписан| subscriber2
    fin_event2 -->|подписан| subscriber3
    
    ai_event4 -->|подписан| subscriber1
    ai_event4 -->|подписан| subscriber2
    
    %% Стилизация
    style med_aggregate fill:#e8f5e8
    style fin_aggregate fill:#e8f5e8
    style ai_aggregate fill:#e8f5e8
    style analytics_aggregate fill:#e8f5e8
    
    style med_event1 fill:#ffeb3b
    style med_event2 fill:#ffeb3b
    style med_event3 fill:#ffeb3b
    style med_event4 fill:#ffeb3b
    style med_event5 fill:#ffeb3b
    
    style fin_event1 fill:#ffeb3b
    style fin_event2 fill:#ffeb3b
    style fin_event3 fill:#ffeb3b
    style fin_event4 fill:#ffeb3b
    style fin_event5 fill:#ffeb3b
    
    style ai_event1 fill:#ffeb3b
    style ai_event2 fill:#ffeb3b
    style ai_event3 fill:#ffeb3b
    style ai_event4 fill:#ffeb3b
    
    style analytics_event1 fill:#ffeb3b
    style analytics_event2 fill:#ffeb3b
    style analytics_event3 fill:#ffeb3b
    
    style med_command1 fill:#f44336
    style med_command2 fill:#f44336
    style med_command3 fill:#f44336
    
    style fin_command1 fill:#f44336
    style fin_command2 fill:#f44336
    style fin_command3 fill:#f44336
    
    style ai_command1 fill:#f44336
    style ai_command2 fill:#f44336
    
    style analytics_command1 fill:#f44336
    style analytics_command2 fill:#f44336
    
    style policy1 fill:#9c27b0
    style policy2 fill:#9c27b0
    style policy3 fill:#9c27b0
    
    style subscriber1 fill:#4caf50
    style subscriber2 fill:#4caf50
    style subscriber3 fill:#4caf50
    style subscriber4 fill:#4caf50
```

## Ключевые потоки событий

### 1. Регистрация пациента и создание финансового счета
```
Пользователь → [Зарегистрировать пациента] → Медицинский домен
Медицинский домен → [Пациент зарегистрирован] → Событие
Финансовый домен ← Подписка на событие → [Открыть счет]
Финансовый домен → [Счет открыт] → Событие
Аналитический домен ← Подписка на оба события → [Обновить KPI]
```

### 2. Диагностическое исследование и ИИ-анализ
```
Врач → [Записать результаты исследования] → Медицинский домен
Медицинский домен → [Диагностическое исследование проведено] → Событие
ИИ-сервисы домен ← Подписка на событие → [Проанализировать исследование]
ИИ-сервисы домен → [Исследование проанализировано ИИ] → Событие
Медицинский домен ← Подписка на событие → [Обновить медицинскую карту]
```

### 3. Кредитная операция и аналитика
```
Клиент → [Выдать кредит] → Финансовый домен
Финансовый домен → [Кредитный договор создан] → Событие
Аналитический домен ← Подписка на событие → [Обновить финансовые отчеты]
Система уведомлений ← Подписка на событие → [Отправить уведомление]
```

## Матрица событий и подписчиков

| Событие | Источник (домен) | Основные подписчики | Назначение |
|---------|------------------|---------------------|------------|
| Пациент зарегистрирован | Медицинский | Финансовый, Аналитический, Система уведомлений | Создание счета, обновление статистики, уведомление |
| Диагностическое исследование проведено | Медицинский | ИИ-сервисы, Аналитический | Анализ ИИ, обновление медицинской статистики |
| Кредитный договор создан | Финансовый | Аналитический, Система уведомлений, Сервис аудита | Финансовая отчетность, уведомления, аудит |
| Исследование проанализировано ИИ | ИИ-сервисы | Медицинский, Аналитический | Обновление диагноза, исследовательская аналитика |
| Аномалия обнаружена | ИИ-сервисы | Система уведомлений, Медицинский | Экстренное уведомление, пересмотр диагноза |
| Отчет сгенерирован | Аналитический | Data Lake, Легаси DWH | Долгосрочное хранение, обратная совместимость |

## Принципы проектирования событий

1. **Иммutability событий**: События неизменяемы после публикации
2. **Семантическое версионирование**: Схемы событий имеют версии для обратной совместимости
3. **Гарантия доставки**: Использование persistent storage для событий
4. **Идемпотентность обработки**: Подписчики должны обрабатывать события идемпотентно
5. **Мониторинг и observability**: Все события логируются и отслеживаются
6. **DLQ (Dead Letter Queue)**: Обработка неудачных событий через отдельные очереди