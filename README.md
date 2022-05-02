# Purpose

This lab will setup a Linux monitoring system using Ansible. It uses Prometheus + node-exporter to monitor server peformance (CPU, memory, disk, network, ...) and Loki + Promtail to monitor server logs (ssh, systemd, docker, auditd, ...)

![](deployment.png)

I tested scripts on my own computer but there maybe still have some bugs. Please notify me at tuanndd@gmail.com if there is a new bug.

# Prerequisite

- MacOS/Ubuntu/Debian Machine
- Vagrant

# Guideline

## 1. Preparation

### 1.1. Genenerate SSH key pairs

```bash
ssh-keygen -t ecdsa -b 521 ~/.ssh/vagrant
```

### 1.2. Install Ansible:

- On Ubuntu/Debian

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
sudo apt install python3-pip sshpass -y
pip3 install passlib --user
```

- On MacOS:

```bash
sudo python -m pip install ansible
ansible --version
sudo apt install python3-pip sshpass -y
pip3 install passlib --user
```

### 1.3. Provision 2 VMs

- 192.168.3.102 (server, h2)

- 192.168.3.103 (client, h3)

```bash
cd vagrant
vagrant up
cd ..
```

You can SSH into these VMs using:

```bash
ssh-add ~/.ssh/vagrant

# SSH to server VM
ssh vagrant@192.168.3.102

# SSH to client VM
ssh vagrant@192.168.3.103
```

### 1.4. Create self-signed certs

This only for demo, you should use trusted CA, for example Let's Encrypt to create free valid SSL certs 

```bash
./create-certs.sh
```

## 2. Install monitoring systems

### 2.1 Setup server

```bash
vi server-playbook.yml
# update vars: username, password, domain, ... (optional)

ansible-playbook server-playbook.yml
```

## 2.2 Setup client
```bash
vi client-playbook.yml
# update vars: username, password, domain, ... (optional)

ansible-playbook client-playbook.yml
```

# 2.3 Access Grafana dashboard

Add this entry to file /etc/hosts on your machine:

```
192.168.3.102 grafana.local.com
```

Then access url https://grafana.local.com (login info: username=admin, password=admin)

# Screenshots

Here are some screens you will see on Grafana.

![](screenshots/node-exporter-metrics.png)
![](screenshots/prometheus-metrics.png)
![](screenshots/loki-metrics.png)
![](screenshots/loki-logs.png)
