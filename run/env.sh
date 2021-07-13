#!/bin/bash

unset all_proxy http_proxy https_proxy

# ENV_LOG_DIR  *.sh
export ENV_LOG_DIR=$(cd `dirname $0`; pwd)
if [ ! -d $ENV_LOG_DIR ]; then
  mkdir -p $ENV_LOG_DIR
fi

# source shell
source $ENV_LOG_DIR/common.sh

unset ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NETWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT  ENV_LOG_LEVEL
# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NETWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT  ENV_LOG_LEVEL
if [ -f $ENV_LOG_DIR/.env_lotus ]; then
  source $ENV_LOG_DIR/.env_lotus
fi

# ENV_LOTUS_BIN  lotus lotus-miner lotus-worker  #export ENV_LOTUS_BIN=/usr/local/bin
if [ -z $ENV_LOTUS_BIN ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_BIN=/usr/local/bin   (default) \033[0m"
  
  while [ -z $lotus_bin ]
  do
    #lotus_bin
    while [ -z $lotus_bin ]
    do
      read -e -p '  please input lotus_bin:' lotus_bin
      if [ -z $lotus_bin ]; then
        lotus_bin=/usr/local/bin
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_BIN=$lotus_bin" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_BIN=$lotus_bin \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_ROOT  .lotus .lotusminer .lotusworker  #export ENV_LOTUS_ROOT=/mnt
if [ -z $ENV_LOTUS_ROOT ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_ROOT=/mnt   (default) \033[0m"
  
  while [ -z $lotus_root ]
  do
    #lotus_root
    while [ -z $lotus_root ]
    do
      read -e -p '  please input lotus_root:' lotus_root
      if [ -z $lotus_root ]; then
        lotus_root=/mnt
        #lotus_root=$(cd `dirname $0`; pwd)
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_ROOT=$lotus_root" >> $ENV_LOG_DIR/.env_lotus
    export ENV_LOTUS_ROOT=$lotus_root
    # tips
    echo -e "\033[34m ENV_LOTUS_ROOT=$lotus_root \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_ROOT_CUSTOM  #export ENV_LOTUS_ROOT_CUSTOM=/mnt
if [ -z $ENV_LOTUS_ROOT_CUSTOM ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_ROOT_CUSTOM=0   (default) \033[0m"
  
  while [ -z $lotus_root_custom ]
  do
    #lotus_root_custom
    while [ -z $lotus_root_custom ]
    do
      read -e -p '  please input lotus_root_custom:' lotus_root_custom
      if [ -z $lotus_root_custom ]; then
        lotus_root_custom=0
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_ROOT_CUSTOM=$lotus_root_custom" >> $ENV_LOG_DIR/.env_lotus
    export ENV_LOTUS_ROOT_CUSTOM=$lotus_root_custom
    # tips
    echo -e "\033[34m ENV_LOTUS_ROOT_CUSTOM=$lotus_root_custom \033[0m"
  done
  echo " "
fi
if [ "$ENV_LOTUS_ROOT_CUSTOM" == "1" ]; then
  # ENV_LOTUS_PATH  #export ENV_LOTUS_PATH=/mnt/lotus 
  if [ -z $ENV_LOTUS_PATH ]; then
    # tips
    echo -e "\033[34m ENV_LOTUS_PATH=${ENV_LOTUS_ROOT}/lotus   (default) \033[0m"
    
    while [ -z $lotus_path ]
    do
      #lotus_path
      while [ -z $lotus_path ]
      do
        read -e -p '  please input lotus_path:' lotus_path
        if [ -z $lotus_path ]; then
          lotus_path=${ENV_LOTUS_ROOT}/lotus
        fi
      done
      #echo ' '
      echo "export ENV_LOTUS_PATH=$lotus_path" >> $ENV_LOG_DIR/.env_lotus
      # tips
      echo -e "\033[34m ENV_LOTUS_PATH=$lotus_path \033[0m"
    done
    echo " "
  fi
  # LOTUS_MINER_PATH  #export LOTUS_MINER_PATH=/mnt/miner 
  if [ -z $ENV_LOTUS_MINER_PATH ]; then
    # tips
    echo -e "\033[34m ENV_LOTUS_MINER_PATH=${ENV_LOTUS_ROOT}/miner   (default) \033[0m"
    
    while [ -z $lotus_miner_path ]
    do
      #lotus_miner_path
      while [ -z $lotus_miner_path ]
      do
        read -e -p '  please input lotus_miner_path:' lotus_miner_path
        if [ -z $lotus_miner_path ]; then
          lotus_miner_path=${ENV_LOTUS_ROOT}/miner
        fi
      done
      #echo ' '
      echo "export ENV_LOTUS_MINER_PATH=$lotus_miner_path" >> $ENV_LOG_DIR/.env_lotus
      # tips
      echo -e "\033[34m ENV_LOTUS_MINER_PATH=$lotus_miner_path \033[0m"
    done
    echo " "
  fi
  # LOTUS_WORKER_PATH  #export LOTUS_WORKER_PATH=/mnt/worker 
  if [ -z $ENV_LOTUS_WORKER_PATH ]; then
    # tips
    echo -e "\033[34m ENV_LOTUS_WORKER_PATH=${ENV_LOTUS_ROOT}/worker   (default) \033[0m"
    
    while [ -z $lotus_worker_path ]
    do
      #lotus_worker_path
      while [ -z $lotus_worker_path ]
      do
        read -e -p '  please input lotus_worker_path:' lotus_worker_path
        if [ -z $lotus_worker_path ]; then
          lotus_worker_path=${ENV_LOTUS_ROOT}/worker
        fi
      done
      #echo ' '
      echo "export ENV_LOTUS_WORKER_PATH=$lotus_worker_path" >> $ENV_LOG_DIR/.env_lotus
      # tips
      echo -e "\033[34m ENV_LOTUS_WORKER_PATH=$lotus_worker_path \033[0m"
    done
    echo " "
  fi
  # ENV_LOTUS_PROOFS_PATH  #export LOTUS_PROOFS_PATH=/mnt/proofs 
  if [ -z $ENV_LOTUS_PROOFS_PATH ]; then
    # tips
    echo -e "\033[34m ENV_LOTUS_PROOFS_PATH=${ENV_LOTUS_ROOT}/proofs   (default) \033[0m"
    
    while [ -z $lotus_proofs_path ]
    do
      #lotus_proofs_path
      while [ -z $lotus_proofs_path ]
      do
        read -e -p '  please input lotus_proofs_path:' lotus_proofs_path
        if [ -z $lotus_proofs_path ]; then
          lotus_proofs_path=${ENV_LOTUS_ROOT}/worker
        fi
      done
      #echo ' '
      echo "export ENV_LOTUS_PROOFS_PATH=$lotus_proofs_path" >> $ENV_LOG_DIR/.env_lotus
      # tips
      echo -e "\033[34m ENV_LOTUS_PROOFS_PATH=$lotus_proofs_path \033[0m"
    done
    echo " "
  fi
else
  # ENV_LOTUS_PATH  #export ENV_LOTUS_PATH=/mnt/lotus 
  if [ -z $ENV_LOTUS_PATH ]; then
    export LOTUS_PATH=${ENV_LOTUS_ROOT}/lotus
    echo "export ENV_LOTUS_PATH=${ENV_LOTUS_ROOT}/lotus" >> $ENV_LOG_DIR/.env_lotus
  fi
  # LOTUS_MINER_PATH  #export LOTUS_MINER_PATH=/mnt/miner 
  if [ -z $ENV_LOTUS_MINER_PATH ]; then
    export LOTUS_MINER_PATH=${ENV_LOTUS_ROOT}/miner
    echo "export ENV_LOTUS_MINER_PATH=${ENV_LOTUS_ROOT}/miner" >> $ENV_LOG_DIR/.env_lotus
  fi
  # LOTUS_WORKER_PATH  #export LOTUS_WORKER_PATH=/mnt/worker 
  if [ -z $ENV_LOTUS_WORKER_PATH ]; then
    export LOTUS_WORKER_PATH=${ENV_LOTUS_ROOT}/worker
    echo "export ENV_LOTUS_WORKER_PATH=${ENV_LOTUS_ROOT}/worker" >> $ENV_LOG_DIR/.env_lotus
  fi
  # ENV_LOTUS_PROOFS_PATH  #export LOTUS_PROOFS_PATH=/mnt/proofs 
  if [ -z $ENV_LOTUS_PROOFS_PATH ]; then
    export ENV_LOTUS_PROOFS_PATH=${ENV_LOTUS_ROOT}/proofs
    echo "export ENV_LOTUS_PROOFS_PATH=${ENV_LOTUS_ROOT}/proofs" >> $ENV_LOG_DIR/.env_lotus
  fi
fi
# ENV_LOTUS_PREFIX   #export ENV_LOTUS_PREFIX=default fil- fic- star-
if [ -z $ENV_LOTUS_PREFIX ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_PREFIX=   (default) \033[0m"
  
  while [ -z $lotus_prefix ]
  do
    #lotus_prefix
    while [ -z $lotus_prefix ]
    do
      read -e -p '  please input lotus_prefix:' lotus_prefix
      if [ -z $lotus_prefix ]; then
        lotus_prefix=default
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_PREFIX=$lotus_prefix" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_PREFIX=$lotus_prefix \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_NETWORK  #export ENV_LOTUS_NETWORK=filecoin
if [ -z $ENV_LOTUS_NETWORK ]; then
  while [ -z $lotus_network ]
  do
    echo -e "\033[34m 
  Select lotus_network:      [`hostname`]  $localip
    
    1 - filecoin (default)
    2 - filecash
    3 - filestar
    \033[0m"
    read -e -p "  please input lotus_network:" lotus_network
    if [ -z $lotus_network ]; then
      lotus_network=1
    fi

    if [ -z $lotus_network ]; then
      unset lotus_network
    elif echo $lotus_network |grep -q '[^0-9]'; then
      unset lotus_network
    elif [ $lotus_network -le 0 ] && [ $lotus_network -ge 2 ]; then
      unset lotus_network
    else
      if [ $lotus_network -eq 1 ]; then  #filecoin (default)
        string_lotus_network=filecoin
      elif [ $lotus_network -eq 2 ]; then  #filecash
        string_lotus_network=filecash
      elif [ $lotus_network -eq 3 ]; then  #filestar
        string_lotus_network=filestar
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
    #echo ' '
    echo "export ENV_LOTUS_NETWORK=$string_lotus_network" >> $ENV_LOG_DIR/.env_lotus
    export ENV_LOTUS_NETWORK=$string_lotus_network
    # tips
    echo -e "\033[34m ENV_LOTUS_NETWORK=$string_lotus_network \033[0m"
  done
  echo " "
fi
# ENV_SECTOR_SIZE  #export ENV_SECTOR_SIZE=32GB
if [ -z $ENV_SECTOR_SIZE ]; then
  if [[ "$ENV_LOTUS_NETWORK" == "filecash" ]]; then
    export default_sector_size=4
  else
    export default_sector_size=5
  fi
  while [ -z $sector_size ]
  do
    echo -n -e "\033[34m 
  Select sector_size:      [`hostname`]  $localip
    
    0 - 2KiB
    1 - 512MiB
    2 - 4GiB
    3 - 8GiB
    4 - 16GiB \033[0m" 
    [[ $default_sector_size -eq 4 ]] && echo -n -e "\033[34m (default) \033[0m" 
    echo -n -e "\033[34m
    5 - 32GiB \033[0m" 
    [[ $default_sector_size -eq 5 ]] && echo -n -e "\033[34m (default) \033[0m"
    echo -e "\033[34m
    6 - 64GiB
    \033[0m"
    read -e -p "  please input sector_size:" sector_size
    if [ -z $sector_size ]; then
      sector_size=$default_sector_size
    fi
    
    if [ -z $sector_size ]; then
      unset sector_size
    elif echo $sector_size |grep -q '[^0-9]'; then
      unset sector_size
    elif [ $sector_size -le 0 ] && [ $sector_size -ge 2 ]; then
      unset sector_size
    else
      if [ $sector_size -eq 0 ]; then  #2KiB
        string_sector_size=2KiB
      elif [ $sector_size -eq 1 ]; then  #512M
        string_sector_size=512MiB
      elif [ $sector_size -eq 2 ]; then  #4G
        string_sector_size=4GiB
      elif [ $sector_size -eq 3 ]; then  #8G
        string_sector_size=8GiB
      elif [ $sector_size -eq 4 ]; then  #16G
        string_sector_size=16GiB
      elif [ $sector_size -eq 5 ]; then  #32G (default)
        string_sector_size=32GiB
      elif [ $sector_size -eq 6 ]; then  #64G
        string_sector_size=64GiB
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
    #echo ' '
    echo "export ENV_SECTOR_SIZE=$string_sector_size" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_SECTOR_SIZE=$string_sector_size \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_PORT  #export ENV_LOTUS_PORT=1234
if [ -z $ENV_LOTUS_PORT ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_PORT=1234   (default) \033[0m"
  
  while [ -z $lotus_port ]
  do
    #lotus_port
    while [ -z $lotus_port ]
    do
      read -e -p '  please input lotus_port:' lotus_port
      if [ -z $lotus_port ]; then
        lotus_port=1234
      elif [ "$lotus_port" -lt "0" ]; then
        unset lotus_port
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_PORT=$lotus_port" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_PORT=$lotus_port \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_MINER_PORT  #export ENV_LOTUS_MINER_PORT=2345
if [ -z $ENV_LOTUS_MINER_PORT ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_MINER_PORT=2345   (default) \033[0m"
  
  while [ -z $lotus_miner_port ]
  do
    #lotus_miner_port
    while [ -z $lotus_miner_port ]
    do
      read -e -p '  please input lotus_miner_port:' lotus_miner_port
      if [ -z $lotus_miner_port ]; then
        lotus_miner_port=2345
      elif [ "$lotus_miner_port" -lt "0" ]; then
        unset lotus_miner_port
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_MINER_PORT=$lotus_miner_port" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_MINER_PORT=$lotus_miner_port \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_WORKER_PORT  #export ENV_LOTUS_WORKER_PORT=3456
if [ -z $ENV_LOTUS_WORKER_PORT ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_WORKER_PORT=3456   (default) \033[0m"
  
  while [ -z $lotus_worker_port ]
  do
    #lotus_worker_port
    while [ -z $lotus_worker_port ]
    do
      read -e -p '  please input lotus_worker_port:' lotus_worker_port
      if [ -z $lotus_worker_port ]; then
        lotus_worker_port=3456
      elif [ "$lotus_worker_port" -lt "0" ]; then
        unset lotus_worker_port
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_WORKER_PORT=$lotus_worker_port" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_WORKER_PORT=$lotus_worker_port \033[0m"
  done
  echo " "
fi
# ENV_LOG_LEVEL  #export ENV_LOG_LEVEL=info #trace/debug/info/warn/error/fatal/off
if [ -z $ENV_LOG_LEVEL ]; then
  while [ -z $log_level ]
  do
    echo -e "\033[34m 
  Select log_level:      [`hostname`]  $localip
    
    0 - trace
    1 - debug
    2 - info
    3 - warn (default)
    4 - error
    5 - fatal
    6 - off
    \033[0m"
    read -e -p "  please input log_level:" log_level
    if [ -z $log_level ]; then
      log_level=3
    fi

    if [ -z $log_level ]; then
      unset log_level
    elif echo $log_level |grep -q '[^0-9]'; then
      unset log_level
    elif [ $log_level -le 0 ] && [ $log_level -ge 2 ]; then
      unset log_level
    else
      if [ $log_level -eq 0 ]; then    #trace
        string_log_level=trace
      elif [ $log_level -eq 1 ]; then  #debug
        string_log_level=debug
      elif [ $log_level -eq 2 ]; then  #info
        string_log_level=info
      elif [ $log_level -eq 3 ]; then  #warn (default)
        string_log_level=warn
      elif [ $log_level -eq 4 ]; then  #error
        string_log_level=error
      elif [ $log_level -eq 5 ]; then  #fatal
        string_log_level=fatal
      elif [ $log_level -eq 6 ]; then  #off
        string_log_level=off
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
    #echo ' '
    echo "export ENV_LOG_LEVEL=$string_log_level" >> $ENV_LOG_DIR/.env_lotus
    # tips
    echo -e "\033[34m ENV_LOG_LEVEL=$string_log_level \033[0m"
  done
  echo " "
fi

# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NETWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT 
source $ENV_LOG_DIR/.env_lotus
export PATH="${ENV_LOTUS_BIN}:/usr/local/go/bin:${HOME}/go/bin:${HOME}/.cargo/bin:${HOME}/.bin:${PATH}"

# exe
if [ "$ENV_LOTUS_PREFIX" == "default" ]; then
  unset ENV_LOTUS_PREFIX
fi
export EXE_LOTUS=${ENV_LOTUS_PREFIX}lotus
export EXE_LOTUS_MINER=${ENV_LOTUS_PREFIX}lotus-miner
export EXE_LOTUS_WORKER=${ENV_LOTUS_PREFIX}lotus-worker
export EXE_LOTUS_SHED=${ENV_LOTUS_PREFIX}lotus-shed
export EXE_LOTUS_SEED=${ENV_LOTUS_PREFIX}lotus-seed
export EXE_LOTUS_BENCH=${ENV_LOTUS_PREFIX}lotus-bench
export EXE_LOTUS_FOUNTAIN=${ENV_LOTUS_PREFIX}lotus-fountain

# rust log 
export RUST_BACKTRACE=full
export RUST_LOG=$ENV_LOG_LEVEL
# go log 
export GOLOG_LOG_LEVEL=$ENV_LOG_LEVEL

# custom gpu
#export BELLMAN_CUSTOM_GPU="GeForce RTX 2080 Ti:4352"
#export BELLMAN_CUSTOM_GPU="GeForce RTX 3080:8704"
#export BELLMAN_CUSTOM_GPU="GeForce RTX 3090:10496"

# gpu_num
check_gpu_num
if [ $gpu_num -eq 0 ]; then
  # nogpu
  export BELLMAN_NO_GPU=1
  export BELLMAN_CPU_UTILIZATION=0.99
  # tree_c
  unset FIL_PROOFS_USE_GPU_COLUMN_BUILDER
  # tree_r_last
  unset FIL_PROOFS_USE_GPU_TREE_BUILDER
else
  # gpu
  unset BELLMAN_NO_GPU
  unset BELLMAN_CPU_UTILIZATION
  # tree_c
  export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
  # tree_r_last
  export FIL_PROOFS_USE_GPU_TREE_BUILDER=1

  # tree_c
  #export FIL_PROOFS_MAX_GPU_COLUMN_BATCH_SIZE=400000
  #export FIL_PROOFS_COLUMN_WRITE_BATCH_SIZE=262144
  # tree_r_last
  #export FIL_PROOFS_MAX_GPU_TREE_BATCH_SIZE=700000
fi

# 2k
if [ "$ENV_SECTOR_SIZE" == "2KiB" ]; then
  unset BELLMAN_NO_GPU
  unset BELLMAN_CPU_UTILIZATION

  # speed or memory
  unset FIL_PROOFS_MAXIMIZE_CACHING

  # support small sector
  export FIL_USE_SMALL_SECTORS=true 
else
  # speed or memory
  export FIL_PROOFS_MAXIMIZE_CACHING=1

  # support small sector
  unset FIL_USE_SMALL_SECTORS
fi

# multi sdr
export FIL_PROOFS_USE_MULTICORE_SDR=1
check_cpu_sdr
export FIL_PROOFS_MULTICORE_SDR_PRODUCERS=$cpu_sdr #lscpu -e | grep ':0   '
#export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824
#export FIL_PROOFS_PARENT_CACHE_SIZE=1073741824

# lotus_env
export LOTUS_PATH=$ENV_LOTUS_ROOT/lotus
export LOTUS_MINER_PATH=$ENV_LOTUS_ROOT/miner
export LOTUS_WORKER_PATH=$ENV_LOTUS_ROOT/worker
export LOTUS_BENCH_PATH=$ENV_LOTUS_ROOT/bench
export LOTUS_MINER_STORE_PATH=$ENV_LOTUS_ROOT/miner_store
export TMPDIR=$ENV_LOTUS_ROOT/tmp
export CIRCLE_ARTIFACTS=$TMPDIR
export FIL_PROOFS_PARENT_CACHE=$ENV_LOTUS_ROOT/proofs_parent_cache
export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_ROOT/proofs

if [ ! -z $ENV_LOTUS_MINER_PATH ]; then 
  export LOTUS_PATH=$ENV_LOTUS_PATH
fi
if [ ! -z $ENV_LOTUS_MINER_PATH ]; then 
  export LOTUS_MINER_PATH=$ENV_LOTUS_MINER_PATH
fi
if [ ! -z $ENV_LOTUS_WORKER_PATH ]; then 
  export LOTUS_WORKER_PATH=$ENV_LOTUS_WORKER_PATH
fi
if [ ! -z $ENV_LOTUS_PROOFS_PATH ]; then 
  export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_PROOFS_PATH
fi


if [ ! -d $TMPDIR ]; then
  mkdir -p $TMPDIR
fi
if [ ! -d $FIL_PROOFS_PARAMETER_CACHE ]; then
  mkdir -p $FIL_PROOFS_PARAMETER_CACHE
fi
if [ ! -d $FIL_PROOFS_PARENT_CACHE ]; then
  mkdir -p $FIL_PROOFS_PARENT_CACHE
fi

# banner
echo -e "\033[44;37m                                                                                           \033[0m"
echo -e "\033[44;37m                                     lotus shell                                           \033[0m"
echo -e "\033[44;37m                                                                                           \033[0m"
echo " "
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_BIN is \033[0m\033[31m$ENV_LOTUS_BIN \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_ROOT is \033[0m\033[31m$ENV_LOTUS_ROOT \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m SECTOR_SIZE is \033[0m\033[31m$ENV_SECTOR_SIZE \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_NETWORK is \033[0m\033[31m$ENV_LOTUS_NETWORK \033[0m"
echo " "

if [ -z $ENV_LOTUS_ROOT ]; then
  echo -e "\033[31m TIPS: LOTUS_ROOT is empty. \033[0m"
  pause
fi

if [ -z $ENV_SECTOR_SIZE ]; then
  echo -e "\033[31m TIPS: SECTOR_SIZE is empty. \033[0m"
  pause
fi

if [ -z $ENV_LOTUS_NETWORK ]; then
  echo -e "\033[31m TIPS: LOTUS_NETWORK is empty. \033[0m"
  pause
elif [[ "$ENV_LOTUS_NETWORK" == "filecoin" ]]; then
  export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
  export SNAPSHOT_LATEST=https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car
elif [[ "$ENV_LOTUS_NETWORK" == "filecash" ]]; then
  export IPFS_GATEWAY="https://proofs.file.cash/ipfs/"
  export SNAPSHOT_LATEST=https://snapshot.file.cash/fic-snapshot-latest.car
elif [[ "$ENV_LOTUS_NETWORK" == "filestar" ]]; then
  export IPFS_GATEWAY="https://filestar-proofs.s3.cn-east-1.jdcloud-oss.com/ipfs/"
  export SNAPSHOT_LATEST=https://filestar-proofs.s3.cn-east-1.jdcloud-oss.com/snapshot/filestar.car
else
  unset IPFS_GATEWAY SNAPSHOT_LATEST
fi
