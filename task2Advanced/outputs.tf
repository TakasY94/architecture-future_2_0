##############################################################
# outputs.tf
# Выходные значения для всех окружений.
##############################################################

output "instance_id" {
  description = "ID созданной виртуальной машины"
  value       = module.vm.instance_id
}

output "instance_name" {
  description = "Имя виртуальной машины"
  value       = module.vm.instance_name
}

output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = module.vm.internal_ip
}

output "external_ip" {
  description = "Внешний IP-адрес ВМ"
  value       = module.vm.external_ip
}

output "fqdn" {
  description = "FQDN виртуальной машины"
  value       = module.vm.fqdn
}

output "zone" {
  description = "Зона доступности"
  value       = module.vm.zone
}

output "environment" {
  description = "Текущее окружение"
  value       = var.environment
}