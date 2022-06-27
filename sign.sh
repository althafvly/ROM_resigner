# Resign to AOSP keys
echo "Resigning to AOSP keys"
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi
dir=$(echo $1)
security=$(echo "$(pwd)/AOSP_security")

for part in system_a system_ext_a vendor_a product_a odm_a system system_ext vendor product odm; do
    if [ -d $dir/$part ]; then
        if [ $part == system_a ] || [ $part == system ] && [ -d $dir/$part/system ]; then
            if [ -d $dir/$part/system/etc/selinux ] && [ -f $dir/$part/system/etc/selinux/*_mac_permissions.xml ]; then
                python resign.py $dir/$part/system $security selinux
            fi
        else
            if [ -d $dir/$part/etc/selinux ] && [ -f $dir/$part/etc/selinux/*_mac_permissions.xml ]; then
                python resign.py $dir/$part $security selinux
            fi
            if [ -d $dir/$part/etc/security ] && [ -f $dir/$part/etc/security/mac_permissions.xml ]; then
                python resign.py $dir/$part $security security
            fi
        fi
    fi
done
