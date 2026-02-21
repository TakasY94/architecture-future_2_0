# vm_module — переиспользуемый Terraform-модуль для Yandex Cloud

Модуль создаёт **виртуальную машину**, **загрузочный диск**, **подключаемый (secondary) диск** и настраивает **сетевой интерфейс** в Yandex Compute Cloud. Никаких захардкоженных значений — всё управляется через переменные, что позволяет применять один и тот же модуль в разных окружениях (`dev`, `stage`, `prod`).

---

## Структура репозитория

```
TaskAdvanced1/
├── modules/
│   └── vm/
│       ├── main.tf        # Ресурсы: yandex_compute_instance, yandex_compute_disk (x2)
│       ├── variables.tf   # Входные переменные модуля
│       └── outputs.tf     # Выходные значения
└── envs/
    ├── dev/
    │   ├── provider.tf    # Провайдер + backend (опционально)
    │   ├── main.tf        # Вызов модуля с dev-параметрами
    │   ├── variables.tf   # Переменные окружения
    │   ├── outputs.tf     # Проксируемые outputs
    │   └── dev.tfvars     # Значения переменных для dev
    ├── stage/             # Аналогично dev
    └── prod/              # Аналогично dev
```

---

## Параметры модуля (`modules/vm/variables.tf`)

### Общие

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `name` | `string` | — | Имя ВМ и префикс для дисков |
| `zone` | `string` | `ru-central1-a` | Зона доступности |
| `labels` | `map(string)` | `{}` | Метки для всех ресурсов |

### Вычислительные ресурсы

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `cores` | `number` | `2` | Количество vCPU |
| `memory` | `number` | `2` | Объём RAM в ГБ |
| `core_fraction` | `number` | `100` | Гарантированная доля CPU (5 / 20 / 100 %) |
| `platform_id` | `string` | `standard-v3` | Платформа ВМ |

### Загрузочный диск

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `image_id` | `string` | — | ID образа (обязательно) |
| `boot_disk_size` | `number` | `20` | Размер в ГБ |
| `boot_disk_type` | `string` | `network-hdd` | Тип: `network-hdd`, `network-ssd`, `network-ssd-nonreplicated` |

### Подключаемый (secondary) диск

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `secondary_disk_size` | `number` | `50` | Размер в ГБ |
| `secondary_disk_type` | `string` | `network-hdd` | Тип диска |

### Сеть

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `subnet_id` | `string` | — | ID подсети (обязательно) |
| `enable_nat` | `bool` | `false` | Включить внешний NAT |

### SSH

| Переменная | Тип | По умолчанию | Описание |
|---|---|---|---|
| `ssh_user` | `string` | `ubuntu` | Имя пользователя |
| `ssh_public_key` | `string` | — | Содержимое публичного ключа (обязательно) |

---

## Выходные значения (`outputs.tf`)

| Output | Описание |
|---|---|
| `instance_id` | ID виртуальной машины |
| `instance_name` | Имя ВМ |
| `internal_ip` | Внутренний IP-адрес |
| `external_ip` | Внешний IP (если NAT включён) |
| `boot_disk_id` | ID загрузочного диска |
| `secondary_disk_id` | ID подключаемого диска |
| `fqdn` | FQDN ВМ |
| `zone` | Зона доступности |

---

## Сравнение окружений

| Параметр | dev | stage | prod |
|---|---|---|---|
| vCPU | 2 | 4 | 8 |
| RAM | 2 ГБ | 8 ГБ | 16 ГБ |
| core_fraction | 20 % | 100 % | 100 % |
| Boot disk | 20 ГБ HDD | 30 ГБ SSD | 50 ГБ SSD |
| Data disk | 20 ГБ HDD | 100 ГБ SSD | 500 ГБ SSD |
| NAT | ✅ | ✅ | ❌ (bastion) |
| Зона | ru-central1-a | ru-central1-b | ru-central1-a |

---

## Быстрый старт

### 1. Получите актуальный image_id

```bash
yc compute image list --folder-id standard-images | grep ubuntu-22
```

Скопируйте нужный ID в соответствующий `*.tfvars`.

### 2. Заполните переменные в `.tfvars`

Откройте `envs/<env>/<env>.tfvars` и замените заглушки:
- `YOUR_CLOUD_ID` → ID вашего облака (`yc config get cloud-id`)
- `YOUR_<ENV>_FOLDER_ID` → ID каталога (`yc config get folder-id`)
- `YOUR_<ENV>_SUBNET_ID` → ID подсети (`yc vpc subnet list`)

### 3. Передайте чувствительные переменные через env

```bash
export TF_VAR_yc_token="$(yc iam create-token)"
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"
```

### 4. Запустите нужное окружение

#### dev
```bash
cd envs/dev
terraform init
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
terraform destroy -var-file="dev.tfvars"
```

#### stage
```bash
cd envs/stage
terraform init
terraform plan  -var-file=stage.tfvars
terraform apply -var-file=stage.tfvars
```

#### prod
```bash
cd envs/prod
terraform init
terraform plan  -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

### 5. Уничтожить ресурсы окружения

```bash
terraform destroy -var-file=<env>.tfvars
```


---

## Требования

| Инструмент | Версия |
|---|---|
| Terraform | >= 1.3.0 |
| yandex-cloud/yandex провайдер | >= 0.84.0 |
| Yandex Cloud CLI (`yc`) | любая актуальная |