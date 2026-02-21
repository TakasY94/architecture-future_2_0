##############################################################
# provider.tf
# Конфигурация провайдера Yandex Cloud и общие настройки Terraform.
##############################################################

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  zone      = var.zone
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}