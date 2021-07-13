#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


#owner=`${EXE_LOTUS} wallet list |grep -E "t3|f3" |awk 'NR==1 {print $1}'`
owner=`${EXE_LOTUS} wallet default`
#actor=`${EXE_LOTUS_MINER} info |grep "Miner" |awk 'NR==1 {print $2}'`

while [[ -z $method ]] || (( "0 < $method < 1000" ))
do
  echo -e "\033[34m 
  Select:    \033[0m\033[31m$ENV_SECTOR_SIZE\033[0m\033[34m  [`hostname`]  $localip
    
    0 - ls -lhrt $LOTUS_WORKER_PATH/*/s-* && du -sh $LOTUS_WORKER_PATH/*/s-*
    1 - ls -lhrt $LOTUS_MINER_PATH/*/s-* && du -sh $LOTUS_MINER_PATH/*/s-*
    2 - watch -n 10 -d 'ls -lhrt $LOTUS_WORKER_PATH/*/s-* && du -sh $LOTUS_WORKER_PATH/*'
    3 - watch -n 10 -d 'ls -lhrt $LOTUS_MINER_PATH/*/s-* && du -sh $LOTUS_MINER_PATH/*'
    
    4 - ${EXE_LOTUS_MINER} sectors pledge
    44 - ${EXE_LOTUS_MINER} sectors pledge <group>
    5 - ${EXE_LOTUS_MINER} info 
    6 - ${EXE_LOTUS_MINER} storage list --color true
    66 - ${EXE_LOTUS_MINER} storage find <sector>
    7 - ${EXE_LOTUS_MINER} sealing workers --color true
    77 - ${EXE_LOTUS_MINER} sealing workers |grep host && echo "" && ${EXE_LOTUS_MINER} sealing workers |grep Group | sort
    8 - ${EXE_LOTUS_MINER} sectors list
    88 - ${EXE_LOTUS_MINER} sectors list |grep -v 'Proving\|Removing'
    9 - ${EXE_LOTUS_MINER} sealing jobs --color true && echo "" && ${EXE_LOTUS_MINER} sealing jobs | grep -v HostName | wc -l
    99 - ${EXE_LOTUS_MINER} sealing jobs --color true | sort -k 4 && echo "" && ${EXE_LOTUS_MINER} sealing jobs | grep -v HostName | wc -l
    999 - ${EXE_LOTUS_MINER} sealing abort <callid>
    10 - ${EXE_LOTUS_MINER} sealing setworkerparam --worker=[workerid] --key=precommit2max --value=1
    100 - ${EXE_LOTUS_MINER} sectors updatesectorgroup --sector=<sector>  --group=<group>
    11 - ${EXE_LOTUS_MINER} sectors status --log <sector>
    12 - ${EXE_LOTUS_MINER} sectors update-state --really-do-it <sector> [status]
    13 - ${EXE_LOTUS_MINER} sectors remove --really-do-it <sector>
    133 - ${EXE_LOTUS_SHED} sectors terminate --really-do-it <sector>
    
    14 - ${EXE_LOTUS_MINER} proving info
    144 - ${EXE_LOTUS_MINER} proving check <id> |grep bad
    15 - ${EXE_LOTUS_MINER} proving deadlines
    155 - ${EXE_LOTUS_MINER} proving deadline <id>
    1555 - ${EXE_LOTUS_MINER} proving faults

    16 - ${EXE_LOTUS_MINER} storage-deals set-ask --price 5200000 --verified-price 5100000 --min-piece-size 256B --max-piece-size $ENV_SECTOR_SIZE
    166 - ${EXE_LOTUS_MINER} storage-deals get-ask
    17 - ${EXE_LOTUS_MINER} actor set-addrs --gas-limit 5000000 /ip4/x.x.x.x/tcp/5427 /ip4/x.x.x.x/tcp/5427
      
    18 - ${EXE_LOTUS_MINER} actor withdraw [MinerBalance]
    19 - ${EXE_LOTUS} send --from=$owner --method=14 --params-json='\"[MinerBalance]000000000000000000\"' [MinerID] [MinerBalance]
    199 - ${EXE_LOTUS} send --from=$owner [wallet] [Balance]
    20 - ${EXE_LOTUS} wallet new bls
    200 - ${EXE_LOTUS} wallet new
    21 - ${EXE_LOTUS} wallet list
    211 - ${EXE_LOTUS_MINER} actor control list
    212 - ${EXE_LOTUS_MINER} actor control set --really-do-it <wallet>
    213 - ${EXE_LOTUS_MINER} actor set-owner --really-do-it <wallet>
    22 - ${EXE_LOTUS} sync wait
    222 - ${EXE_LOTUS} sync status
    23 - ${EXE_LOTUS} chain list
    233 - ${EXE_LOTUS} chain sethead --epoch [value]
    24 - ${EXE_LOTUS} fetch-params $ENV_SECTOR_SIZE > fetch-params.log

    25 - ${EXE_LOTUS} net listen
    26 - ${EXE_LOTUS} net peers && ${EXE_LOTUS} net peers|wc -l
    266 - ${EXE_LOTUS} net scores && ${EXE_LOTUS} net scores|wc -l
    27 - ${EXE_LOTUS_MINER} net listen
    28 - ${EXE_LOTUS_MINER} net peers && ${EXE_LOTUS_MINER} net peers|wc -l
    288 - ${EXE_LOTUS_MINER} net scores && ${EXE_LOTUS_MINER} net scores|wc -l
    
    29 - ${EXE_LOTUS} mpool pending --local | jq '.[]|.Nonce' | grep -v 'null' |wc -l && ${EXE_LOTUS} mpool pending | jq '.[]|.Nonce' | grep -v 'null' |wc -l
    299 - ${EXE_LOTUS} mpool pending --local
    30 - ${EXE_LOTUS} state get-deal [DealID]
    31 - ${EXE_LOTUS_MINER} storage-deals list
    32 - ${EXE_LOTUS_MINER} data-transfers list
    33 - ${EXE_LOTUS_MINER} retrieval-deals list
    34 - ${EXE_LOTUS} client list-deals --watch
    35 - ${EXE_LOTUS} client list-transfers --watch
    
    7777 - netstat -ntlp |grep ${EXE_LOTUS} && ps -ef |grep lotus
    8888 - kill -9 $(ps -ef|grep lotus|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')    # $(ps -ef|grep lotus|gawk '$0 !~/grep/ {print $8}' |tr -s '\n' ' ')
    9999 - exit
    \033[0m"
  
  while [[ -z $method ]]
  do
    read -e -p "  Input:" method
    if  [ ! -n "$method" ] && [ -n "$method_old" ]; then
      method=$method_old
    fi
    if echo $method | grep -q '[^0-9]'; then
      $method
      unset method
    fi
  done
  echo " "
  if [ $method -eq 0 ]; then  # ls -lhrt $LOTUS_WORKER_PATH/*/s-* && du -sh $LOTUS_WORKER_PATH/*/s-*
  {
    check_pid_exist "${EXE_LOTUS_WORKER} run"
    if [ $pid -gt 0 ]; then
      echo -e "\033[34m ls -lhrt $LOTUS_WORKER_PATH/*/s-* \033[0m" && ls -lhrt $LOTUS_WORKER_PATH/*/s-* && echo " " && echo -e "\033[34m du -sh $LOTUS_WORKER_PATH \033[0m" && du -sh $LOTUS_WORKER_PATH/*/s-*
    fi
  }
  elif [ $method -eq 1 ]; then  # ls -lhrt $LOTUS_MINER_PATH/*/s-* && du -sh $LOTUS_MINER_PATH/*/s-*
  {
    check_pid_exist "${EXE_LOTUS_MINER} run"
    if [ $pid -gt 0 ]; then
      echo -e "\033[34m ls -lhrt $LOTUS_MINER_PATH/*/s-* \033[0m" && ls -lhrt $LOTUS_MINER_PATH/*/s-* && echo " " && echo -e "\033[34m du -sh $LOTUS_MINER_PATH \033[0m" && du -sh $LOTUS_MINER_PATH/*/s-*
    fi
  }
  elif [ $method -eq 2 ]; then  # watch -n 10 'ls -lhrt $LOTUS_WORKER_PATH/*/s-* && du -sh $LOTUS_WORKER_PATH/*'
  {
    while [[ -z $monitor_type ]]
    do
      echo -e "\033[34m 
    Select watch path:      [`hostname`]  $localip
        
      1 - cache    (default)
      2 - sealed
      3 - unsealed
      4 - bench*
      \033[0m"
      read -e -p "  Input:" monitor_type
      if [ -z $monitor_type ]; then
        monitor_type=1
      fi
      
      if [ $monitor_type -eq 1 ]; then
        monitor_path=cache
      elif [ $monitor_type -eq 2 ]; then
        monitor_path=sealed
      elif [ $monitor_type -eq 3 ]; then
        monitor_path=unsealed
      elif [ $monitor_type -eq 4 ]; then
        monitor_path=bench*
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    done
    echo " "
    
    if [ $monitor_type -eq 1 ]; then
        while [[ -z $monitor_sector ]]
        do
          echo -e "\033[34m `ls -lhrt $LOTUS_WORKER_PATH/$monitor_path |awk '{print $9}'` \033[0m"
        echo -e "\033[34m 
      Select watch sector:      [`hostname`]  $localip
            
        *   - all    (default)
        int - sector_id
        \033[0m"
          read -e -p "  Input:" monitor_sector
          if [ -z $monitor_sector ]; then
            monitor_sector=*
          fi
          
          if [ "$monitor_sector" = "*" ]; then  # all
            sector_path=*
          elif [ $monitor_sector -ge 0 ]; then  # id
            sector_path=s-*-$monitor_sector
          else
            echo -e "\033[31m Input error \033[0m"
          fi
        done
        echo " "
    else
        sector_path=*
    fi
    
    # info
    echo "ls -lhrt $LOTUS_WORKER_PATH/$monitor_path/$sector_path && du -sh $LOTUS_WORKER_PATH/$monitor_path/$sector_path"
    
    check_pid_exist "${EXE_LOTUS_WORKER} run"
    if [ $pid -gt 0 ]; then
      watch -n 10 -d "ls -lhrt $LOTUS_WORKER_PATH/$monitor_path/$sector_path && du -sh $LOTUS_WORKER_PATH/$monitor_path/$sector_path"
    fi
  }
  elif [ $method -eq 3 ]; then  # watch -n 10 'ls -lhrt $LOTUS_MINER_PATH/*/s-* && du -sh $LOTUS_MINER_PATH/*'
  {
    while [[ -z $monitor_type ]]
    do
      echo -e "\033[34m 
    Select watch path:      [`hostname`]  $localip
        
      1 - cache    (default)
      2 - sealed
      3 - unsealed
      4 - bench*
      \033[0m"
      read -e -p "  Input:" monitor_type
      if [ -z $monitor_type ]; then
        monitor_type=1
      fi
      
      if [ $monitor_type -eq 1 ]; then
        monitor_path=cache
      elif [ $monitor_type -eq 2 ]; then
        monitor_path=sealed
      elif [ $monitor_type -eq 3 ]; then
        monitor_path=unsealed
      elif [ $monitor_type -eq 4 ]; then
        monitor_path=bench*
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    done
    echo " "
    
    if [ $monitor_type -eq 1 ]; then
        while [[ -z $monitor_sector ]]
        do
          echo -e "\033[34m `ls -lhrt $LOTUS_MINER_PATH*/$monitor_path |awk '{print $9}'` \033[0m"
        echo -e "\033[34m 
      Select watch sector:      [`hostname`]  $localip
          
        *   - all    (default)
        int - sector_id
        \033[0m"
          read -e -p "  Input:" monitor_sector
          if [ -z $monitor_sector ]; then
            monitor_sector=*
          fi
          
          if [ "$monitor_sector" = "*" ]; then  # all
            sector_path=*
          elif [ $monitor_sector -ge 0 ]; then  # id
            sector_path=s-*-$monitor_sector
          else
            echo -e "\033[31m Input error \033[0m"
          fi
        done
        echo " "
    else
        sector_path=*
    fi
    
    # info
    echo "ls -lhrt $LOTUS_MINER_PATH*/$monitor_path/$sector_path && du -sh $LOTUS_MINER_PATH*/$monitor_path/$sector_path"
    
    check_pid_exist "${EXE_LOTUS_MINER} run"
    if [ $pid -gt 0 ]; then
      watch -n 10 -d "ls -lhrt $LOTUS_MINER_PATH*/$monitor_path/$sector_path && du -sh $LOTUS_MINER_PATH*/$monitor_path/$sector_path"
    fi
  }
  elif [ $method -eq 4 ]; then  # ${EXE_LOTUS_MINER} sectors pledge
  {
    #num
    while [ -z $num ]
    do
      read -e -p '  please input pledge number:' num
      if [ -z $num ]; then
        num=1
      fi
    done
    #echo ' '
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} sectors pledge  * $num \033[0m"
    
    check_areyousure 3
    if [ $areyousure -eq 1 ]; then
      for i in $(seq $num); 
      do 
        echo "    pledge  all $num run $i"
        ${EXE_LOTUS_MINER} sectors pledge 
        sleep 1
      done
    fi
  }
  elif [ $method -eq 44 ]; then  # ${EXE_LOTUS_MINER} sectors pledge <group>
  {
    #group
    while [ -z $group ]
    do
      read -e -p '  please input pledge group:' group
      if [ -z $group ]; then
        echo -e "\033[34m Input grouping information\033[0m"
      fi
    done
    #echo ' '
    
    #num
    while [ -z $num ]
    do
      read -e -p '  please input pledge number:' num
      if [ -z $num ]; then
        num=1
      fi
    done
    #echo ' '

    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} sectors pledge $group * $num \033[0m"
    
    check_areyousure 3
    if [ $areyousure -eq 1 ]; then
      for i in $(seq $num); 
      do 
        echo "    pledge  all $num run $i"
        ${EXE_LOTUS_MINER} sectors pledge $group
        sleep 1
      done
    fi
  }
  elif [ $method -eq 5 ]; then  # ${EXE_LOTUS_MINER} info
    ${EXE_LOTUS_MINER} info
  elif [ $method -eq 6 ]; then  # ${EXE_LOTUS_MINER} storage list --color true
    ${EXE_LOTUS_MINER} storage list --color true
  elif [ $method -eq 66 ]; then  # ${EXE_LOTUS_MINER} storage find <sector>
  {
    while [ -z $sector ]
    do
      read -e -p "  please input sector:" sector
      if [ -z $sector ]; then
        unset sector
      elif echo $sector | grep -q '[^0-9]'; then
        unset sector
      elif [ $sector -le 0 ] && [ $sector -ge 65535 ]; then
        unset sector
      fi
    done
    echo " "
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} storage find $sector \033[0m"
    
    ${EXE_LOTUS_MINER} storage find $sector
  }
  elif [ $method -eq 7 ]; then  # ${EXE_LOTUS_MINER} sealing workers --color true
    ${EXE_LOTUS_MINER} sealing workers --color true
  elif [ $method -eq 77 ]; then  # ${EXE_LOTUS_MINER} sealing workers |grep host && echo "" && ${EXE_LOTUS_MINER} sealing workers |grep Group | sort && echo "" && ${EXE_LOTUS_MINER} sealing workers |grep Group | sort | wc -l
    ${EXE_LOTUS_MINER} sealing workers |grep host && echo "" && ${EXE_LOTUS_MINER} sealing workers |grep Group | sort && echo "" && ${EXE_LOTUS_MINER} sealing workers |grep Group | sort | wc -l
  elif [ $method -eq 8 ]; then  # ${EXE_LOTUS_MINER} sectors list
    ${EXE_LOTUS_MINER} sectors list
  elif [ $method -eq 88 ]; then  # ${EXE_LOTUS_MINER} sectors list |grep -v Proving
    ${EXE_LOTUS_MINER} sectors list |grep -v 'Proving\|Removing'
  elif [ $method -eq 888 ]; then  # ${EXE_LOTUS_MINER} sectors list > $ENV_LOG_DIR/sectors-`date "+%Y%m%d-%H%M%S"`.txt
    ${EXE_LOTUS_MINER} sectors list > $ENV_LOG_DIR/sectors-`date "+%Y%m%d-%H%M%S"`.txt
  elif [ $method -eq 9 ]; then  # ${EXE_LOTUS_MINER} sealing jobs --color true
    ${EXE_LOTUS_MINER} sealing jobs --color true && echo "" && ${EXE_LOTUS_MINER} sealing jobs | grep -v HostName | wc -l
  elif [ $method -eq 99 ]; then  # ${EXE_LOTUS_MINER} sealing jobs --color true
    ${EXE_LOTUS_MINER} sealing jobs --color true | sort -k 4 && echo "" && ${EXE_LOTUS_MINER} sealing jobs | grep -v HostName | wc -l
  elif [ $method -eq 999 ]; then  # ${EXE_LOTUS_MINER} sealing abort <callid>
  {
    #callid
    while [ -z $callid ]
    do
      read -e -p '  please input sector callid:' callid
      if [ -z $callid ]; then
        echo -e "\033[34m Input sector callid\033[0m"
      fi
    done
    #echo ' '
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} sealing abort $callid \033[0m"
    
    check_areyousure 3
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS_MINER} sealing abort $callid
    fi
  }
  elif [ $method -eq 10 ]; then  # ${EXE_LOTUS_MINER} sealing setworkerparam --worker=[workerid] --key=precommit2max --value=1
  {

    while [[ -z $workerparam_key_type ]]
    do
      echo -e "\033[34m 
    Select setworkerparam key:      [`hostname`]  $localip
      
      0 - app1max
      1 - addpiecemax
      2 - precommit1max
      3 - precommit2max (default)
      4 - commitmax
      5 - hugepage
      6 - group
      \033[0m"
      read -e -p "  Input:" workerparam_key_type
      if [ -z $workerparam_key_type ]; then
        workerparam_key_type=2
      fi
      
      if [ $workerparam_key_type -eq 0 ]; then
        workerparam_key=app1max
      elif [ $workerparam_key_type -eq 1 ]; then
        workerparam_key=addpiecemax
      elif [ $workerparam_key_type -eq 2 ]; then
        workerparam_key=precommit1max
      elif [ $workerparam_key_type -eq 3 ]; then
        workerparam_key=precommit2max
      elif [ $workerparam_key_type -eq 4 ]; then
        workerparam_key=commitmax
      elif [ $workerparam_key_type -eq 5 ]; then
        workerparam_key=hugepage
      elif [ $workerparam_key_type -eq 6 ]; then
        workerparam_key=group
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    done
    echo " "
    
    if [ $workerparam_key_type -eq 6 ]; then
      while [ -z $workerparam_key_value ]
      do
        read -e -p "  please input group_name (default filecash):" workerparam_key_value
        if [ -z $workerparam_key_value ]; then
          workerparam_key_value=filecash
        fi
      done
      echo " "
    else
      while [ -z $workerparam_key_value ]
      do
        read -e -p "  please input key_value (default 1):" workerparam_key_value
        if [ -z $workerparam_key_value ]; then
          workerparam_key_value=1
        elif echo $workerparam_key_value | grep -q '[^0-9]'; then
          unset workerparam_key_value
        elif [ $workerparam_key_value -le 0 ] && [ $workerparam_key_value -ge 65535 ]; then
          unset workerparam_key_value
        fi
      done
      echo " "
    fi

    while [ -z $start ]
    do
      read -e -p "  please input start: " start
      if [ -z $start ]; then
        unset start
      elif echo $start | grep -q '[^0-9]'; then
        unset start
      elif [ $start -le 0 ] && [ $start -ge 65535 ]; then
        unset start
      fi
    done
    while [ -z $end ]
    do
      read -e -p "  please input  end : " end
      if [ -z $end ]; then
        end=$start
      elif echo $end | grep -q '[^0-9]'; then
        unset end
      elif [ $end -le 0 ] && [ $end -ge 65535 ]; then
        unset end
      fi
    done
    echo " "
    # echo ${start} ${end}
    
    for ((i=${start};i<=${end};i++))
    do
      # tips
      echo -e "\033[34m ${EXE_LOTUS_MINER} sealing setworkerparam --worker=${i} --key=${workerparam_key} --value=${workerparam_key_value} \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} sealing setworkerparam --worker=${i} --key=${workerparam_key} --value=${workerparam_key_value}
      fi
      sleep 1
      echo " "
    done
    echo " "
  }
  elif [ $method -eq 100 ]; then  # ${EXE_LOTUS_MINER} sectors setsectorgroup --sector=<sector> --group=<group>
  {
    #sector
    while [ -z $sector ]
    do
      read -e -p '  please input sector_id:' sector
      if [ -z $sector ]; then
        echo -e "\033[34m Input sector id\033[0m"
      elif echo $sector | grep -q '[^0-9]'; then
        unset sector
      elif [ $sector -le 0 ] && [ $sector -ge 65535 ]; then
        unset sector
      fi
    done
    #echo ' '

    #group
    while [ -z $group ]
    do
      read -e -p '  please input pledge group:' group
      if [ -z $group ]; then
        echo -e "\033[34m Input grouping information\033[0m"
      fi
    done
    #echo ' '
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} sectors updatesectorgroup --sector=$sector --group=$group \033[0m"
    
    check_areyousure 3
    if [ $areyousure -eq 1 ]; then
      for i in $(seq $num); 
      do 
        ${EXE_LOTUS_MINER} sectors updatesectorgroup --sector=$sector --group=$group
      done
    fi
  }
  elif [ $method -eq 11 ]; then  # ${EXE_LOTUS_MINER} sectors status --log <sector>
  {
    while [ -z $sector ]
    do
      read -e -p "  please input sector:" sector
      if [ -z $sector ]; then
        unset sector
      elif echo $sector | grep -q '[^0-9]'; then
        unset sector
      elif [ $sector -le 0 ] && [ $sector -ge 65535 ]; then
        unset sector
      fi
    done
    echo " "
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} sectors status --log $sector \033[0m"
    
    ${EXE_LOTUS_MINER} sectors status --log $sector
  }
  elif [ $method -eq 12 ]; then  # ${EXE_LOTUS_MINER} sectors update-state --really-do-it <sector> [status]
  {
    while [[ -z $monitor_type ]]
    do
      echo -e "\033[34m 
    Select sector_state:      [`hostname`]  $localip
      
      0 - Committing
      1 - FinalizeSector (default)
      2 - FaultedFinal
      3 - Unsealed
      4 - PreCommitted
      5 - Packing
      6 - Empty
      \033[0m"
      read -e -p "  Input:" monitor_type
      if [ -z $monitor_type ]; then
        monitor_type=1
      fi
      
      
      if [ $monitor_type -eq 0 ]; then
        sector_state=Committing
      elif [ $monitor_type -eq 1 ]; then
        sector_state=FinalizeSector
      elif [ $monitor_type -eq 2 ]; then
        sector_state=FaultedFinal
      elif [ $monitor_type -eq 3 ]; then
        sector_state=Unsealed
      elif [ $monitor_type -eq 4 ]; then
        sector_state=PreCommitted
      elif [ $monitor_type -eq 5 ]; then
        sector_state=Packing
      elif [ $monitor_type -eq 6 ]; then
        sector_state=Empty
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    done
    echo " "
    
    while [ -z $start ]
    do
      read -e -p "  please input start: " start
      if [ -z $start ]; then
        unset start
      elif echo $start | grep -q '[^0-9]'; then
        unset start
      elif [ $start -le 0 ] && [ $start -ge 65535 ]; then
        unset start
      fi
    done
    while [ -z $end ]
    do
      read -e -p "  please input  end : " end
      if [ -z $end ]; then
        end=$start
      elif echo $end | grep -q '[^0-9]'; then
        unset end
      elif [ $end -le 0 ] && [ $end -ge 65535 ]; then
        unset end
      fi
    done
    echo " "
    # echo ${start} ${end}
    
    for ((i=${start};i<=${end};i++))
    do
      # tips
      echo -e "\033[34m ${EXE_LOTUS_MINER} sectors update-state --really-do-it ${i} $sector_state \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} sectors update-state --really-do-it ${i} $sector_state
      fi
      sleep 1
      echo " "
    done
    echo " "
    
  }
  elif [ $method -eq 13 ]; then  # ${EXE_LOTUS_MINER} sectors remove --really-do-it <sector> 
  {
    while [ -z $start ]
    do
      read -e -p "  please input start: " start
      if [ -z $start ]; then
        unset start
      elif echo $start | grep -q '[^0-9]'; then
        unset start
      elif [ $start -le 0 ] && [ $start -ge 65535 ]; then
        unset start
      fi
    done
    while [ -z $end ]
    do
      read -e -p "  please input  end : " end
      if [ -z $end ]; then
        end=$start
      elif echo $end | grep -q '[^0-9]'; then
        unset end
      elif [ $end -le 0 ] && [ $end -ge 65535 ]; then
        unset end
      fi
    done
    echo " "
    for ((i=${start};i<=${end};i++))
    do
      # tips
      echo -e "\033[34m ${EXE_LOTUS_MINER} sectors remove --really-do-it ${i} \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} sectors remove --really-do-it ${i}
        ${EXE_LOTUS} state active-sectors $actor |grep -w '${i}:' 
      fi
      sleep 1
      echo " "
    done
    echo " "
    
  }
  elif [ $method -eq 133 ]; then  # ${EXE_LOTUS_SHED} sectors terminate --really-do-it <sector>
  {
    while [ -z $start ]
    do
      read -e -p "  please input start: " start
      if [ -z $start ]; then
        unset start
      elif echo $start | grep -q '[^0-9]'; then
        unset start
      elif [ $start -le 0 ] && [ $start -ge 65535 ]; then
        unset start
      fi
    done
    while [ -z $end ]
    do
      read -e -p "  please input  end : " end
      if [ -z $end ]; then
        end=$start
      elif echo $end | grep -q '[^0-9]'; then
        unset end
      elif [ $end -le 0 ] && [ $end -ge 65535 ]; then
        unset end
      fi
    done
    echo " "
    for ((i=${start};i<=${end};i++))
    do
      # tips
      echo -e "\033[34m ${EXE_LOTUS_SHED} sectors terminate --really-do-it ${i} \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_SHED} sectors terminate --really-do-it ${i}
        ${EXE_LOTUS} state active-sectors $actor |grep -w '${i}:' 
      fi
      sleep 1
      echo " "
    done
    echo " "
    
  }
  elif [ $method -eq 14 ]; then  # ${EXE_LOTUS_MINER} proving info
    ${EXE_LOTUS_MINER} proving info
  elif [ $method -eq 144 ]; then  # ${EXE_LOTUS_MINER} proving check <id> |grep bad
  {
    while [ -z $num ]
    do
      read -e -p "  please input num:" num
      if [ -z $num ]; then
        unset num
      elif echo $num | grep -q '[^0-9]'; then
        unset num
      elif [ $num -le 0 ] && [ $num -ge 65535 ]; then
        unset num
      fi
    done
    echo " "
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} proving check $num |grep bad \033[0m"
    
    ${EXE_LOTUS_MINER} proving check $num |grep bad
  }
  elif [ $method -eq 15 ]; then  # ${EXE_LOTUS_MINER} proving deadlines
    ${EXE_LOTUS_MINER} proving deadlines
  elif [ $method -eq 155 ]; then  # ${EXE_LOTUS_MINER} proving deadline <id>
  {
    while [ -z $num ]
    do
      read -e -p "  please input num:" num
      if [ -z $num ]; then
        unset num
      elif echo $num | grep -q '[^0-9]'; then
        unset num
      elif [ $num -le 0 ] && [ $num -ge 65535 ]; then
        unset num
      fi
    done
    echo " "
    
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} proving deadline $num \033[0m"
    
    ${EXE_LOTUS_MINER} proving deadline $num
  }
  elif [ $method -eq 1555 ]; then  # ${EXE_LOTUS_MINER} proving faults
    ${EXE_LOTUS_MINER} proving faults
  elif [ $method -eq 16 ]; then  # ${EXE_LOTUS_MINER} storage-deals set-ask --price 5200000 --verified-price 5100000 --min-piece-size 256B --max-piece-size $ENV_SECTOR_SIZE
    ${EXE_LOTUS_MINER} storage-deals set-ask --price 5200000 --verified-price 5100000 --min-piece-size 256B --max-piece-size $ENV_SECTOR_SIZE
  elif [ $method -eq 166 ]; then  # ${EXE_LOTUS_MINER} storage-deals get-ask
    ${EXE_LOTUS_MINER} storage-deals get-ask
  elif [ $method -eq 17 ]; then  # ${EXE_LOTUS_MINER} actor set-addrs --gas-limit 5000000 /ip4/x.x.x.x/tcp/5427 /ip4/x.x.x.x/tcp/5427
  {
    while [ -z $onlineaddr ]
    do
      read -e -p "  please input online addr:" onlineaddr
      if [ -z $onlineaddr ]; then
        unset onlineaddr
      fi
    done
    echo " "
    
    #info
    echo -e "\033[34m  ${EXE_LOTUS_MINER} actor set-addrs --gas-limit 5000000 $onlineaddr \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS_MINER} actor set-addrs --gas-limit 5000000 $onlineaddr
    fi
  }
  elif [ $method -eq 18 ]; then  # ${EXE_LOTUS_MINER} actor withdraw [MinerBalance]
  {
    #while [ -z $balance ]
    #do
      read -e -p "  please input send_balance:" balance
      if [ -z $balance ]; then
        echo "Withdraw all balances"
      elif echo $balance | grep -q '[^0-9]'; then
        unset balance
      #elif [ $balance -le 0 ] && [ $balance -ge 65535 ]; then
      #  unset balance
      fi
    #done
    echo " "

    #info
    echo -e "\033[34m  ${EXE_LOTUS_MINER} actor withdraw $balance \033[0m"
    
    check_areyousure 3
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS_MINER} actor withdraw $balance
    fi
  }
  elif [ $method -eq 19 ]; then  # ${EXE_LOTUS} send --from=$owner --method=14 --params-json=\'\"[MinerBalance]000000000000000000\"\' [MinerID] [MinerBalance]
  {
    while [ -z $minerid ]
    do
      read -e -p "  please input minerid:" minerid
      if [ -z $minerid ]; then
        minerid=`lotus-miner info |grep "Miner" |awk 'NR==1 {print $2}'`
      elif ! echo $minerid | grep -q '^f0[0-9]\{4,8\}$' ; then
        unset minerid
      fi
    done
    echo " "
    while [ -z $balance ]
    do
      read -e -p "  please input send_balance:" balance
      if [ -z $balance ]; then
        unset balance
      elif echo $balance | grep -q '[^0-9]'; then
        unset balance
      elif [ $balance -le 0 ] && [ $balance -ge 65535 ]; then
        unset balance
      fi
    done
    echo " "
    
    #info
    echo -e "\033[34m  ${EXE_LOTUS} send --from=$owner --method=14 --params-json='\"${balance}000000000000000000\"' $minerid $balance \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS} send --from=$owner --method=14 --params-json="'\"""${balance}000000000000000000""\"'" $minerid $balance
    fi
  }
  elif [ $method -eq 199 ]; then  # ${EXE_LOTUS} send --from=$owner [wallet] [Balance]
  {
    while [ -z $recv_wallet ]
    do
      read -e -p "  please input recv_wallet:" recv_wallet
      if [ -z $recv_wallet ]; then
        unset recv_wallet
      elif ! echo $recv_wallet | grep ^[tf].* ; then
        unset recv_wallet
      fi
    done
    echo " "
    while [ -z $balance ]
    do
      read -e -p "  please input send_balance:" balance
      if [ -z $balance ]; then
        unset balance
      elif echo $balance | grep -q '[^0-9]'; then
        unset balance
      elif [ $balance -le 0 ] && [ $balance -ge 65535 ]; then
        unset balance
      fi
    done
    echo " "
    
    #info
    echo -e "\033[34m  ${EXE_LOTUS} send --from=$owner $recv_wallet $balance \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS} send --from=$owner $recv_wallet $balance
    fi
  }
  elif [ $method -eq 20 ]; then  # ${EXE_LOTUS} wallet new bls
  {
    #info
    echo -e "\033[34m  ${EXE_LOTUS} wallet new bls \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS} wallet new bls
    fi
  }
  elif [ $method -eq 200 ]; then  # ${EXE_LOTUS} wallet new
  {
    #info
    echo -e "\033[34m  ${EXE_LOTUS} wallet new \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS} wallet new
    fi
  }
  elif [ $method -eq 21 ]; then  # ${EXE_LOTUS} wallet list
  {
    ${EXE_LOTUS} wallet list

    #string=`${EXE_LOTUS} wallet list | tr "\n" ","`
    ##将,替换为空格
    #array=(${string//,/ })  
    #for var in ${array[@]}
    #do
    #  echo $var
    #  ${EXE_LOTUS} wallet balance $var
    #  echo " "
    #done
  }
  elif [ $method -eq 211 ]; then  # ${EXE_LOTUS_MINER} actor control list
  {
    ${EXE_LOTUS_MINER} actor control list
    controlnum=`lotus-miner actor control list |wc -l`
    if [ $controlnum -eq 3 ]; then
      while [ -z $post_wallet ]
      do
        read -e -p "  please input control post-msg wallet:" post_wallet
        if [ -z $post_wallet ]; then
          unset post_wallet
        elif ! echo $post_wallet |grep -E "t3|f3" |awk 'NR==1 {print $1}' ; then
          unset post_wallet
        fi
      done
      echo " "
      
      #info
      echo -e "\033[34m  ${EXE_LOTUS_MINER} actor control set --really-do-it $post_wallet \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} actor control set --really-do-it $post_wallet
      fi
    fi
  }
  elif [ $method -eq 212 ]; then  # ${EXE_LOTUS_MINER} actor control set --really-do-it <wallet>
  {
      while [ -z $post_wallet ]
      do
        read -e -p "  please input control post-msg wallet:" post_wallet
        if [ -z $post_wallet ]; then
          unset post_wallet
        elif ! echo $post_wallet |grep -E "t3|f3" |awk 'NR==1 {print $1}' ; then
          unset post_wallet
        fi
      done
      echo " "
      
      #info
      echo -e "\033[34m  ${EXE_LOTUS_MINER} actor control set --really-do-it $post_wallet \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} actor control set --really-do-it $post_wallet
      fi
  }
  elif [ $method -eq 213 ]; then  # ${EXE_LOTUS_MINER} actor set-owner --really-do-it <wallet>
  {
      while [ -z $owner_wallet ]
      do
        read -e -p "  please input control owner_wallet:" owner_wallet
        if [ -z $owner_wallet ]; then
          unset owner_wallet
        elif ! echo $owner_wallet |grep -E "t3|f3" |awk 'NR==1 {print $1}' ; then
          unset owner_wallet
        fi
      done
      echo " "
      
      #info
      echo -e "\033[34m  ${EXE_LOTUS_MINER} actor set-owner --really-do-it $owner_wallet \033[0m"
      
      check_areyousure
      if [ $areyousure -eq 1 ]; then
        ${EXE_LOTUS_MINER} actor set-owner --really-do-it $owner_wallet
      fi
  }
  elif [ $method -eq 22 ]; then  # ${EXE_LOTUS} sync wait
    ${EXE_LOTUS} sync wait
  elif [ $method -eq 222 ]; then  # ${EXE_LOTUS} sync status
    ${EXE_LOTUS} sync status
  elif [ $method -eq 23 ]; then  # ${EXE_LOTUS} chain list
    ${EXE_LOTUS} chain list
  elif [ $method -eq 233 ]; then  # ${EXE_LOTUS} chain sethead --epoch [value]
  {
    while [ -z $epochvalue ]
    do
      read -e -p "  please input sethead epoch:" epochvalue
      if [ -z $epochvalue ]; then
        unset epochvalue
      elif echo $epochvalue | grep -q '[^0-9]'; then
        unset epochvalue
      elif [ $epochvalue -le 0 ]; then
        unset epochvalue
      fi
    done
    echo " "
    
    #info
    echo -e "\033[34m  ${EXE_LOTUS} chain sethead --epoch $epochvalue \033[0m"
    
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      ${EXE_LOTUS} chain sethead --epoch $epochvalue
    fi
  }
  elif [ $method -eq 24 ]; then  #  ${EXE_LOTUS} fetch-params $ENV_SECTOR_SIZE > fetch-params.log
     ${EXE_LOTUS} fetch-params $ENV_SECTOR_SIZE > $ENV_LOG_DIR/fetch-params.log
  elif [ $method -eq 25 ]; then  # ${EXE_LOTUS} net listen
    ${EXE_LOTUS} net listen
  elif [ $method -eq 26 ]; then  # ${EXE_LOTUS} net peers
    ${EXE_LOTUS} net peers && echo " " && ${EXE_LOTUS} net peers|wc -l
  elif [ $method -eq 266 ]; then  # ${EXE_LOTUS} net scores
    ${EXE_LOTUS} net scores && echo " " && ${EXE_LOTUS} net scores|wc -l
  elif [ $method -eq 27 ]; then  # ${EXE_LOTUS_MINER} net listen
    ${EXE_LOTUS_MINER} net listen
  elif [ $method -eq 28 ]; then  # ${EXE_LOTUS_MINER} net peers
    ${EXE_LOTUS_MINER} net peers && echo " " && ${EXE_LOTUS_MINER} net peers|wc -l
  elif [ $method -eq 288 ]; then  # ${EXE_LOTUS_MINER} net scores
    ${EXE_LOTUS_MINER} net scores && echo " " && ${EXE_LOTUS_MINER} net scores|wc -l
  elif [ $method -eq 29 ]; then  # ${EXE_LOTUS} mpool pending --local | jq '.[]|.Nonce' | grep -v "null" |wc -l && ${EXE_LOTUS} mpool pending | jq '.[]|.Nonce' | grep -v "null" |wc -l
    ${EXE_LOTUS} mpool pending --local | jq '.[]|.Nonce' | grep -v "null" |wc -l && ${EXE_LOTUS} mpool pending | jq '.[]|.Nonce' | grep -v "null" |wc -l
  elif [ $method -eq 299 ]; then  # ${EXE_LOTUS} mpool pending --local
    ${EXE_LOTUS} mpool pending --local
  elif [ $method -eq 30 ]; then  # ${EXE_LOTUS} state get-deal [DealID]
  {
    while [ -z $deal ]
    do
      read -e -p '  please input Deal ID:' deal
      if [ -z $deal ]; then
        unset deal
      fi
    done
    #echo ' '
    
    #info
    echo -e "\033[34m  ${EXE_LOTUS} state get-deal $deal \033[0m"
    
    ${EXE_LOTUS} state get-deal $deal
  }
  elif [ $method -eq 31 ]; then  # ${EXE_LOTUS_MINER} storage-deals list
    ${EXE_LOTUS_MINER} storage-deals list
  elif [ $method -eq 32 ]; then  # ${EXE_LOTUS_MINER} data-transfers list
    ${EXE_LOTUS_MINER} data-transfers list
  elif [ $method -eq 33 ]; then  # ${EXE_LOTUS_MINER} retrieval-deals list
    ${EXE_LOTUS_MINER} retrieval-deals list
  elif [ $method -eq 34 ]; then  # ${EXE_LOTUS} client list-deals --watch
    ${EXE_LOTUS} client list-deals --watch
  elif [ $method -eq 35 ]; then  # ${EXE_LOTUS} client list-transfers --watch
    ${EXE_LOTUS} client list-transfers --watch
  elif [ $method -eq 7777 ]; then  # netstat -ntlp |grep ${EXE_LOTUS} && ps -ef |grep lotus
    echo -e "\033[34m netstat -ntlp |grep ${EXE_LOTUS} \033[0m" && netstat -ntlp |grep ${EXE_LOTUS} && echo " " && echo -e "\033[34m ps -ef |grep ${EXE_LOTUS} \033[0m" && ps -ef |grep lotus
  elif [ $method -eq 8888 ]; then  # kill -9 lotus
  {
    echo kill -9 $(ps -ef|grep lotus|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')    "#" $(ps -ef|grep lotus|gawk '$0 !~/grep/ {print $8}' |tr -s '\n' ' ')
    unset areyousure
    check_areyousure
    if [ $areyousure -eq 1 ]; then
      kill -9 $(ps -ef|grep lotus|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
    fi
  }
  elif [ $method -eq 9999 ]; then  # exit
    exit 1
  else  # error
  {
    echo " "
    echo -e "\033[31m Input error \033[0m"
  }
  fi
  
  method_old=$method
  echo " "
  pause && unset method worker work num sector group callid minerid balance monitor_type start end monitor_sector height 
  
done

  #elif [ $method -eq 16 ]; then  # ${EXE_LOTUS_MINER} storage-deals list
  #  ${EXE_LOTUS_MINER} storage-deals list
  #elif [ $method -eq 17 ]; then  # ${EXE_LOTUS_MINER} storage-deals list |grep -A 1 ProposalCid |grep / |awk -F ':' '{print $2}' |tr -d '\"' 
  #  lotus-miner storage-deals list |grep -A 1 ProposalCid |grep / |awk -F ':' '{print $2}' |tr -d '\"' 
  #elif [ $method -eq 18 ]; then  # ${EXE_LOTUS_MINER} storage-deals list |grep -A 1 Root |grep / |awk -F ':' '{print $2}' |tr -d '\"' 
  #  lotus-miner storage-deals list |grep -A 1 Root |grep / |awk -F ':' '{print $2}' |tr -d '\"' 
  #elif [ $method -eq 199 ]; then  # ${EXE_LOTUS} send --from=$owner [MinerID] [MinerBalance]
  # {
  #  while [ -z $minerid ]
  #  do
  #    read -e -p "  please input minerid:" minerid
  #    if [ -z $minerid ]; then
  #      minerid=`lotus-miner info |grep "Miner" |awk 'NR==1 {print $2}'`
  #    elif ! echo $minerid | grep -q '^f0[0-9]\{4,8\}$' ; then
  #      unset minerid
  #    fi
  #  done
  #  echo " "
  #  while [ -z $balance ]
  #  do
  #    read -e -p "  please input send_balance:" balance
  #    if [ -z $balance ]; then
  #      unset balance
  #    elif echo $balance | grep -q '[^0-9]'; then
  #      unset balance
  #    elif [ $balance -le 0 ] && [ $balance -ge 65535 ]; then
  #      unset balance
  #    fi
  #  done
  #  echo " "
  #  #info
  #  echo -e "\033[34m  ${EXE_LOTUS} send --from=$owner $minerid $balance \033[0m"
  #  check_areyousure
  #  if [ $areyousure -eq 1 ]; then
  #    ${EXE_LOTUS} send --from=$owner $minerid $balance
  #  fi
  # }