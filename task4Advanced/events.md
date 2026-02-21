# Каталог доменных событий

## Введение

Доменные события представляют факты, которые произошли в системе и представляют интерес для других частей системы. Каждое событие имеет уникальный идентификатор, временную метку, источник и минимальный контракт данных.

## Формат события

```json
{
  "eventId": "uuid-v4",
  "eventType": "Domain.Event.Name",
  "eventVersion": "1.0",
  "timestamp": "ISO-8601",
  "source": "domain:aggregate",
  "aggregateId": "aggregate-id",
  "payload": {
    // специфичные данные события
  },
  "metadata": {
    "correlationId": "uuid-v4",
    "causationId": "uuid-v4",
    "userId": "user-id",
    "tenantId": "tenant-id"
  }
}
```

## Категории событий

### 1. События медицинского домена

#### 1.1 PatientRegistered
**Контекст-источник**: Медицинский домен, агрегат Patient  
**Семантика**: Новый пациент зарегистрирован в системе  
**Минимальный контракт**:
```json
{
  "patientId": "string",
  "firstName": "string",
  "lastName": "string",
  "dateOfBirth": "ISO-8601",
  "gender": "string",
  "registrationDate": "ISO-8601",
  "clinicId": "string"
}
```
**Подписчики**: Финансовый домен, Аналитический домен, Система уведомлений  
**Бизнес-правила**: Автоматическое создание финансового счета для пациента

#### 1.2 MedicalRecordCreated
**Контекст-источник**: Медицинский домен, агрегат MedicalRecord  
**Семантика**: Создана новая медицинская карта для пациента  
**Минимальный контракт**:
```json
{
  "medicalRecordId": "string",
  "patientId": "string",
  "createdBy": "string",
  "creationDate": "ISO-8601",
  "initialDiagnosis": "string|null"
}
```
**Подписчики**: ИИ-сервисы домен, Аналитический домен  
**Бизнес-правила**: Инициирование базового анализа медицинских данных

#### 1.3 DiagnosisAdded
**Контекст-источник**: Медицинский домен, агрегат MedicalRecord  
**Семантика**: Добавлен новый диагноз в медицинскую карту  
**Минимальный контракт**:
```json
{
  "diagnosisId": "string",
  "medicalRecordId": "string",
  "patientId": "string",
  "diagnosisCode": "string",
  "description": "string",
  "diagnosedBy": "string",
  "diagnosisDate": "ISO-8601",
  "severity": "string"
}
```
**Подписчики**: ИИ-сервисы домен, Аналитический домен, Система уведомлений  
**Бизнес-правила**: Проверка совместимости диагноза с текущим лечением

#### 1.4 AppointmentScheduled
**Контекст-источник**: Медицинский домен, агрегат Appointment  
**Семантика**: Запланирована новая встреча пациента с врачом  
**Минимальный контракт**:
```json
{
  "appointmentId": "string",
  "patientId": "string",
  "doctorId": "string",
  "clinicId": "string",
  "appointmentDate": "ISO-8601",
  "durationMinutes": "number",
  "reason": "string",
  "status": "scheduled"
}
```
**Подписчики**: Финансовый домен, Аналитический домен, Система уведомлений  
**Бизнес-правила**: Проверка доступности врача, создание напоминаний

#### 1.5 TestResultRecorded
**Контекст-источник**: Медицинский домен, агрегат MedicalRecord  
**Семантика**: Записан результат диагностического исследования  
**Минимальный контракт**:
```json
{
  "testResultId": "string",
  "medicalRecordId": "string",
  "patientId": "string",
  "testType": "string",
  "resultValue": "string|number",
  "unit": "string",
  "referenceRange": "string",
  "performedBy": "string",
  "performedDate": "ISO-8601",
  "labId": "string"
}
```
**Подписчики**: ИИ-сервисы домен, Аналитический домен  
**Бизнес-правила**: Автоматический запуск анализа ИИ для аномальных результатов

### 2. События финансового домена

#### 2.1 AccountOpened
**Контекст-источник**: Финансовый домен, агрегат Account  
**Семантика**: Открыт новый банковский счет  
**Минимальный контракт**:
```json
{
  "accountId": "string",
  "accountNumber": "string",
  "customerId": "string",
  "accountType": "checking|savings|credit",
  "currency": "string",
  "openingDate": "ISO-8601",
  "initialBalance": "number"
}
```
**Подписчики**: Аналитический домен, Система уведомлений, Сервис аудита  
**Бизнес-правила**: Проверка KYC (Know Your Customer), создание начальной записи

