#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


#rm -rf /usr/local/bin/pause
if [ ! -f "/usr/local/bin/pause" ]; then 
  sudo echo "#! /bin/bash
  get_char()
  {
    SAVEDSTTY=\`stty -g\` 
    stty -echo 
    stty raw 
    dd if=/dev/tty bs=1 count=1 2> /dev/null 
    stty -raw 
    stty echo 
    stty \$SAVEDSTTY 
  }
  if [ -z '$1' ]; then 
    echo ' ' 
    echo -e '\033[34m Please press any key to continue... \033[0m' 
    echo ' ' 
  else
    echo -e '$1' 
  fi
  get_char
  " > /usr/local/bin/pause
  
  sudo chmod 0755 /usr/local/bin/pause
fi

check_areyousure() {
  if [ -z $tips ]; then
    unset areyousure
  fi
  while [ -z $areyousure ]
  do
    echo " "
    read -e -r -p "Are you sure? [[Y]es/[N]o/[A]llow] " input
    case $input in
      [yY][eE][sS]|[yY])
        echo -e "\033[34m Yes \033[0m"
        areyousure=1
        ;;
      
      [nN][oO]|[nN])
        echo -e "\033[34m No \033[0m"
        areyousure=0
        ;;
      
      [aA][lL][lL][oO][wW]|[aA])
        echo -e "\033[34m Allow \033[0m"
        areyousure=1
        tips=99
        ;;
      
      *)
        echo -e "\033[31m Invalid input... \033[0m"
        ;;
    esac
  done
  return $areyousure
}

check_yesorno() {
  if [ ! -z $1 ]; then
    count=$1
  fi
  #echo $count
  unset yesorno
  while [ -z $yesorno ]
  do
    echo " "
    read -e -r -p "Are you sure? [[Y]es/[N]o " input
    if [ ! -z $1 ]; then
      if [ ! -z $count ]; then
        count=$(($count-1))
      fi
      if [ $count -eq 0 ]; then
        input="yes"
      fi
    fi
    case $input in
      [yY][eE][sS]|[yY])
        echo -e "\033[34m Yes \033[0m"
        yesorno=1
        ;;

      [nN][oO]|[nN])
        echo -e "\033[34m No \033[0m"
        yesorno=0
        ;;

      *)
        echo -e "\033[31m Invalid input... \033[0m"
        ;;
    esac
  done
  return $yesorno
}

check_ssh() {
  apt install openssh-server -y
  
  num=`grep -i "PermitRootLogin yes" /etc/ssh/sshd_config |awk '{print length($0)}'|wc -L`
  if [ ! -z $num ]; then
    sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g"  /etc/ssh/sshd_config
  fi
  
  chmod 755 $HOME/.ssh/
  if [ -f "$HOME/.ssh/authorized_keys" ]; then 
    chmod 600 $HOME/.ssh/authorized_keys
  fi
  if [ -f "$HOME/.ssh/known_hosts" ]; then 
    chmod 644 $HOME/.ssh/known_hosts  
  fi
  
  systemctl restart sshd.service
}

check_init() {
  # 行号
  if [ ! -f "$HOME/.vimrc" ]; then 
    #echo "set nonu" >> $HOME/.vimrc
    echo "set nu" >> $HOME/.vimrc
    echo "set paste" >> $HOME/.vimrc
  fi
  
  # install ulimit
  if [ `ulimit -n` -lt 1048576 ]; then
    ulimit -n 1048576
    sudo sed -i "/nofile/d" /etc/security/limits.conf
    sudo echo "# ulimit
  * hard nofile 1048576
  * soft nofile 1048576
  root hard nofile 1048576
  root soft nofile 1048576
  " >> /etc/security/limits.conf
    
    sudo echo "# ulimit
  ulimit -n 1048576
  " >> /etc/profile
  fi
  
  # time adjust
  sudo apt install ntpdate -y
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  ntpdate ntp.aliyun.com
  
  # update
  sudo apt update && sudo apt upgrade -y
  
  # monitor
  sudo apt install atop htop iotop nload nethogs sysstat lrzsz -y
  sudo apt install iputils-ping gawk -y
  
  # env
  sudo apt install mesa-opencl-icd ocl-icd-opencl-dev hwloc libhwloc-dev -y
  sudo apt install gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev gdisk zhcon g++ llvm clang -y
  sudo apt install libhugetlbfs-dev -y
}

check_lock_core() {
  # 禁用自动更新
  if [ ! -z `cat /etc/apt/apt.conf.d/10periodic |grep -E "1|2|3" |head -n 1` ]; then
    cp /etc/apt/apt.conf.d/10periodic /etc/apt/apt.conf.d/10periodic.backup.`date "+%Y%m%d-%H%M%S"`
    sed -i 's/ "\([0-9]*\)";/ "0";/g' /etc/apt/apt.conf.d/10periodic
  fi
  if [ ! -z `cat /etc/apt/apt.conf.d/20auto-upgrades |grep -E "1|2|3" |head -n 1` ]; then
    cp /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.backup.`date "+%Y%m%d-%H%M%S"`
    sed -i 's/ "\([0-9]*\)";/ "0";/g' /etc/apt/apt.conf.d/20auto-upgrades
  fi
  echo -e "\033[34m 系统更新已关闭 \033[0m"

  # 当前内核
  #uname -a
  # 指定内核启动系统
  if [ -n `cat /etc/default/grub |grep $(uname -r) |awk '{print $1}'` ];then
    echo -e "\033[34m 内核已锁定为$(uname -r) \033[0m"
  else
    cp /etc/default/grub /etc/default/grub.backup.`date "+%Y%m%d-%H%M%S"`
    sed -i 's/GRUB_DEFAULT=".*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux '$(uname -r)'"/g'  /etc/default/grub
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*/GRUB_CMDLINE_LINUX_DEFAULT="iommu=pt"/g'  /etc/default/grub
    sudo update-grub
    
    check_clear_core

    # 重启标记
    mark_reboot=1
  fi
}

check_clear_core() {
  # 显示所有内核
  dpkg --get-selections | grep linux-image
  # 自动删除旧内核  apt remove --purge / apt purge 
  sudo apt remove --purge $(dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d') -y
  sudo apt autoremove -y
  dpkg --purge `sudo dpkg --get-selections | grep deinstall | cut -f1`
  sudo update-grub
}

check_reboot() {
  if [ $mark_reboot -eq 1 ]; then 
    #info 
    echo -e "\033[34m Warn:Need to restart to take effect. \033[0m"
    
    check_yesorno
    if [ $yesorno -eq 1 ]; then
      init 6
    fi
  fi
}

check_lotus_env() {
  # .lotus
  if [ ! -d "$ENV_LOTUS_PATH" ]; then
    sudo mkdir $ENV_LOTUS_PATH
  fi
  if [ ! -d "$HOME/.lotus" ]; then
    ln -s $ENV_LOTUS_PATH $HOME/.lotus
  fi
  # .lotusminer
  if [ ! -d "$ENV_LOTUS_MINER_PATH" ]; then
    sudo mkdir $ENV_LOTUS_MINER_PATH
  fi
  if [ ! -d "$HOME/.lotusminer" ]; then
    ln -s $ENV_LOTUS_MINER_PATH $HOME/.lotusminer
  fi
  # .lotusworker
  if [ ! -d "$LOTUS_WORKER_PATH" ]; then
    sudo mkdir $LOTUS_WORKER_PATH
  fi
  if [ ! -d "$HOME/.lotusworker" ]; then
    ln -s $LOTUS_WORKER_PATH $HOME/.lotusworker
  fi
  
  # tmp  proofs_parent_cache
  if [ ! -d "$TMPDIR" ]; then
    sudo mkdir $TMPDIR
  fi
  if [ ! -d "$ENV_LOTUS_ROOT/proofs_parent_cache" ]; then
    sudo mkdir $FIL_PROOFS_PARENT_CACHE
  fi
  
  # filecoin-proof-parameters  proofs
  if [ ! -d "$ENV_LOTUS_PROOFS_PATH" ]; then
    sudo mkdir $ENV_LOTUS_PROOFS_PATH
  fi
  
  if [ -z $LOTUS_PATH ]; then
    sudo echo "# lotus
  export LOTUS_PATH=$ENV_LOTUS_PATH
  export LOTUS_MINER_PATH=$ENV_LOTUS_MINER_PATH
  export LOTUS_WORKER_PATH=$LOTUS_WORKER_PATH
  export TMPDIR=$TMPDIR
  export FIL_PROOFS_PARENT_CACHE=$FIL_PROOFS_PARENT_CACHE
  " >> /etc/profile
  fi
  
  if [ -z $FIL_PROOFS_PARAMETER_CACHE ]; then
    sudo echo "# lotus-proofs
  export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_PROOFS_PATH
  export IPFS_GATEWAY=https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
  " >> /etc/profile
  fi
  
  sudo source /etc/profile
}

check_ufw() {
  sudo ufw allow 1234/tcp
  sudo ufw allow 1347/tcp
  sudo ufw allow 2345/tcp
  sudo ufw allow 2347/tcp
  sudo ufw allow 3456/tcp
  sudo ufw allow 3457/tcp
}

# gpu ----------------------------
check_gpu_num() {
  string=`lspci |grep VGA |awk '{print $5}' | tr "\n" ","`
  array=(${string//,/ }) 
  for var in ${array[@]}
  do
    echo $var
    if [ "$var" == "NVIDIA" ]; then 
      gpu_num=`nvidia-smi -q |grep 'Product Name' |awk -F : '{print $2}'|wc -l`
    else
      gpu_num=0
    fi
    echo " "
  done
}

check_gpu() {
  #查询显卡核心
  string=`lspci |grep VGA |awk '{print $5}' | tr "\n" ","`
  array=(${string//,/ }) 
  for var in ${array[@]}
  do
    echo $var
    if [ "$var" == "NVIDIA" ]; then 
      
      # install GPU driver
      sudo apt install ubuntu-drivers-common -y
      nvidia-smi
      NEEDGPU=$?
      if [ $NEEDGPU -ne 0 ]; then
        sudo ubuntu-drivers autoinstall
        
        #nvtop
        check_nvtop
        
        # 重启标记
        mark_reboot=1
      fi
    fi
    echo " "
  done
}

check_nvtop() {
  RESULT=$(nvtop --version)
  RESULT=${RESULT:13:7}
  #echo $RESULT
  RESULT=${RESULT%.*}
  echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 0.9` -eq 0 ]; then
    echo "nvtop version must >= 1.0 . "
    
    # nvtop
    os_name=$(cat /etc/issue |sed -n '1p' |sed 's/\\n \\l//g' |awk '{print $2}')
    os_name=${os_name%.*}
    if [ $os_name -ge 19.04 ]; then
      # >= 19.04
      sudo apt install nvtop -y
    else
      # < 19.04
      dpkg --configure -a
      apt install libcurl4 cmake libncurses5-dev libncursesw5-dev -y
      git clone https://github.com/Syllo/nvtop.git
      sudo mkdir -p ./nvtop/build && cd ./nvtop/build
      cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True
      make && sudo make install
      cd ../..
      rm -rf ./nvtop
    fi
    
    # check
    nvtop --version
  fi
  echo " "
  return 1
}

