variable "bucket_name" {
  type        = string
  default = "egorkin-netology-s3"
  description = "Имя s3 bucket"
}
# Заменить на ID своего облака
variable "yandex_cloud_id" {
  default = "b1g0tptlsvgkbge2ul42"
}

# Заменить на Folder своего облака
variable "yandex_folder_id" {
  default = "b1gc36q9v49llnddjkvr"
}

# Lamp
variable "lamp-instance-image-id" {
  default = "fd827b91d99psvq5fjit"
}