#### 2.2 LoanContractCreated
**Контекст-источник**: Финансовый домен, агрегат LoanContract  
**Семантика**: Создан новый кредитный договор  
**Минимальный контракт**:
```json
{
  "loanContractId": "string",
  "customerId": "string",
  "loanAmount": "number",
  "interestRate": "number",
  "termMonths": "number",
  "purpose": "string",
  "createdDate": "ISO-8601",
  "status": "pending"
}
```
**Подписчики**: Аналитический домен, Система уведомлений, Сервис аудита  
**Бизнес-правила**: Проверка кредитной истории, расчет платежеспособности

#### 2.3 PaymentReceived
**Контекст-источник**: Финансовый домен, агрегат LoanContract  
**Семантика**: Получен платеж по кредиту  
**Минимальный контракт**:
```json
{
  "paymentId": "string",
  "loanContractId": "string",
  "customerId": "string",
  "amount": "number",
  "paymentDate": "ISO-8601",
  "paymentMethod": "string",
  "remainingBalance": "number"
}
```
**Подписчики**: Аналитический домен, Система уведомлений  
**Бизнес-правила**: Обновление баланса, проверка просрочек

#### 2.4 TransactionCompleted
**Контекст-источник**: Финансовый домен, агрегат Account  
**Семантика**: Выполнена финансовая транзакция  
**Минимальный контракт**:
```json
{
  "transactionId": "string",
  "fromAccountId": "string",
  "toAccountId": "string",
  "amount": "number",
  "currency": "string",
  "transactionDate": "ISO-8601",
  "description": "string",
  "transactionType": "transfer|deposit|withdrawal"
}
```
**Подписчики**: Аналитический домен, Сервис аудита, Система мониторинга  
**Бизнес-правила**: Проверка лимитов, AML (Anti-Money Laundering) проверка

### 3. События ИИ-сервисов домена

#### 3.1 AIProcessingCompleted
**Контекст-источник**: ИИ-сервисы домен, агрегат ResearchAnalysis  
**Семантика**: Завершена обработка медицинских данных ИИ  
**Минимальный контракт**:
```json
{
  "analysisId": "string",
  "researchDataId": "string",
  "modelId": "string",
  "confidenceScore": "number",
  "processingTimeMs": "number",
  "completionDate": "ISO-8601",
  "findings": "array"
}
```
**Подписчики**: Медицинский домен, Аналитический домен  
**Бизнес-правила**: Проверка уверенности модели, генерация рекомендаций

#### 3.2 AnomalyDetected
**Контекст-источник**: ИИ-сервисы домен, агрегат ResearchAnalysis  
**Семантика**: Обнаружена аномалия в медицинских данных  
**Минимальный контракт**:
```json
{
  "analysisId": "string",
  "researchDataId": "string",
  "anomalyType": "string",
  "severity": "low|medium|high|critical",
  "confidence": "number",
  "detectedDate": "ISO-8601",
  "description": "string",
  "recommendedAction": "string"
}
```
**Подписчики**: Медицинский домен, Система уведомлений, Аналитический домен  
**Бизнес-правила**: Срочное уведомление медицинского персонала

#### 3.3 DiagnosisGenerated
**Контекст-источник**: ИИ-сервисы домен, агрегат ResearchAnalysis  
**Семантика**: Сгенерирован предварительный диагноз на основе ИИ-анализа  
**Минимальный контракт**:
```json
{
  "analysisId": "string",
  "patientId": "string",
  "suggestedDiagnosis": "string",
  "confidence": "number",
  "supportingEvidence": "array",
  "generatedDate": "ISO-8601",
  "modelVersion": "string"
}
```
**Подписчики**: Медицинский домен, Аналитический домен  
**Бизнес-правила**: Требуется подтверждение врача перед применением

### 4. События аналитического домена

#### 4.1 ReportGenerated
**Контекст-источник**: Аналитический домен, агрегат Report  
**Семантика**: Сгенерирован новый аналитический отчет  
**Минимальный контракт**:
```json
{
  "reportId": "string",
  "reportType": "string",
  "generatedBy": "string",
  "generationDate": "ISO-8601",
  "timeRange": {
    "start": "ISO-8601",
    "end": "ISO-8601"
  },
  "parameters": "object",
  "dataPointCount": "number"
}
```
**Подписчики**: Data Lake, Легаси DWH (временно), Система архивации  
**Бизнес-правила**: Проверка доступа, обновление кэша отчетов

