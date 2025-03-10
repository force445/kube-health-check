#!/bin/bash

# Function to display system info
display_header() {
    echo "=== K3s Monitoring Toolbox ==="
    echo "USER: $USER"
    echo "MACHINE: $(hostname)"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "TIME ZONE: $(timedatectl | grep "Time zone" | awk '{print $3}')"
    echo "========================================"
}

monitor_status() {
  if systemctl is-active --quiet k3s; then
  STATUS=$(systemctl status k3s | grep -E "Loaded:|Active:" | sed 's/^[ \t]*//')
    echo "K3s Master's status:"
    echo "$STATUS"
  
  elif systemctl is-active --quiet k3s-agent; then 
  STATUS=$(systemctl status k3s-agent | grep -E "Loaded:|Active:" | sed 's/^[ \t]*//')
    echo "K3s Master's status:"
    echo "$STATUS"
  
  else
    STATUS="K3s is not running."
    echo "$STATUS"
  fi
}

monitoring_logs() {
  trap 'echo -e "\nExiting log monitoring... Returning to menu."; return' SIGINT
  if systemctl is-active --quiet k3s; then
  echo "Monitoring master's logs"
  journalctl -fu k3s.service

  elif systemctl is-active --quiet k3s-agent; then
  echo "Monitoring agent's logs"
  journalctl -fu k3s-agent.service
  fi

}

restart_k3s() {
  TIMEOUT=300
  ELAPSED=0
  SLEEP_INTERVAL=10

  if systemctl is-active --quiet k3s; then
    echo "Restarting K3s master..."
    systemctl restart k3s.service


    while ! systemctl is-active --quiet k3s; do
        if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "Restart process is stuck! Please check K3s logs: journalctl -u k3s -n 50"
            exit 1
        fi

        echo "K3s is still activating... ($ELAPSED/$TIMEOUT seconds)"
        sleep $SLEEP_INTERVAL
        ((ELAPSED+=SLEEP_INTERVAL))
    done
    
    echo "K3s master restarted successfully! 🎉"

  elif systemctl is-active --quiet k3s-agent; then
        echo "Restarting K3s agent..."
        systemctl restart k3s-agent.service

        ELAPSED=0

        while ! systemctl is-active --quiet k3s-agent; do
            if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
                echo "Restart process is stuck! Please check K3s logs: journalctl -u k3s-agent -n 50"
                exit 1
            fi

            echo "K3s agent is still activating... ($ELAPSED/$TIMEOUT seconds)"
            sleep $SLEEP_INTERVAL
            ((ELAPSED+=SLEEP_INTERVAL))
        done

        echo "K3s agent restarted successfully! 🎉"

    else
        echo "Neither K3s master nor agent is running."
    fi
}

show_menu() {
    clear
    display_header
    echo "MAIN MENU:"
    echo "----------------------------------------"
    echo "[1] Monitor K3s service status"
    echo "[2] Monitor logs"
    echo "[3] Restart K3s"
    echo "[4] Export logs"
    echo "[99] Exit"
    echo "----------------------------------------"
    read -p "Enter your choice: " choice

    case $choice in
      1) monitor_status ;;
      2) monitoring_logs ;;
      3) restart_k3s ;;
      99) echo "Exiting..."; exit 0 ;;
      *) echo "Invalid choice, please try again." ;;
    esac

    read -p "Press Enter to continue..."
    show_menu
}

show_menu