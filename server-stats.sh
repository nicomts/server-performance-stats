#!/bin/bash

# Get total CPU usage
get_cpu_usage() {
  echo "CPU Usage:"
  top -bn1 | grep "Cpu(s)" |
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |
    awk '{print "CPU Load: " 100 - $1"%"}'
}

# Get total memory usage
get_memory_usage() {
  echo "Memory Usage:"
  free | grep "Mem:" -w | awk '{printf "Total: %.1fGi\nUsed: %.1fGi (%.2f%%)\nFree: %.1fGi (%.2f%%)\n",$2/1024^2, $3/1024^2, $3/$2 * 100, $4/1024^2, $4/$2 * 100}'
}

# Get total disk usage
get_disk_usage() {
  echo "Disk Usage:"
  df -h --total | awk '/total/ {printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, $5}'
}

# Get top 5 processes by CPU usage
get_top_cpu_processes() {
  echo "Top 5 Processes by CPU Usage:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}

# Get top 5 processes by memory usage
get_top_memory_processes() {
  echo "Top 5 Processes by Memory Usage:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
}

# Additional stats
get_additional_stats() {
  echo "OS: $(uname -a)"
  echo "Uptime: $(uptime -p)"
  echo "Load Average: $(uptime | awk -F'load average: ' '{print $2}')"
  echo "Logged in Users: $(who | wc -l)"
  grep "Failed password" /var/log/auth.log | wc -l
  echo "Failed login attempts: $(grep "Failed password" /var/log/auth.log | wc -l)"
}

main() {
  echo "Server Performance Stats"
  echo "========================"

  get_cpu_usage
  echo ""

  get_memory_usage
  echo ""

  get_disk_usage
  echo ""

  get_top_cpu_processes
  echo ""

  get_top_memory_processes
  echo ""

  get_additional_stats
}

main
