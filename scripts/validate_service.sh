#!/bin/bash
# Is this running?
systemctl restart digistab_store.service

sleep 10

systemctl is-active digistab_store.service

# Is this answering?
timeout 30 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/localhost/4000; do sleep 1; done'


exit 0