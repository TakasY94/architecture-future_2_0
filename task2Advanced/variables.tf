##############################################################
# variables.tf
# Переменные для всех окружений.
##############################################################

# ── Переменная для определения окружения ───────────────────

variable "environment" {
  description = "Окружение (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# ── Переменные для Yandex Cloud провайдера ───────────────────

variable "yc_token" {
  description = "IAM-токен для аутентификации в Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Cloud ID в Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Folder ID для текущего окружения"
  type        = string
  sensitive   = true
}

# ── Переменные для удалённого backend ────────────────────────

variable "yc_access_key" {
  description = "Access key для Yandex Object Storage"
  type        = string
  sensitive   = true
}

variable "yc_secret_key" {
  description = "Secret key для Yandex Object Storage"
  type        = string
  sensitive   = true
}

# ── Переменные для модуля vm ────────────────────────────────

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "dev-vm"
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Объём оперативной памяти в ГБ"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Гарантированная доля vCPU"
  type        = number
  default     = 20
}

variable "image_id" {
  description = "ID образа для загрузочного диска"
  type        = string
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Тип загрузочного диска"
  type        = string
  default     = "network-hdd"
}

variable "secondary_disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
  default     = 20
}

variable "secondary_disk_type" {
  description = "Тип подключаемого диска"
  type        = string
  default     = "network-hdd"
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "enable_nat" {
  description = "Включить внешний NAT"
  type        = bool
  default     = true
}

variable "ssh_user" {
  description = "Имя пользователя для SSH"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}