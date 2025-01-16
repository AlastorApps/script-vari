#!/bin/bash

# Funzione per ottenere le interfacce di rete disponibili
function get_network_interfaces() {
    ip -o -f inet addr show | awk '{print $2}' | sort -u
}

# Funzione per effettuare la scansione degli host attivi
function scan_network() {
    local interface=$1
    local subnet=$(ip -o -f inet addr show $interface | awk '{print $4}' | cut -d'/' -f1)
    local base_ip=$(echo $subnet | cut -d'.' -f1-3)

    echo "Scanning the network: ${base_ip}.0/24"
    
    for i in {1..254}; do
        ping -c 1 -W 1 "${base_ip}.${i}" &> /dev/null
        if [ $? -eq 0 ]; then
            echo "${base_ip}.${i} is UP"
        fi
    done
}

# Main script
echo "Seleziona un'interfaccia di rete per la scansione:"
interfaces=( $(get_network_interfaces) )

if [ ${#interfaces[@]} -eq 0 ]; then
    echo "Nessuna interfaccia di rete trovata."
    exit 1
fi

select selected_interface in "${interfaces[@]}"; do
    if [[ -n "$selected_interface" ]]; then
        echo "Hai selezionato: $selected_interface"
        break
    else
        echo "Scelta non valida. Riprova."
    fi
done

# Esegui la scansione della rete
scan_network "$selected_interface"
