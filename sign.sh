#!/bin/bash

# Resign to AOSP keys
echo "Resigning to AOSP keys"

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi

dir="$1"
security="$(pwd)/AOSP_security"

# List of partitions to process
partitions=(
    system_a system_ext_a vendor_a product_a odm_a
    system system_ext vendor product odm
)

# Loop through system partitions
for part in "${partitions[@]}"; do
    if [ -d "$dir/$part" ]; then
        echo "Signing apks/jar in $part partition"
        if [[ "$part" == "system_a" || "$part" == "system" ]] && [ -d "$dir/$part/system" ]; then
            python resign.py "$dir/$part/system" "$security"
        else
            python resign.py "$dir/$part" "$security"
        fi
    fi
done