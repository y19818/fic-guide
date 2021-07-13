#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


if [ ! -d $LOTUS_WORKER_PATH ]; then
  mkdir -p $LOTUS_WORKER_PATH
fi
# huge_argu
hugepage_num=`${EXE_LOTUS_WORKER} run -h|grep 'hugepage'|wc -l`
if (($hugepage_num == 1)); then
  huge_total=`cat /proc/meminfo | grep HugePages_Total | awk -F ":" '{print $2}' | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*\$//g'`
  huge_size=`cat /proc/meminfo | grep Hugepagesize | awk -F ":" '{print $2}' | awk -F " " '{print $1}'`
  if [ $huge_total -gt 0 ]; then
    huge_num_gb=`expr $huge_total \* $huge_size / 1024 / 1024` 
    if [ $huge_num_gb -ne 0 ]; then
      huge_argu="--hugepage=$huge_num_gb"
    fi
    # tips
    echo -e "\033[34m HugePages is opened. $huge_num_gb \033[0m"
  else
    # tips
    echo -e "\033[31m HugePages is closed. $huge_num_gb \033[0m"
  fi
  echo " "
fi

if [ -z $ENV_SECTOR_SIZE ]; then
  echo -e "\033[31m TIPS: LOTUS_NETWORK is empty. \033[0m"
  pause
elif [[ "$ENV_SECTOR_SIZE" == "2KiB" ]]; then
  diskSectorcache_gb=1
elif [[ "$ENV_SECTOR_SIZE" == "512MiB" ]]; then
  diskSectorcache_gb=3
elif [[ "$ENV_SECTOR_SIZE" == "4GiB" ]]; then #112
  diskSectorcache_gb=45
elif [[ "$ENV_SECTOR_SIZE" == "8GiB" ]]; then #82
  diskSectorcache_gb=66
elif [[ "$ENV_SECTOR_SIZE" == "16GiB" ]]; then #82
  diskSectorcache_gb=132
elif [[ "$ENV_SECTOR_SIZE" == "32GiB" ]]; then #142
  diskSectorcache_gb=455
elif [[ "$ENV_SECTOR_SIZE" == "64GiB" ]]; then #142
  diskSectorcache_gb=910
fi
# max_argu
if [ ! -z $1 ]; then 
  max_argu=$1
else
  diskAvailable_mb=`df -m $LOTUS_WORKER_PATH |awk 'NR==2{print $4}'`  ## MiB
  diskAvailable_gb=`expr $diskAvailable_mb / 1024`  ## GiB
  diskAvailable_num=`expr $diskAvailable_gb / $diskSectorcache_gb`  ## diskAvailable_num
  processor=$(grep 'processor' /proc/cpuinfo |sort |uniq |wc -l)  ## processor
  if [ "$processor" -lt "$diskAvailable_num" ]; then 
    task_num=$processor
  else
    task_num=$diskAvailable_num
  fi
  
  max_num=`${EXE_LOTUS_WORKER} run -h|grep precommit1max|wc -l`
  if (($max_num == 1)); then
    max_argu="--precommit1max=$task_num --precommit2max=1 --commitmax=1"
  fi
fi

# debug
echo huge_argu=$huge_argu FFI_REMOTE_COMMIT2=$FFI_REMOTE_COMMIT2 FFI_REMOTE_COMMIT2_BASE_URL=$FFI_REMOTE_COMMIT2_BASE_URL
echo " "

if [ -z $1 ]; then ## run
  check_port $ENV_LOTUS_WORKER_PORT
  if [ $port -le 0 ]; then
    check_pid_exist "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT"
    if [ $pid -le 0 ]; then
      
      # gpu_num
      check_gpu_num
      if [ $gpu_num -eq 0 ]; then
        # tips
        echo -e "\033[31m GPU not detected. $num \033[0m"

        export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=0
        export FIL_PROOFS_USE_GPU_TREE_BUILDER=0
        nogpu="-nogpu"
      fi

      # log
      export marklog="worker-$ENV_SECTOR_SIZE$nogpu-all.log"
      # backup log
      if [ -f "$marklog" ]; then 
        mv $marklog $marklog.$localip.$marktime.log
      fi
      
      # tips
      echo -e "\033[34m nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT $max_argu $huge_argu > $marklog 2>&1 & \033[0m"

      nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT $max_argu $huge_argu > $marklog 2>&1 &
    else
      # tips
      echo -e "\033[31m ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT is exist. \033[0m"
    fi
  else
    # tips
    echo -e "\033[31m $ENV_LOTUS_WORKER_PORT is used. \033[0m"
  fi
  echo " "
elif [ "$1" == "kill" ]; then ## stop
  check_pid_exist "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT"
  if [ $pid -eq 1 ]; then

    # tips
    echo -e "\033[34m pid=`ps aux |grep "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT" |grep -v grep |awk '{print \$2}'`;kill -9 $pid; \033[0m"

    pid=`ps aux |grep "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT" |grep -v grep |awk '{print \$2}'`;kill -9 $pid;

  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT is not exist. \033[0m"
  fi
  echo " "
fi
echo " "
