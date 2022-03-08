# Resign to AOSP keys
echo "Resigning to AOSP keys"
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi
dir=$(echo $1)
security=$(echo "$(pwd)/AOSP_security")

for part in system_a system_ext_a vendor_a product_a odm_a system system_ext vendor product odm ; do
    if [ -d $dir/$part ]; then
        if [ $part == system_a ] || [ $part == system ]; then
            if [ ! -f $dir/$part/system/etc/selinux/*_mac_permissions.xml ]; then
                echo "can't find *_mac_permissions.xml in $part"
                exit 0
            fi
            python resign.py $dir/$part/system $security>log.txt
        else
            if [ ! -f $dir/$part/etc/selinux/*_mac_permissions.xml ]; then
                echo "can't find *_mac_permissions.xml in $part"
                exit 0
            fi
            python resign.py $dir/$part $security>>log.txt
        fi
    fi
done
