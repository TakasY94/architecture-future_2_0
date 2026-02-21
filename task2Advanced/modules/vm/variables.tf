##############################################################
# modules/vm/variables.tf
# Входные параметры модуля vm_module.
##############################################################

# ── Общие ────────────────────────────────────────────────────

variable "name" {
  description = "Имя ВМ и префикс для дисков (3–63 символа, строчные буквы, цифры, дефис)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.name))
    error_message = "Имя должно быть от 3 до 63 символов, начинаться с буквы и не заканчиваться дефисом."
  }
}

variable "zone" {
  description = "Зона доступности Yandex Cloud (например, ru-central1-a)"
  type        = string
  default     = "ru-central1-a"
}

variable "labels" {
  description = "Метки (key=value) для всех создаваемых ресурсов"
  type        = map(string)
  default     = {}
}

variable "folder_id" {
  description = "ID каталога (Folder ID) в Yandex Cloud"
  type        = string
}

variable "token" {
  description = "OAuth-токен или IAM-токен для аутентификации в Yandex Cloud"
  type        = string
  sensitive   = true
}

# ── Вычислительные ресурсы ────────────────────────────────────

variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2

  validation {
    condition     = contains([2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32], var.cores)
    error_message = "Допустимые значения cores: 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32."
  }
}

variable "memory" {
  description = "Объём оперативной памяти в ГБ"
  type        = number
  default     = 2

  validation {
    condition     = var.memory >= 1 && var.memory <= 1024
    error_message = "Объём RAM должен быть от 1 до 1024 ГБ."
  }
}

variable "core_fraction" {
  description = "Гарантированная доля vCPU (5, 20 или 100 %)"
  type        = number
  default     = 100

  validation {
    condition     = contains([5, 20, 100], var.core_fraction)
    error_message = "core_fraction должен быть 5, 20 или 100."
  }
}

variable "platform_id" {
  description = "Платформа ВМ (standard-v1, standard-v2, standard-v3)"
  type        = string
  default     = "standard-v3"
}

# ── Загрузочный диск ─────────────────────────────────────────

variable "image_id" {
  description = "ID образа для загрузочного диска (yc compute image list --folder-id standard-images)"
  type        = string
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_size >= 10
    error_message = "Размер загрузочного диска должен быть не менее 10 ГБ."
  }
}

variable "boot_disk_type" {
  description = "Тип загрузочного диска: network-hdd, network-ssd, network-ssd-nonreplicated"
  type        = string
  default     = "network-hdd"

  validation {
    condition     = contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated"], var.boot_disk_type)
    error_message = "Допустимые типы дисков: network-hdd, network-ssd, network-ssd-nonreplicated."
  }
}

# ── Подключаемый (secondary) диск ────────────────────────────

variable "secondary_disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
  default     = 50

  validation {
    condition     = var.secondary_disk_size >= 10
    error_message = "Размер подключаемого диска должен быть не менее 10 ГБ."
  }
}

variable "secondary_disk_type" {
  description = "Тип подключаемого диска: network-hdd, network-ssd, network-ssd-nonreplicated"
  type        = string
  default     = "network-hdd"

  validation {
    condition     = contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated"], var.secondary_disk_type)
    error_message = "Допустимые типы дисков: network-hdd, network-ssd, network-ssd-nonreplicated."
  }
}

# ── Сеть ─────────────────────────────────────────────────────

variable "subnet_id" {
  description = "ID подсети (Subnet ID), в которую будет подключена ВМ"
  type        = string
}

variable "enable_nat" {
  description = "Включить внешний NAT (публичный IP) для ВМ"
  type        = bool
  default     = false
}

# ── SSH-доступ ───────────────────────────────────────────────

variable "ssh_user" {
  description = "Имя пользователя для SSH-подключения"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ (содержимое файла .pub)"
  type        = string
  sensitive   = true
}