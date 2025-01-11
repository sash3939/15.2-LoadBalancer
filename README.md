# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

<img width="719" alt="Apply" src="https://github.com/user-attachments/assets/e28d10e9-7e9d-4f75-aa2b-09014547a8e2" />

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 
 <img width="935" alt="Bucket" src="https://github.com/user-attachments/assets/408b0bfc-6461-4833-a05c-1a9a648e1f6b" />
 
 - Сделать файл доступным из интернета.
   
https://egorkin-netology-s3.website.yandexcloud.net/sea
https://egorkin-netology-s3.website.yandexcloud.net/sea2

<img width="962" alt="sea" src="https://github.com/user-attachments/assets/03bc8341-f245-4e18-be48-fc8270d95f87" />

<img width="953" alt="sea2" src="https://github.com/user-attachments/assets/9a5afd53-2f41-46e6-9650-06036c73e404" />

2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.

 <img width="1217" alt="VM" src="https://github.com/user-attachments/assets/42b38e30-c1b6-4d1c-99df-9bfe4549a634" />

 <img width="1061" alt="Instance group" src="https://github.com/user-attachments/assets/e4e785d5-0d22-4259-8d7e-443c212e5b81" />

 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.


```
user-data  = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><head><title>Cat</title></head> <body><h1>Hello!</h1><img src="http://${yandex_storage_bucket.s3bucket2.bucket_domain_name}/sea.jpg"/></body></html>' > index.html
echo '<html><head><title>Cat1</title></head> <body><h1>Hello!</h1><img src="http://${yandex_storage_bucket.s3bucket2.bucket_domain_name}/sea2.jpg"/></body></html>' > index.ht>
service httpd start
EOF
```
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.

<img width="694" alt="LB" src="https://github.com/user-attachments/assets/3c35bb2c-2787-412e-be1b-a98d6648c5f2" />

<img width="829" alt="LB-picture" src="https://github.com/user-attachments/assets/2b3b26c5-1cd0-4bc3-ba2b-c13f27fd44ab" />

 - Проверить работоспособность, удалив одну или несколько ВМ.
Останавливаем 1 ВМ, и проверим что у нас все равно сайт работает, и балансировщик перенаправляет траффик

<img width="1084" alt="Stopped VM" src="https://github.com/user-attachments/assets/d5a0d4e0-f638-4a6e-bffc-ff1e89638bea" />

Сайт по прежнему доступен

<img width="893" alt="After stopped check" src="https://github.com/user-attachments/assets/591151e7-c265-4d73-ab8b-78916a36737d" />


4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

<img width="385" alt="alb_backend_group" src="https://github.com/user-attachments/assets/87df01fb-845a-486c-847b-47cf8bf6f3e9" />

<img width="404" alt="alb_http_router" src="https://github.com/user-attachments/assets/0945115c-96a0-4795-aa83-b6f658f48635" />

<img width="374" alt="alb_load_balancer" src="https://github.com/user-attachments/assets/c8c7418a-78d7-42b7-8d3c-0715bfe292f5" />

<img width="536" alt="alb_target_group" src="https://github.com/user-attachments/assets/b95d1e5e-5fd8-4e70-bd97-502aa110dbd2" />

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
## Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource Terraform:

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```
### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
