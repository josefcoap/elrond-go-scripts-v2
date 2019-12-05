#!/bin/bash
mkdir -p ../backup_script_config
cp config/identity ../backup_script_config/
cp config/target_ips ../backup_script_config/
cp config/variables.cfg ../backup_script_config/
git reset --hard HEAD
git pull
cp ../backup_script_config/* config/
