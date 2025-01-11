#// Create SA
#resource "yandex_iam_service_account" "sa-ig" {
#    name      = "sa-for-ig"
#}


#// Grant permissions
#resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
#    folder_id = var.yandex_folder_id
#    role      = "compute.editor"
#    member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
#}

#resource "yandex_resourcemanager_folder_iam_member" "load-balancer-editor" {
#  folder_id = var.yandex_folder_id
#  role      = "load-balancer.editor"
#  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
#}

// Create instance group
resource "yandex_compute_instance_group" "lamp-group" {
  name                = "lamp-group-with-balancer"
  folder_id           = var.yandex_folder_id
#  service_account_id  = yandex_iam_service_account.sa-ig.id
  service_account_id = "aje8fqt3qqaci8hsjcmh" 
  
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp-instance-image-id  # LAMP
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.cloud-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat       = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    serial-port-enable = "1"
    user-data  = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><head><title>Cat</title></head> <body><h1>Hello!</h1><img src="http://${yandex_storage_bucket.s3bucket2.bucket_domain_name}/sea"/></body></html>' > index.html
#echo '<html><head><title>Cat</title></head><body><h1>Hello!</h1><img src="http://s3bucket2.website.yandexcloud.net/cat"/"></body></html>' > index.html
service httpd start
EOF
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

   allocation_policy {
     zones = ["ru-central1-a"]
   }

  deploy_policy {
    max_unavailable  = 1
    max_expansion    = 0
    max_creating     = 3
    max_deleting     = 1
    startup_duration = 3
  }

  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }

  load_balancer {
    target_group_name        = "target-group-lamp"
    target_group_description = "load balancer target group lamp"
  }
}
