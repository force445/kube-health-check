#!/bin/bash

is_master() {
    systemctl show -p ActiveState k3s 2>/dev/null | grep -q "ActiveState=active" && return 0
    systemctl show -p ActiveState k3s 2>/dev/null | grep -q "ActiveState=activating" && return 0
    return 1
}

is_agent() {
    systemctl show -p ActiveState k3s-agent 2>/dev/null | grep -q "ActiveState=active" && return 0
    systemctl show -p ActiveState k3s-agent 2>/dev/null | grep -q "ActiveState=activating" && return 0
    return 1
}

display_header() {
    echo "=== K3s Monitoring Toolbox ==="
    echo "USER: $USER"
    echo "MACHINE: $(hostname)"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "TIME ZONE: $(timedatectl | grep "Time zone" | awk '{print $3}')"
    echo "========================================"
}

monitor_status() {
  if is_master; then
  STATUS=$(systemctl status k3s | grep -E "Loaded:|Active:" | sed 's/^[ \t]*//')
    echo "K3s Master's status:"
    echo "$STATUS"
  
  elif is_agent; then 
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
  if is_master; then
  echo "Monitoring master's logs"
  journalctl -fu k3s.service

  elif is_agent; then
  echo "Monitoring agent's logs"
  journalctl -fu k3s-agent.service
  fi

}

restart_k3s() {
  TIMEOUT=300
  ELAPSED=0
  SLEEP_INTERVAL=10

  if is_master; then
    echo "Restarting K3s master..."
    systemctl restart k3s.service


    while ! is_master; do
        if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "Restart process is stuck! Please check K3s logs: journalctl -u k3s -n 50"
            exit 1
        fi

        echo "K3s is still activating... ($ELAPSED/$TIMEOUT seconds)"
        sleep $SLEEP_INTERVAL
        ((ELAPSED+=SLEEP_INTERVAL))
    done
    
    echo "K3s master restarted successfully! 🎉"

  elif is_agent; then
        echo "Restarting K3s agent..."
        systemctl restart k3s-agent.service

        ELAPSED=0

        while ! is_agent; do
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

inspect_kube_config() {
  echo "Inspecting kube config..."
  sudo cat /etc/rancher/k3s/k3s.yaml
}
