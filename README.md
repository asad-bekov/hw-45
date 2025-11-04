# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

> Репозиторий: hw-45\
> Выполнил: Асадбек Асадбеков\
> Дата: ноябрь 2025

**Цель:**
Организовать отказоустойчивую инфраструктуру, состоящую из:
- кластера **Kubernetes** (в публичных подсетях);
- кластера **MySQL Managed Service** (в приватных подсетях);
- веб-интерфейса **phpMyAdmin** для работы с БД.

---

## Архитектура решения

```
┌───────────────────────┐             ┌────────────────────────┐
│     LoadBalancer      │             │     MySQL Cluster      │
│  EXTERNAL IP: 84.252.133.192        │  (3 ноды, приватные)   │
└───────────┬───────────┘             └──────────┬─────────────┘
            │                                    │
            ▼                                    ▼
┌───────────────────────┐             ┌────────────────────────┐
│      phpMyAdmin       │             │     Private Subnets     │
│     (Pod в K8s)       │             │ 192.168.10.0/24         │
│                       │             │ 192.168.20.0/24         │
└───────────┬───────────┘             │ 192.168.30.0/24         │
            ▼                        └────────────────────────┘
┌───────────────────────┐
│    K8s Cluster (3 ноды)│
└───────────┬───────────┘
            ▼
┌────────────────────────┐
│     Public Subnets      │
│ 192.168.40.0/24         │
│ 192.168.50.0/24         │
│ 192.168.60.0/24         │
└────────────────────────┘
```

---

## Скриншоты и результаты выполнения

### Проверка кластера MySQL в CLI
**Команда:**
```bash
yc managed-mysql cluster list
```
**Описание:**
Проверка существующих кластеров MySQL в YC. Вывод подтверждает, что кластер **netology-mysql** создан и находится в статусе **ALIVE / RUNNING**.

![yc mysql list](https://github.com/asad-bekov/hw-45/blob/main/img/1.PNG)

---

### Веб-консоль YC — раздел Managed Service for MySQL → Кластеры
**Описание:**
Визуальная проверка состояния кластера **netology-mysql** в консоли. Отображается его **ID**, **версия MySQL (8.0)**, **статус Alive**, дата создания и зоны размещения.

![mysql web console](https://github.com/asad-bekov/hw-45/blob/main/img/2.PNG)

---

### Веб-консоль YC — раздел Managed Service for Kubernetes → Кластеры
**Описание:**
Проверка состояния кластера **netology-k8s**. Статус **Running** и **Healthy** подтверждают, что кластер успешно развернут и готов к работе.

![k8s cluster](https://github.com/asad-bekov/hw-45/blob/main/img/3.PNG)

---

### Веб-консоль YC — раздел Compute Cloud → Виртуальные машины
**Описание:**
Просмотр нод кластера Kubernetes. На скриншоте видны три ВМ с ОС **Linux**, статусом **Running**, по **4 ГБ RAM** и **2 vCPU** каждая — это рабочие ноды кластера **netology-k8s**.

![vm nodes](https://github.com/asad-bekov/hw-45/blob/main/img/4.PNG)

---

### Проверка состояния нод и системных подов
**Команда:**
```bash
kubectl get nodes && kubectl get pods -A
```
**Описание:**
Проверка состояния нод и системных подов в кластере Kubernetes. Все ноды в статусе **Ready**, а все поды (**Calico, CoreDNS, kube-proxy**) — в статусе **Running**.

![kubectl get nodes](https://github.com/asad-bekov/hw-45/blob/main/img/5.PNG)

---

### Проверка запуска phpMyAdmin
**Команда:**
```bash
kubectl get pods -l app=phpmyadmin && kubectl get service phpmyadmin-service
```
**Описание:**
Проверка пода **phpmyadmin** и его сервиса. Под в статусе **Running**, сервис типа **LoadBalancer** с публичным IP **84.252.133.192** и портом **80:30165/TCP**.

![phpmyadmin service](https://github.com/asad-bekov/hw-45/blob/main/img/6.PNG)

---

### Проверка доступа к phpMyAdmin через браузер
**Команда:**
Открытие публичного IP в браузере: [http://84.252.133.192/index.php](http://84.252.133.192/index.php)

**Описание:**
Успешный доступ к веб-интерфейсу **phpMyAdmin**. Видно подключение к MySQL-серверу **netology-mysql**, список баз данных (**information_schema**, **netology_db**, **performance_schema**) и интерфейс на русском языке.

![phpmyadmin web ui](https://github.com/asad-bekov/hw-45/blob/main/img/7.PNG)

---

## Развертывание

```bash
terraform init
terraform plan
terraform apply
yc managed-kubernetes cluster get-credentials netology-k8s --external
kubectl apply -f phpmyadmin.yaml
kubectl get nodes
kubectl get pods -A
kubectl get service phpmyadmin-service
```

---

## Итоги

Все цели задания достигнуты:

- Развернут **отказоустойчивый кластер MySQL** (3 ноды в приватных подсетях)
- Создан **региональный кластер Kubernetes** (3 зоны)
- Настроена **группа узлов** с автомасштабированием
- Развернут **phpMyAdmin** с доступом через LoadBalancer
- Обеспечено подключение к **Managed MySQL**
- Архитектура полностью соответствует требованиям отказоустойчивости

---

## Используемый стек

- **Terraform**
- **Yandex Cloud**
- **Kubernetes**
- **MySQL 8.0**
- **phpMyAdmin**
- **LoadBalancer**

---