check_cuda() {
  # # install cuda runfile
  rm -rf ./cuda && mkdir ./cuda && cd ./cuda
  wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run
  sudo sh cuda_11.0.3_450.51.06_linux.run
  rm ./cuda_11.0.3_450.51.06_linux.run
  cd .. && rm -rf ./cuda 
}

# dev ----------------------------
check_go() {
  RESULT=$(go version)
  RESULT=${RESULT:13:7}
  #echo $RESULT
  RESULT=${RESULT%.*}
  echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 1.13` -eq 0 ]; then
    echo "go version must > 1.13 . "
    ## go install
    #sudo add-apt-repository ppa:longsleep/golang-backports -y
    #sudo apt-get update
    #sudo apt install golang-go -y
    
    ## amd64
    sudo apt remove golang-go -y
    wget https://golang.google.cn/dl/go1.15.10.linux-amd64.tar.gz
    tar xfz go1.15.10.linux-amd64.tar.gz -C /usr/local
    RESULT=$(go version)
    if [ -z $RESULT ]; then
      echo "
  export PATH=/usr/local/go/bin:$PATH
  " >> ~/.bashrc
      source ~/.bashrc
    fi
    
    # check
    go version && go env
  fi
  echo " "
  return 1
}

check_rustup() {
  RESULT=$(rustup --version)
  RESULT=${RESULT:7:7}
  #echo $RESULT
  RESULT=${RESULT%.*}
  echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 1.20` -eq 0 ]; then
    echo "rustup version must > 1.20 . "
    # rustup env config
    if [ ! -s "$HOME/.rustup/config" ]; then 
      echo '
      [source.crates-io]
      registry = "https://github.com/rust-lang/crates.io-index"
      replace-with = 'tuna'
      [source.tuna]
      registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
      ' > $HOME/.rustup/config
    fi
    # rustup install
    apt install libcurl4 curl -y
    curl https://sh.rustup.rs -sSf | sh -s -- -y && sudo source $HOME/.cargo/env
    
    # check
    rustup --version
  fi
  echo " "
  return 1
}

check_lotus_dev() {
  
  if [ -z $GOPROXY ]; then
    sudo echo "# GOPROXY
  export GO111MODULE=on
  export GOPROXY=https://goproxy.cn
  export GOPATH=$HOME/gopath
  " >> /etc/profile
  fi
  
  if [ -z $RUSTUP_DIST_SERVER ]; then
    sudo echo "# RUST
  export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
  export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
  " >> /etc/profile
  fi
  
  if [ -z $RUSTUP_DIST_SERVER ]; then
    sudo echo "# Code Build env
  export FFI_BUILD_FROM_SOURCE=1
  " >> /etc/profile
  fi
  
  sudo source /etc/profile
  
  # dev env go rust
  check_go
  check_rustup
  
}

# --- ----------------------------

check_ssh
check_areyousure
if [ $areyousure -eq 1 ]; then
  check_init
  check_lotus_env
  check_ufw
  
  # dev
  check_lotus_dev
  
  # gpu
  check_gpu_num
  if [ $gpu_num -ne 0]; then
    check_gpu
    #check_nvtop
    #check_cuda
  fi

  # lock core
  check_lock_core
  
  # reboot
  check_reboot
fi