##############################################################
# modules/vm/main.tf
# Создаёт ВМ, загрузочный диск, подключаемый диск и сетевой
# интерфейс в Yandex Cloud. Все значения — через переменные.
##############################################################

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  zone      = var.zone
  token     = var.token
}

# ─────────────────────────────────────────────
# Загрузочный диск (boot disk)
# ─────────────────────────────────────────────
resource "yandex_compute_disk" "boot" {
  name     = "${var.name}-boot"
  type     = var.boot_disk_type
  zone     = var.zone
  size     = var.boot_disk_size
  folder_id = var.folder_id
  labels = merge(var.labels, { role = "boot" })
}

# ─────────────────────────────────────────────
# Подключаемый (secondary) диск
# ─────────────────────────────────────────────
resource "yandex_compute_disk" "secondary" {
  name = "${var.name}-data"
  type = var.secondary_disk_type
  zone = var.zone
  size = var.secondary_disk_size
  folder_id = var.folder_id
  labels = merge(var.labels, { role = "data" })
}

# ─────────────────────────────────────────────
# Виртуальная машина
# ─────────────────────────────────────────────
resource "yandex_compute_instance" "vm" {
  name        = var.name
  hostname    = var.name
  platform_id = var.platform_id
  zone        = var.zone
  labels = var.labels
  folder_id = var.folder_id
  
  resources {
    cores         = var.cores
    memory        = var.memory
#    core_fraction = var.core_fraction
  }

  # Загрузочный диск
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  # Подключаемый диск
  secondary_disk {
    disk_id     = yandex_compute_disk.secondary.id
#    auto_delete = false
#    mode        = "READ_WRITE"
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.enable_nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }

  allow_stopping_for_update = true

}
