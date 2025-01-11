output "external_load_balancer_ip" {
  value = yandex_lb_network_load_balancer.lb-lamp.listener.*.external_address_spec[0].*.address[0]
}

output "bucket_domain_name" {
  value = "http://${yandex_storage_bucket.s3bucket2.bucket_domain_name}/sea"
}
