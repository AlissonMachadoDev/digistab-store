#!/bin/bash
set -e  # Exit on error

echo "Starting cleanup process..."

# Stop the application if it's running
if [ -f /opt/digistab_store/digistab_store/bin/digistab_store ]; then
    echo "Stopping existing application..."
    /opt/digistab_store/digistab_store/bin/digistab_store stop || true
fi

# Make sure the directory exists
echo "Ensuring directory exists..."
mkdir -p /opt/digistab_store

# Clean up thoroughly
echo "Cleaning up old deployment..."
rm -rf /opt/digistab_store/*
rm -rf /opt/digistab_store/.[!.]*  # Remove hidden files too

# Reset permissions
echo "Setting up permissions..."
chown -R ubuntu:ubuntu /opt/digistab_store
chmod -R 755 /opt/digistab_store

echo "Before install script completed successfully"
exit 0