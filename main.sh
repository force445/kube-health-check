#!/bin/bash

source ./function.sh

show_menu() {
    clear
    display_header
    echo "MAIN MENU:"
    echo "----------------------------------------"
    echo "[1] Monitor K3s service status ✅"
    echo "[2] Monitor logs 📜 📝"
    echo "[3] Restart K3s 🔄"
    echo "[4] Inspect the kube config 📜"
    echo "[99] Exit"
    echo "----------------------------------------"
    read -p "Enter your choice: " choice

    case $choice in
      1) monitor_status ;;
      2) monitoring_logs ;;
      3) restart_k3s ;;
      4) inspect_kube_config;;
      99) echo "Exiting..."; exit 0 ;;
      *) echo "Invalid choice, please try again." ;;
    esac

    read -p "Press Enter to continue..."
    show_menu
}

show_menu