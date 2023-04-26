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

# Loop through the specified directories to perform resigning
for part in system_a system_ext_a vendor_a product_a odm_a system system_ext vendor product odm; do
    if [ -d "$dir/$part" ]; then
        if [[ $part == system_a || $part == system ]] && [ -d "$dir/$part/system" ]; then
            # For system_a or system, check if system directory exists and contains selinux xml file
            if [ -d "$dir/$part/system/etc/selinux" ] && [ -f "$dir/$part/system/etc/selinux/*_mac_permissions.xml" ]; then
                python resign.py "$dir/$part/system" "$security" selinux
            fi
        else
            # For other directories, check if etc/selinux and etc/security directories exist and contain respective xml files
            if [ -d "$dir/$part/etc/selinux" ] && [ -f "$dir/$part/etc/selinux/*_mac_permissions.xml" ]; then
                python resign.py "$dir/$part" "$security" selinux
            fi
            if [ -d "$dir/$part/etc/security" ] && [ -f "$dir/$part/etc/security/mac_permissions.xml" ]; then
                python resign.py "$dir/$part" "$security" security
            fi
        fi
    fi
done
