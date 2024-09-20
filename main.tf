terraform {
required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoints   = {
    s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "terraform-object-storage-netology"
    region     = "ru-central1"
    access_key = "***"
    secret_key = "***"
    key        = "terraform_state/terraform_state>.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
  }
}


  provider "yandex" {
  
  token     = "***"
  cloud_id  = "b1gnea65n4qcsac8i3td"
  folder_id = "b1gda72ev3btfpeud0sc"
  #service_account_key_file = file("my-robot-key.json")
  zone      =  "ru-central1-a"

}

resource "yandex_iam_service_account_static_access_key" "my-robot" {

 service_account_id = "ajeac8batdalgp9gkiia"
 description        = "robot_key"

 }