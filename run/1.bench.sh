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
export marklog="bench-$ENV_SECTOR_SIZE$nogpu-all.log"
# backup log
if [ -f "$marklog" ]; then 
  mv $marklog $marklog.$localip.$marktime.log
fi

# tips
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} sealing --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > $marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} sealing --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > $marklog 2>&1 &
echo " "


# addpiece
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} addpiece --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > addpiece-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} addpiece --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > addpiece-$marklog 2>&1 &

# precommit1
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} precommit1 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > precommit1-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} precommit1 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > precommit1-$marklog 2>&1 &

# precommit2
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} precommit2 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > precommit2-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} precommit2 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > precommit2-$marklog 2>&1 &

# commit1
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} commit1 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > commit1-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} commit1 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > commit1-$marklog 2>&1 &

# commit2
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} commit2 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > commit2-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} commit2 --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > commit2-$marklog 2>&1 &

# windowpost
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} windowpost --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > windowpost-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} windowpost --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > windowpost-$marklog 2>&1 &

# winningpost
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} winningpost --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > winningpost-$marklog 2>&1 & \033[0m"
nohup ${EXE_LOTUS_BENCH} winningpost --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH > winningpost-$marklog 2>&1 &


nohup lotus-bench addPiece --storage-dir /mnt/nvme1p1/bench --sector-size 32GiB > addPiece-bench.log 2>&1 &

nohup lotus-bench preCommit1 --storage-dir /mnt/nvme1p1/bench > preCommit1-bench.log 2>&1 &

nohup lotus-bench preCommit2 --storage-dir /mnt/nvme1p1/bench > preCommit2-bench.log 2>&1 &

nohup lotus-bench commit1 --storage-dir /mnt/nvme1p1/bench > commit1-bench.log 2>&1 &

nohup lotus-bench sealing --storage-dir /mnt/nvme1p1/bench --sector-size 512MiB --save-commit2-input c2in.json > commit2-bench.log 2>&1 &
