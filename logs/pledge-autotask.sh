#/bin/bash

#> nohup bash pledge-autotask.sh 18>> ./autotask-pledge-group.log 2>&1 &

if [ -z $LOTUS_MINER_PATH ]; then
  echo 'LOTUS_MINER_PATH is empty.'
  exit
fi

check_pid_exist() {
  pid=`ps -ef |grep "$1" |grep -v "grep" |awk '{print $2}'|wc -l`
  echo "pid=$pid"
  if [ -z $pid ]; then
    pid=0
  fi
}

myself=$0

if [ "$1" == "kill" ]; then
  check_pid_exist "$myself"
  if [ $pid -gt 0 ]; then
    kill -9 $(ps -ef|grep $myself|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
  else
    # tips
    echo -e "\033[31m $0  is not exist. \033[0m"
  fi
  echo " "
  exit
## interval=1800    # sec    $1
elif [ -z $1 ]; then 
  interval=1800
else 
  interval=$1
fi

check_pid_exist "$myself"
if [ $pid -gt 3 ]; then
  # tips
  echo -e "\033[31m $0  is exist. \033[0m"
  exit
fi

group="
51
52
53
54
55
"

echo ""
echo "sleep interval: ${interval} "
string=`echo $group | tr "\n" " "`
echo "group:{  ${string} }"
echo ""

while true
do
  echo ""
  echo "=--start $(date "+%Y-%m-%d %H:%M:%S")--------------------="
  for i in $group
  do
    if [ ! -z $i ]; then
      #当前分组 总任务数
      taskall=`lotus-miner sealing jobs | grep -w $i | wc -l`
      if [ $taskall -gt 0 ]; then
        #当前分组 APP1任务数
        tasknow=`lotus-miner sealing jobs | grep -w $i | grep -Ew 'PC1|AP' | wc -l`
        #应该发送的任务数
        dotask=$[6 - $tasknow]
        echo '##检查分组 $i 任务数##'
        if [ $dotask -gt 0 ] ; then
          echo "分组:$i 当前任务数:$tasknow 还需要 $dotask 个任务."
          echo "----开始发送-------------------"
          echo "lotus-miner sectors pledge $i"
          lotus-miner sectors pledge $i
          echo "-------------------发送完成----"
          echo "sleeping 30 s"
          sleep 30
        else
          echo "分组:$i 任务已满 $tasknow 个"
        fi
      else
        echo "分组:$i 所有任务总数 0 个，请检查机器是否正常。"
      fi
      echo ""
    fi
  done
  echo "=--------------------end $(date "+%Y-%m-%d %H:%M:%S")--="
  echo ""
  echo "sleeping ${interval} s"
  sleep ${interval}
done
