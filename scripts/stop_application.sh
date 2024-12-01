#!/bin/bash
# Gracefully stop the application
if [ -f /opt/digistab_store/digistab_store/bin/digistab_store ]; then
    /opt/digistab_store/digistab_store/bin/digistab_store stop
fi