##############################################################
# main.tf
# Основная конфигурация для всех окружений.
# Окружение задаётся через переменную `environment`.
##############################################################

module "vm" {
  source = "./modules/vm"

  # Общие параметры
  name   = var.vm_name
  zone   = var.zone
  labels = local.labels

  # Параметры Yandex Cloud
  folder_id = var.yc_folder_id
  token     = var.yc_token

  # Вычислительные ресурсы
  cores         = var.cores
  memory        = var.memory
  core_fraction = var.core_fraction
  platform_id   = "standard-v3"

  # Загрузочный диск
  image_id       = var.image_id
  boot_disk_size = var.boot_disk_size
  boot_disk_type = var.boot_disk_type

  # Подключаемый диск
  secondary_disk_size = var.secondary_disk_size
  secondary_disk_type = var.secondary_disk_type

  # Сеть
  subnet_id  = var.subnet_id
  enable_nat = var.enable_nat

  # SSH доступ
  ssh_user       = var.ssh_user
  ssh_public_key = var.ssh_public_key
}

# Локальные значения для labels в зависимости от окружения
locals {
  labels = merge(
    {
      environment = var.environment
      managed-by  = "terraform"
    },
    var.environment == "prod" ? { critical = "true" } : {}
  )
}