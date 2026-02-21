##############################################################
# modules/vm/providers.tf
# Конфигурация провайдера для модуля VM
##############################################################

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}