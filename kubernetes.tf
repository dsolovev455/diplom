locals {
  master_core_count = {
    stage = 4
    prod = 2
  }
  master_memory = {
    stage = 4
    prod = 2
  }
  names = {
    prod = {
        name1 = "kube-worker-1"
        name2 = "kube-worker-2"
    }
    stage = {}
  }
  ansible_command = {
    prod = "cd ./ansible && sleep 50 && ansible-playbook preinstallation.yml multihost_kubernetes.yml monitoring.yml -i hosts.txt --ssh-common-args='-o StrictHostKeyChecking=no'"
    stage = "cd ./ansible && sleep 50 && ansible-playbook preinstallation.yml onehost_kubernetes.yml monitoring.yml -i hosts.txt --ssh-common-args='-o StrictHostKeyChecking=no'"
  }
}

resource "yandex_compute_instance" "kube-master" {
  name = "kube-master"
  hostname = "kube-master"

  resources {
    cores  = local.master_core_count[terraform.workspace]
    memory = local.master_memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ch5n0oe99ktf1tu8r"
      size = 40
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }

#  scheduling_policy {
#    preemptible = true
#  }
}

resource "yandex_compute_instance" "vm-foreach" {
  for_each = local.names[terraform.workspace]

  name = each.value
  hostname = each.value

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ch5n0oe99ktf1tu8r"
      size = 40
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

#  scheduling_policy {
#    preemptible = true
#  }
}

resource "local_file" "inventory" {
  filename = "./ansible/hosts.txt"
  content = <<EOF
[kubeMaster]
${yandex_compute_instance.kube-master.hostname} ansible_host=${yandex_compute_instance.kube-master.network_interface[0].nat_ip_address} ansible_user=ubuntu

[kubeWorkers]
%{ for item_value in yandex_compute_instance.vm-foreach ~}
${item_value.hostname} ansible_host=${item_value.network_interface[0].nat_ip_address} ansible_user=ubuntu
%{ endfor ~}
EOF
  
  provisioner "local-exec" {
    command = local.ansible_command[terraform.workspace]
  }
}