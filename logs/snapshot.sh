#!/bin/bash
 
source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


# car
export backcar="snapshot_latest.car"

if [ -z $1 ]; then ## tips
  echo -e "\033[34m nohup 
  bash snapshot.sh down 
  bash snapshot.sh export 
  bash snapshot.sh import 
  \033[0m"
  echo " "

elif [ "$1" == "down" ]; then ## down
  echo -e "\033[31m nohup wget -c $SNAPSHOT_LATEST -O $backcar >> latest-down.log 2>&1 & \033[0m"
  
  # backup car
  if [ -f "$backcar" ]; then 
    mv $backcar $backcar.$localip.$marktime.car
  fi
  
  nohup wget -c $SNAPSHOT_LATEST -O $backcar >> wget.log 2>&1 &
  echo " "
elif [ "$1" == "export" ]; then ## export
  echo -e "\033[31m nohup lotus chain export --tipset @$( lotus chain list --count 50 --format "<height>" | head -n1 ) --recent-stateroots 900 --skip-old-msgs $backcar >> latest-export.log 2>&1 & \033[0m"
  
  # backup car
  if [ -f "$backcar" ]; then 
    mv $backcar $backcar.$localip.$marktime.car
  fi
  
  nohup lotus chain export --tipset @$( lotus chain list --count 50 --format "<height>" | head -n1 ) --recent-stateroots 900 --skip-old-msgs $backcar >> export.log 2>&1 &
  echo " "
elif [ "$1" == "import" ]; then ## import
  echo -e "\033[31m nohup lotus daemon --import-snapshot $backcar --halt-after-import >> latest-import.log 2>&1 & \033[0m"
  
  nohup lotus daemon --import-snapshot $backcar --halt-after-import >> import.log 2>&1 &
  echo " "
fi