#### 4.2 KPIUpdated
**Контекст-источник**: Аналитический домен, агрегат Dashboard  
**Семантика**: Обновлен ключевой показатель эффективности  
**Минимальный контракт**:
```json
{
  "kpiId": "string",
  "kpiName": "string",
  "value": "number",
  "previousValue": "number",
  "changePercentage": "number",
  "updateDate": "ISO-8601",
  "timePeriod": "daily|weekly|monthly"
}
```
**Подписчики**: Дашборды в реальном времени, Система оповещений  
**Бизнес-правила**: Проверка пороговых значений, генерация оповещений

#### 4.3 DataSliceCreated
**Контекст-источник**: Аналитический домен, агрегат Report  
**Семантика**: Создан новый аналитический срез данных  
**Минимальный контракт**:
```json
{
  "sliceId": "string",
  "dimensions": "array",
  "metrics": "array",
  "rowCount": "number",
  "createdDate": "ISO-8601",
  "createdBy": "string",
  "dataFreshness": "ISO-8601"
}
```
**Подписчики**: Пользовательские дашборды, Кэш аналитики  
**Бизнес-правила**: Оптимизация запросов, обновление материализованных представлений

### 5. События управления персоналом

#### 5.1 EmployeeHired
**Контекст-источник**: Управление персоналом, агрегат Employee  
**Семантика**: Принят новый сотрудник  
**Минимальный контракт**:
```json
{
  "employeeId": "string",
  "firstName": "string",
  "lastName": "string",
  "position": "string",
  "department": "string",
  "hireDate": "ISO-8601",
  "salary": "number",
  "managerId": "string"
}
```
**Подписчики**: Все домены (для настройки доступа), Аналитический домен  
**Бизнес-правила**: Создание учетных записей, настройка прав доступа

#### 5.2 AccessGranted
**Контекст-источник**: Управление персоналом, агрегат Employee  
**Семантика**: Предоставлен доступ к системе или данным  
**Минимальный контракт**:
```json
{
  "accessGrantId": "string",
  "employeeId": "string",
  "resourceType": "system|data|report",
  "resourceId": "string",
  "permissions": "array",
  "grantedBy": "string",
  "grantDate": "ISO-8601",
  "expiryDate": "ISO-8601|null"
}
```
**Подписчики**: Все домены (для применения прав), Сервис аудита  
**Бизнес-правила**: Проверка соответствия политикам безопасности

## Матрица событий и их потребителей

| Событие | Источник | Основные потребители | Вторичные потребители | Критичность |
|---------|----------|---------------------|----------------------|-------------|
| PatientRegistered | Медицинский | Финансовый, Аналитический | Уведомления, Аудит | Высокая |
| DiagnosisAdded | Медицинский | ИИ-сервисы, Аналитический | Уведомления | Средняя |
| AppointmentScheduled | Медицинский | Финансовый, Аналитический | Уведомления, Календарь | Средняя |
| AccountOpened | Финансовый | Аналитический, Аудит | Уведомления | Высокая |
| LoanContractCreated | Финансовый | Аналитический, Аудит | Уведомления, Риск-менеджмент | Высокая |
| AIProcessingCompleted | ИИ-сервисы | Медицинский, Аналитический | Исследования, Качество | Высокая |
| AnomalyDetected | ИИ-сервисы | Медицинский, Уведомления | Аналитический, Руководство | Критическая |
| ReportGenerated | Аналитический | Data Lake, Архив | Пользователи, DWH | Низкая |
| KPIUpdated | Аналитический | Дашборды, Оповещения | Руководство, Менеджеры | Средняя |
| EmployeeHired | Управление персоналом | Все домены | Аналитический, Аудит | Высокая |

## Схемы событий и версионирование

### Принципы версионирования
1. **Семантическое версионирование**: MAJOR.MINOR.PATCH
2. **Обратная совместимость**: MINOR и PATCH изменения должны быть обратно совместимы
3. **Миграция**: Поддержка нескольких версий событий во время переходного периода
4. **Депрекация**: Четкий процесс устаревания и удаления старых версий

### Пример схемы события (Avro/JSON Schema)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "PatientRegistered",
  "description": "Событие регистрации пациента",
  "type": "object",
  "properties": {
    "eventId": {
      "type": "string",
      "format": "uuid"
    },
    "eventType": {
      "type": "string",
      "const": "PatientRegistered"
    },
    "eventVersion": {
      "type": "string",
      "const": "1.0.0"
    },
    "timestamp": {
      "type": "string",
      "format": "date-time"
    },
    "source": {
      "type": "string",
      "const": "medical:patient"
    },
    "aggregateId": {
      "type": "string"
    },
    "payload": {
      "type": "object",
      "properties": {
        "patientId": {
          "type": "string"
        },
        "firstName": {
          "type": "string"
        },
        "lastName": {
          "type": "string"
        },
        "dateOfBirth": {
          "