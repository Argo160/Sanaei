#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    clear
    echo "You should run this script with root!"
    echo "Use sudo -i to change user to root"
    exit 1
fi

# Declare Paths & Settings.
SYS_PATH="/etc/sysctl.conf"
PROF_PATH="/etc/profile"
SSH_PORT=""
SSH_PATH="/etc/ssh/sshd_config"
SWAP_PATH="/swapfile"
SWAP_SIZE=2G

function main_menu {
    clear
    cd
        apt-get update && apt-get upgrade -y
        echo
        echo -e "\e[32mSystem Updated and Upgraded.\e[0m"  # Green color for UP
        echo
        sleep 0.5
        echo -e "\033[33mInstalling Curl...\033[0m" #yellow Color
        apt-get install -y curl
        if command -v curl > /dev/null; then
            echo
            echo -e "\e[32mCurl Installed.\e[0m"  # Green color for UP
            echo
            sleep 0.5
        else
            echo
            echo -e "\033[31mCurl is not installed.\033[0m"  # Print in red
            echo
            sleep 0.5
        fi
        
        echo
        echo -e "\033[33mInstalling socat...\033[0m" #yellow Color
        echo
        sleep 0.5
        apt-get install -y socat
        if command -v socat > /dev/null; then
            echo
            echo -e "\e[32msocat Installed.\e[0m"  # Green color for UP
            echo
            sleep 0.5
        else
            echo
            echo -e "\033[31msocat is not installed.\033[0m"  # Print in red
            echo
            sleep 0.5
        fi

        echo
        ## Make Swap
        sudo fallocate -l $SWAP_SIZE $SWAP_PATH  ## Allocate size
        sudo chmod 600 $SWAP_PATH                ## Set proper permission
        sudo mkswap $SWAP_PATH                   ## Setup swap         
        sudo swapon $SWAP_PATH                   ## Enable swap
        echo "$SWAP_PATH   none    swap    sw    0   0" >> /etc/fstab ## Add to fstab
        echo 
        green_msg 'SWAP Created Successfully.'
        echo -e "\e[32mdSWAP Created Successfully.\n\e[0m"  # Green color for UP
        echo
        sleep 0.5

        # SYSCTL Optimization
        ## Make a backup of the original sysctl.conf file
        cp $SYS_PATH /etc/sysctl.conf.bak

        echo
        echo -e "\033[33mDefault sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak\033[0m" #yellow Color
        echo 
        sleep 1

        echo 
        echo -e "\033[33mOptimizing the Network...\033[0m" #yellow Color
        echo 
        sleep 0.5

        sed -i -e '/fs.file-max/d' \
            -e '/net.core.default_qdisc/d' \
            -e '/net.core.netdev_max_backlog/d' \
            -e '/net.core.optmem_max/d' \
            -e '/net.core.somaxconn/d' \
            -e '/net.core.rmem_max/d' \
            -e '/net.core.wmem_max/d' \
            -e '/net.core.rmem_default/d' \
            -e '/net.core.wmem_default/d' \
            -e '/net.ipv4.tcp_rmem/d' \
            -e '/net.ipv4.tcp_wmem/d' \
            -e '/net.ipv4.tcp_congestion_control/d' \
            -e '/net.ipv4.tcp_fastopen/d' \
            -e '/net.ipv4.tcp_fin_timeout/d' \
            -e '/net.ipv4.tcp_keepalive_time/d' \
            -e '/net.ipv4.tcp_keepalive_probes/d' \
            -e '/net.ipv4.tcp_keepalive_intvl/d' \
            -e '/net.ipv4.tcp_max_orphans/d' \
            -e '/net.ipv4.tcp_max_syn_backlog/d' \
            -e '/net.ipv4.tcp_max_tw_buckets/d' \
            -e '/net.ipv4.tcp_mem/d' \
            -e '/net.ipv4.tcp_mtu_probing/d' \
            -e '/net.ipv4.tcp_notsent_lowat/d' \
            -e '/net.ipv4.tcp_retries2/d' \
            -e '/net.ipv4.tcp_sack/d' \
            -e '/net.ipv4.tcp_dsack/d' \
            -e '/net.ipv4.tcp_slow_start_after_idle/d' \
            -e '/net.ipv4.tcp_window_scaling/d' \
            -e '/net.ipv4.tcp_adv_win_scale/d' \
            -e '/net.ipv4.tcp_ecn/d' \
            -e '/net.ipv4.tcp_ecn_fallback/d' \
            -e '/net.ipv4.tcp_syncookies/d' \
            -e '/net.ipv4.udp_mem/d' \
            -e '/net.ipv6.conf.all.disable_ipv6/d' \
            -e '/net.ipv6.conf.default.disable_ipv6/d' \
            -e '/net.ipv6.conf.lo.disable_ipv6/d' \
            -e '/net.unix.max_dgram_qlen/d' \
            -e '/vm.min_free_kbytes/d' \
            -e '/vm.swappiness/d' \
            -e '/vm.vfs_cache_pressure/d' \
            -e '/net.ipv4.conf.default.rp_filter/d' \
            -e '/net.ipv4.conf.all.rp_filter/d' \
            -e '/net.ipv4.conf.all.accept_source_route/d' \
            -e '/net.ipv4.conf.default.accept_source_route/d' \
            -e '/net.ipv4.neigh.default.gc_thresh1/d' \
            -e '/net.ipv4.neigh.default.gc_thresh2/d' \
            -e '/net.ipv4.neigh.default.gc_thresh3/d' \
            -e '/net.ipv4.neigh.default.gc_stale_time/d' \
            -e '/net.ipv4.conf.default.arp_announce/d' \
            -e '/net.ipv4.conf.lo.arp_announce/d' \
            -e '/net.ipv4.conf.all.arp_announce/d' \
            -e '/kernel.panic/d' \
            -e '/vm.dirty_ratio/d' \
            -e '/^#/d' \
            -e '/^$/d' \
            "$SYS_PATH"

        ## Add new parameteres. Read More: https://github.com/hawshemi/Linux-Optimizer/blob/main/files/sysctl.conf

cat <<EOF >> "$SYS_PATH"


################################################################
################################################################


# /etc/sysctl.conf
# These parameters in this file will be added/updated to the sysctl.conf file.
# Read More: https://github.com/hawshemi/Linux-Optimizer/blob/main/files/sysctl.conf


## File system settings
## ----------------------------------------------------------------

# Set the maximum number of open file descriptors
fs.file-max = 67108864


## Network core settings
## ----------------------------------------------------------------

# Specify default queuing discipline for network devices
net.core.default_qdisc = fq_codel

# Configure maximum network device backlog
net.core.netdev_max_backlog = 32768

# Set maximum socket receive buffer
net.core.optmem_max = 262144

# Define maximum backlog of pending connections
net.core.somaxconn = 65536

# Configure maximum TCP receive buffer size
net.core.rmem_max = 33554432

# Set default TCP receive buffer size
net.core.rmem_default = 1048576

# Configure maximum TCP send buffer size
net.core.wmem_max = 33554432

# Set default TCP send buffer size
net.core.wmem_default = 1048576


## TCP settings
## ----------------------------------------------------------------

# Define socket receive buffer sizes
net.ipv4.tcp_rmem = 16384 1048576 33554432

# Specify socket send buffer sizes
net.ipv4.tcp_wmem = 16384 1048576 33554432

# Set TCP congestion control algorithm to BBR
net.ipv4.tcp_congestion_control = bbr

# Configure TCP FIN timeout period
net.ipv4.tcp_fin_timeout = 25

# Set keepalive time (seconds)
net.ipv4.tcp_keepalive_time = 1200

# Configure keepalive probes count and interval
net.ipv4.tcp_keepalive_probes = 7
net.ipv4.tcp_keepalive_intvl = 30

# Define maximum orphaned TCP sockets
net.ipv4.tcp_max_orphans = 819200

# Set maximum TCP SYN backlog
net.ipv4.tcp_max_syn_backlog = 20480

# Configure maximum TCP Time Wait buckets
net.ipv4.tcp_max_tw_buckets = 1440000

# Define TCP memory limits
net.ipv4.tcp_mem = 65536 1048576 33554432

# Enable TCP MTU probing
net.ipv4.tcp_mtu_probing = 1

# Define minimum amount of data in the send buffer before TCP starts sending
net.ipv4.tcp_notsent_lowat = 32768

# Specify retries for TCP socket to establish connection
net.ipv4.tcp_retries2 = 8

# Enable TCP SACK and DSACK
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1

# Disable TCP slow start after idle
net.ipv4.tcp_slow_start_after_idle = 0

# Enable TCP window scaling
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_adv_win_scale = -2

# Enable TCP ECN
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_ecn_fallback = 1

# Enable the use of TCP SYN cookies to help protect against SYN flood attacks
net.ipv4.tcp_syncookies = 1


## UDP settings
## ----------------------------------------------------------------

# Define UDP memory limits
net.ipv4.udp_mem = 65536 1048576 33554432


## IPv6 settings
## ----------------------------------------------------------------

# Enable IPv6
net.ipv6.conf.all.disable_ipv6 = 0

# Enable IPv6 by default
net.ipv6.conf.default.disable_ipv6 = 0

# Enable IPv6 on the loopback interface (lo)
net.ipv6.conf.lo.disable_ipv6 = 0


## UNIX domain sockets
## ----------------------------------------------------------------

# Set maximum queue length of UNIX domain sockets
net.unix.max_dgram_qlen = 256


## Virtual memory (VM) settings
## ----------------------------------------------------------------

# Specify minimum free Kbytes at which VM pressure happens
vm.min_free_kbytes = 65536

# Define how aggressively swap memory pages are used
vm.swappiness = 10

# Set the tendency of the kernel to reclaim memory used for caching of directory and inode objects
vm.vfs_cache_pressure = 250


## Network Configuration
## ----------------------------------------------------------------

# Configure reverse path filtering
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2

# Disable source route acceptance
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Neighbor table settings
net.ipv4.neigh.default.gc_thresh1 = 512
net.ipv4.neigh.default.gc_thresh2 = 2048
net.ipv4.neigh.default.gc_thresh3 = 16384
net.ipv4.neigh.default.gc_stale_time = 60

# ARP settings
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2

# Kernel panic timeout
kernel.panic = 1

# Set dirty page ratio for virtual memory
vm.dirty_ratio = 20


################################################################
################################################################


EOF

        sudo sysctl -p
    
        echo 
        echo -e "\e[32mNetwork is Optimized.\e[0m"  # Green color for UP
        echo 
        sleep 0.5

   
        read -p "Reboot now? (Recommended) (y/n): " reb
        echo 
        while true; do
            echo 
            if [[ "$reb" == 'y' || "$reb" == 'Y' ]]; then
                sleep 0.5
                reboot
                exit 0
            fi
            if [[ "$reb" == 'n' || "$reb" == 'N' ]]; then
                break
            fi
        done    
}
main_menu
