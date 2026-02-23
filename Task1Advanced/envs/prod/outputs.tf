##############################################################
# modules/vm/outputs.tf
# Полезные выходные значения модуля vm_module.
##############################################################

output "instance_id" {
  description = "ID созданной виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "instance_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "internal_ip" {
  description = "Внутренний (приватный) IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "Внешний (публичный) IP-адрес ВМ (пустой, если NAT отключён)"
  value       = try(yandex_compute_instance.vm.network_interface[0].nat_ip_address, "")
}

output "boot_disk_id" {
  description = "ID загрузочного диска"
  value       = yandex_compute_disk.boot.id
}

output "secondary_disk_id" {
  description = "ID подключаемого (secondary) диска"
  value       = yandex_compute_disk.secondary.id
}

output "fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.vm.fqdn
}

output "zone" {
  description = "Зона доступности, в которой развёрнута ВМ"
  value       = yandex_compute_instance.vm.zone
}
