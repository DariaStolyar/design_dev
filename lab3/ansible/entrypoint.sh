#!/bin/sh
set -e

until ansible all -i /work/ansible/inventory.ini -m ping >/dev/null 2>&1; do
    sleep 2
done

ansible-playbook -i /work/ansible/inventory.ini /work/ansible/site.yml
tail -f /dev/null
