# Дипломный практикум в Yandex.Cloud

1. Конфигурационные файлы terraform лежат в корне данного репозитория:  
[main.tf](./main.tf) - основной файл с описанием провайдера и s3 backend.  
[vpc.tf](./vpc.tf) - файл с описанием сетевых ресурсов.  
[kubernetes.tf](./kubernetes.tf) - файл с описанием виртуальных машин для kubernetes.  

2. 

3. Конфигурация ansible для создания кластера лежит в директории [ansible](./ansible/).

4. Ссылка на gitlab репозиторий с Dockerfile: https://gitlab.com/mygroup6545734/netology-diplom  
Ссылка на dockerhub репозиторий с собранным контейнером: https://hub.docker.com/repository/docker/grandost60/nginx-app/general  

5. Конфигурация мониторинга kubenretes кластера лежит в директории [ansible/files/monitoring/manifests](./ansible/files/monitoring/manifests/) и применяется на этапе создания kubernetes кластера.

6. Ссылка на CI/CD - https://gitlab.com/mygroup6545734/netology-diplom
7. Ссылка на тестовое приложение: http://89.169.131.232:31661  
Ссылка на web-интерфейс grafana: http://89.169.131.232:30536  
Логин/пароль: admin/admin