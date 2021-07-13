#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


echo -e "\033[34m `${EXE_LOTUS} wallet list` \033[0m"
echo " "

while [ -z $owner ]
do
  read -e -p "  please input owner:" owner
  if [ -z $owner ]; then
    # log
    echo -e "\033[34m `${EXE_LOTUS} wallet default` \033[0m"

    owner=`${EXE_LOTUS} wallet default`
  elif ! echo $owner | grep -q '^f3$' ; then
    unset owner
  fi
done
echo -e "\033[34m  $owner \033[0m"
echo " "

while true; do
  
  local_msg_num=`${EXE_LOTUS} mpool pending --local |wc -l`
  nonce=$(${EXE_LOTUS} mpool pending --local | jq '.[]|.Nonce' | head -1)
  if [ ! -z $nonce ]; then 
    echo -e "\033[34m  nonce=$nonce \033[0m"
    
    GasLimit=$(${EXE_LOTUS} mpool pending --local | jq '.[]|.GasLimit' | head -1)
    GasFeeCap=$(${EXE_LOTUS} mpool pending --local | jq '.[]|.GasFeeCap' | head -1)
    GasPremium=$(${EXE_LOTUS} mpool pending --local | jq '.[]|.GasPremium' | head -1)
    GasPremium=`echo $GasPremium | sed 's/\"//g'`
    GasFeeCap=`echo $GasFeeCap | sed 's/\"//g'`
    
    GasLimitFee=`echo "$GasLimit * 1.1" | bc`
    GasPremiumFee=`echo "$GasPremium * 1.3" | bc`
    GasFeeCapFee=`echo "$GasFeeCap * 1.25" | bc`
    
    # log
    echo -e "\033[34m  ${EXE_LOTUS} mpool replace --gas-feecap ${GasFeeCapFee%.*} --gas-premium ${GasPremiumFee%.*} --gas-limit ${GasLimitFee%.*} ${owner} ${nonce} \033[0m"
    
    ${EXE_LOTUS} mpool replace --gas-feecap ${GasFeeCapFee%.*} --gas-premium ${GasPremiumFee%.*} --gas-limit ${GasLimitFee%.*} ${owner} ${nonce}
    
  fi

  echo "sleep 30"
  sleep 30
  echo " "
  
done
