##############################################################
# backend.tf
# Частичная конфигурация удалённого backend для хранения состояния Terraform
# в Yandex Object Storage. Имя bucket должно быть передано через -backend-config
# параметры или файл конфигурации.
##############################################################

terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    # bucket будет передан через -backend-config
    key      = "terraform.tfstate"
    region   = "ru-central1"

    # Ключи доступа НЕ указываем здесь - они будут предоставлены отдельно
    # access_key = ...
    # secret_key = ...

    # Настройки для совместимости с Yandex Object Storage
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    use_path_style              = true
    skip_requesting_account_id  = true

  }
}