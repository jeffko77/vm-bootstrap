#!/usr/bin/env bash

# Detect if running in a cloud VM (AWS, GCP, Azure)

is_cloud_vm() {
    # Check DMI product UUID
    if [ -f /sys/class/dmi/id/product_uuid ]; then
        UUID=$(sudo cat /sys/class/dmi/id/product_uuid 2>/dev/null)
        case "$UUID" in
            *EC2*|*ec2*) 
                echo "AWS EC2 detected"
                return 0 
                ;;
            *GCE*|*gce*) 
                echo "Google Cloud detected"
                return 0 
                ;;
            *Azure*|*azure*) 
                echo "Azure detected"
                return 0 
                ;;
        esac
    fi
    
    # Check for AWS metadata service
    if curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/ &>/dev/null; then
        echo "AWS EC2 detected (via metadata service)"
        return 0
    fi
    
    # Check for GCP metadata service
    if curl -s --connect-timeout 1 -H "Metadata-Flavor: Google" http://metadata.google.internal &>/dev/null; then
        echo "Google Cloud detected (via metadata service)"
        return 0
    fi
    
    # Check for Azure metadata service
    if curl -s --connect-timeout 1 -H "Metadata: true" http://169.254.169.254/metadata/instance?api-version=2021-02-01 &>/dev/null; then
        echo "Azure detected (via metadata service)"
        return 0
    fi
    
    return 1
}

if is_cloud_vm; then
    exit 0
else
    echo "Not running in a cloud VM"
    exit 1
fi
