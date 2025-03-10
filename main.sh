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

show_menu() {
    clear
    display_header
}

show_menu