# Lightweight Kubernetes Health Check tool

This repository provided a collection of Bash scripts for K3s health check

## Installation
1. Clone the repository
2. Make main.sh executable


```bash
git clone https://github.com/force445/kube-health-check.git
cd kube-health-check
chmod +x main.sh
```


## Usage
Execute the main script


```bash
./main.sh
```


You will be presented with a menu-driven interface that allows you to perform various tasks like this.


```bash
=== K3s Monitoring Toolbox ===
USER: systemadmin
MACHINE: control-plane-1
OS: Ubuntu 24.04.1 LTS
TIME ZONE: Etc/UTC
========================================
MAIN MENU:
----------------------------------------
[1] Monitor K3s service status
[2] Monitor logs
[3] Restart K3s
[99] Exit
----------------------------------------
Enter your choice: 
```


You can customize these configuration files to add, modify, or remove options as needed.
