#!/bin/bash

# CPU
cpu_idle=$(awk '/^cpu / {print $5}' /proc/stat)
cpu_total=$(awk '/^cpu / {total=0; for(i=2;i<=NF;i++) total+=$i; print total}' /proc/stat)
cpu_idle_prev=$(cat /tmp/waybar_cpu_idle_prev 2>/dev/null || echo "$cpu_idle")
cpu_total_prev=$(cat /tmp/waybar_cpu_total_prev 2>/dev/null || echo "$cpu_total")
echo "$cpu_idle"  > /tmp/waybar_cpu_idle_prev
echo "$cpu_total" > /tmp/waybar_cpu_total_prev
cpu_delta=$(( cpu_total - cpu_total_prev ))
cpu_idle_delta=$(( cpu_idle - cpu_idle_prev ))
[ "$cpu_delta" -gt 0 ] && cpu_pct=$(( (cpu_delta - cpu_idle_delta) * 100 / cpu_delta )) || cpu_pct=0

# RAM
ram_total_kb=$(awk '/^MemTotal/     {print $2}' /proc/meminfo)
ram_avail_kb=$(awk '/^MemAvailable/ {print $2}' /proc/meminfo)
ram_used_kb=$(( ram_total_kb - ram_avail_kb ))
ram_pct=$(( ram_used_kb * 100 / ram_total_kb ))

# DISK
disk_used_kb=$(df -k / | awk 'NR==2 {print $3}')
disk_total_kb=$(df -k / | awk 'NR==2 {print $2}')
disk_pct=$(df -k / | awk 'NR==2 {print $5}' | tr -d '%')

# HUMAN READABLE
kb_to_human() {
    local kb=$1
    if [ "$kb" -ge $(( 1024 * 1024 * 1024 )) ]; then
        printf "%d.%dTB" $(( kb / 1024 / 1024 / 1024 )) $(( (kb / 1024 / 1024 % 1024) * 10 / 1024 ))
    elif [ "$kb" -ge $(( 1024 * 1024 )) ]; then
        printf "%d.%dGB" $(( kb / 1024 / 1024 )) $(( (kb % (1024 * 1024)) * 10 / 1024 / 1024 ))
    else
        printf "%dMB" $(( kb / 1024 ))
    fi
}

ram_used_fmt=$(kb_to_human "$ram_used_kb")
disk_used_fmt=$(kb_to_human "$disk_used_kb")

# NETWORK
iface=$(ip route get 1.1.1.1 2>/dev/null | awk '/dev/ {for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -1)
rx_now=$(cat /sys/class/net/${iface}/statistics/rx_bytes 2>/dev/null || echo 0)
tx_now=$(cat /sys/class/net/${iface}/statistics/tx_bytes 2>/dev/null || echo 0)
ts_now=$(date +%s%3N)
rx_prev=$(cat /tmp/waybar_rx 2>/dev/null || echo "$rx_now")
tx_prev=$(cat /tmp/waybar_tx 2>/dev/null || echo "$tx_now")
ts_prev=$(cat /tmp/waybar_ts 2>/dev/null || echo "$ts_now")
echo "$rx_now" > /tmp/waybar_rx
echo "$tx_now" > /tmp/waybar_tx
echo "$ts_now" > /tmp/waybar_ts
elapsed_ms=$(( ts_now - ts_prev ))
if [ "$elapsed_ms" -gt 100 ]; then
    rx_mbps="$(( (rx_now - rx_prev) * 8 / 1000000 * 1000 / elapsed_ms )).0"
    tx_mbps="$(( (tx_now - tx_prev) * 8 / 1000000 * 1000 / elapsed_ms )).0"
    total_mbps=$(( (rx_now - rx_prev + tx_now - tx_prev) * 8 / 1000000 * 1000 / elapsed_ms ))
else
    rx_mbps="0.0"; tx_mbps="0.0"; total_mbps=0
fi

# COLORS
color() {
    local pct=$1
    if   [ "$pct" -lt 40 ]; then echo "#4a9e4a"
    elif [ "$pct" -lt 60 ]; then echo "#a89a3e"
    elif [ "$pct" -lt 80 ]; then echo "#b86820"
    else                          echo "#cc3333"
    fi
}
cpu_color=$(color "$cpu_pct")
ram_color=$(color "$ram_pct")
disk_color=$(color "$disk_pct")
if   [ "$total_mbps" -lt 10  ]; then net_color="#4a9e4a"
elif [ "$total_mbps" -lt 50  ]; then net_color="#a89a3e"
elif [ "$total_mbps" -lt 200 ]; then net_color="#b86820"
else                                  net_color="#cc3333"
fi

# OUTPUT
printf "<span color='$cpu_color'>%-4s</span>  <span color='$ram_color'>%-9s</span>  <span color='$disk_color'>%-8s</span>  <span color='$net_color'>↑ %-7s ↓ %-7s</span>\n" \
    "${cpu_pct}%" "$ram_used_fmt" "$disk_used_fmt" "$tx_mbps" "$rx_mbps"
