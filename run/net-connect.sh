#!/bin/bash

#> vi lotus/build/bootstrap/bootstrappers.pi

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


if [ -z $1 ]; then 
  if [ -z $ENV_LOTUS_NETWORK ]; then
    echo -e "\033[31m TIPS: LOTUS_NETWORK is empty. \033[0m"
    pause
  elif [[ "$ENV_LOTUS_NETWORK" == "filecoin" ]]; then
    bootstrap="
  /dns4/bootstrap-0.mainnet.filops.net/tcp/1347/p2p/12D3KooWCVe8MmsEMes2FzgTpt9fXtmCY7wrq91GRiaC8PHSCCBj
  /dns4/bootstrap-1.mainnet.filops.net/tcp/1347/p2p/12D3KooWCwevHg1yLCvktf2nvLu7L9894mcrJR4MsBCcm4syShVc
  /dns4/bootstrap-2.mainnet.filops.net/tcp/1347/p2p/12D3KooWEWVwHGn2yR36gKLozmb4YjDJGerotAPGxmdWZx2nxMC4
  /dns4/bootstrap-3.mainnet.filops.net/tcp/1347/p2p/12D3KooWKhgq8c7NQ9iGjbyK7v7phXvG6492HQfiDaGHLHLQjk7R
  /dns4/bootstrap-4.mainnet.filops.net/tcp/1347/p2p/12D3KooWL6PsFNPhYftrJzGgF5U18hFoaVhfGk7xwzD8yVrHJ3Uc
  /dns4/bootstrap-5.mainnet.filops.net/tcp/1347/p2p/12D3KooWLFynvDQiUpXoHroV1YxKHhPJgysQGH2k3ZGwtWzR4dFH
  /dns4/bootstrap-6.mainnet.filops.net/tcp/1347/p2p/12D3KooWP5MwCiqdMETF9ub1P3MbCvQCcfconnYHbWg6sUJcDRQQ
  /dns4/bootstrap-7.mainnet.filops.net/tcp/1347/p2p/12D3KooWRs3aY1p3juFjPy8gPN95PEQChm2QKGUCAdcDCC4EBMKf
  /dns4/bootstrap-8.mainnet.filops.net/tcp/1347/p2p/12D3KooWScFR7385LTyR4zU1bYdzSiiAb5rnNABfVahPvVSzyTkR
  /dns4/node.glif.io/tcp/1235/p2p/12D3KooWBF8cpp65hp2u9LK5mh19x67ftAam84z9LsfaquTDSBpt
  "
  elif [[ "$ENV_LOTUS_NETWORK" == "filecash" ]]; then
    bootstrap="
  /dns4/a1.filecoincash.com/tcp/8911/p2p/12D3KooWMAQi4qTg69a683R1Dvz2XzKhjTCHq8uuwd5PkhM45vff
  /dns4/a2.filecoincash.com/tcp/8911/p2p/12D3KooWEhptW8M7NDR4Um9fgVVck42YoTbHDBE3qF3iLonCkPn9
  /dns4/a3.filecoincash.com/tcp/8911/p2p/12D3KooWB2Pim8E1aj9DhcccJSDk93pJYpmm5LAtuinLXVVttYZo
  /dns4/a5.filecoincash.com/tcp/8911/p2p/12D3KooWJibEA5yyFxPq2NHkP9aaiPLfMTbXhUqtRtwbTU4gMaBB
  /dns4/a6.filecoincash.com/tcp/8911/p2p/12D3KooWFE5TZk8BANmY6w3WXD2gPfbfkaRnZNFtao1unaXYg47E
  /dns4/a8.filecoincash.com/tcp/8911/p2p/12D3KooWADZTsmBWQuZQjyruSpVNoX4XB1JTXFWtsVMz8bwhtGUr
  "
  elif [[ "$ENV_LOTUS_NETWORK" == "filestar" ]]; then
    bootstrap="
  /dns4/seed.filestar.net/tcp/51024/p2p/12D3KooWRWpnA6KMpoqXgXB1Ssc77B6TcEWJcNFtMqSYgS2UumT9
  /dns4/seed.filestar.net/tcp/51024/p2p/12D3KooWF15XCfM8XNLANFfZZQaj89xtgrroTZ1GAXpfEgd8mAYp
  /dns4/seed.filestar.net/tcp/51024/p2p/12D3KooWDfiABDDLFsEUNrNpSvsWELRoiXxEenyXSsjxsSNUyFTd
  /dns4/seed.filestar.net/tcp/51024/p2p/12D3KooW9tfsWnw7vZUzX6Bie12YcdyVuj7enskHKUTkotZkfnox
  /dns4/seed.filestar.net/tcp/51024/p2p/12D3KooWNFBi3Ysg8cH8r6xHVzSLMFjKx2Ee14PzYts8qxymKPca
  "
  else
    bootstrap="$1"
  fi
else 
  bootstrap="$1"
fi

for i in $bootstrap
do 
  if [ ! -z $i ]; then
    echo $i
    lotus net connect $i
  fi
done
