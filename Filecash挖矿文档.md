## Filecash挖矿文档

### 搭建编译环境

1. 安装 go 语言环境以及编译所需要的依赖库

   ```bash
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install golang-go gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev -y
   ```

   添加环境变量：vim ~/.bashrc

   ```bash
    export GOROOT=/usr/local/go
    export GOBIN=$GOROOT/bin
    export GOPKG=$GOROOT/pkg/tool/linux_amd64
    export GOARCH=amd64
    export GOOS=linux
    export GOPATH=/golang/
    export PATH=$PATH:$GOBIN:$GOPKG
   ```

   运行下面命令使环境变量生效

   ```bash
   source ~/.bashrc
   ```

2. 安装 Rust 编译环境

   ```bash
   curl https://sh.rustup.rs -sSf | sh
   ```

   上面脚本会让你选择安装方式，直接选择 1, 回车。安装完成之后运行下面脚本使 rust 环境变量生效：

   ```bash
   source $HOME/.cargo/env
   ```

   

### 编译 lotus 源码

Github直接下载可执行文件：https://github.com/filecash/lotus/releases/tag/filecash-v0.9.0-fix4

```bash
Support OS: Ubuntu 18.04 LTS
wget https://snapshot.file.cash/amd-filecash-v0.9.0-fix4.tar.gz && tar -zxvf amd-filecash-v0.9.0-fix4.tar.gz
wget https://snapshot.file.cash/intel-filecash-v0.9.0-fix4.tar.gz && tar -zxvf intel-filecash-v0.9.0-fix4.tar.gz

One-click Compile Script: https://github.com/filecash/lotus_builder
```



### 启动lotus daemon

在启动之前需要准备一块大容量磁盘用来作为lotus的数据储存盘和lotus-miner的挖矿磁盘，本文使用的磁盘是filecoin_1。

将磁盘挂载之后需要使用`chown` 指令修改权限，在之后运行程序时可以直接使用Ubuntu用户启动。

需要修改的环境变量（lotus、lotus-miner、lotus- worker）

```bash
FIL_PROOFS_PARAMETER_CACHE=/filecoin_1/filecoin-proof-parameters LOTUS_PATH=/filecoin_1/data/lotus 
LOTUS_MINER_PATH=/filecoin_1/data/lotus-miner 
FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1 
FIL_PROOFS_USE_GPU_TREE_BUILDER=1 
RUST_LOG=Trace 
FIL_PROOFS_MAXIMIZE_CACHING=1
BELLMAN_CUSTOM_GPU="GeForce RTX 2080 Ti:4352"
```

第一次同步节点直接使用官方快照节点：

`lotus daemon --import-snapshot https://snapshot.file.cash/fic-snapshot-latest.car`

第一次同步完成之后可以直接使用命令运行：

`nohup lotus daemon > daemon.log 2>&1 &`

### 初始化矿工

1. 创建钱包：

   `lotus wallet new bls`

   输出钱包地址：f3wwtiufmkvkoc4eq67txiruxv7kfgumhljyqfozzw2opiihj6uy2tnr773zvxtdwpiimlc2qbhxaqeispgilq

2. 充值，如果只是创建矿工的话，充值 1 个FIL 足够了。

3. 创建矿工 `lotus-miner init --owner=<address> # e.g lotus-miner init --owner=f3wwtiufmkvkoc4eq67txiruxv7kfgumhljyqfozzw2opiihj6uy2tnr773zvxtdwpiimlc2qbhxaqeispgilq`

### 修改lotus-miner配置

miner 的配置文档在 `$LOTUS_MINER_PATH/config.toml`，如果你是跑单节点的话，那么无需修改配置文档，但是如果你是需要跑集群的话， 那么你需要修改下面几个地方：

1. 修改 API 连接配置，主要用于 worker 连接 miner。

   ```bash
   # e.g
    [API]
    ListenAddress = "/ip4/xxx.xxx.xxx.xxx/tcp/2345/http"
    RemoteListenAddress = "xxx.xxx.xxx.xxx:2345"
   ```

   

2. 修改 `[Storage]` 选项，将密封相关的任务全部分配给 worker 去做。

```bash
 [Storage]
 #  ParallelFetchLimit = 10
 AllowAddPiece = false
 AllowPreCommit1 = false
 AllowPreCommit2 = false
 AllowCommit = false
 #  AllowUnseal = true
```

### 启动lotus-miner

```bash
lotus-miner run > miner.log 2>&1 &
```

### 启动lotus-worker

1. 拷贝 miner 的 api 和 token 文件到 `$LOTUS_MINER_PATH` 目录下。

2. 启动 worker 程序，可以根据传入不同的参数来定义 worker 的类型。

   - 启动一个只接 P1 任务的 worker

     ```bash
      lotus-worker run --listen=11.11.11.11:2345 --precommit1=true --precommit2=false -commit=false
     ```

     注意： `11.11.11.11` 需要替换成你 worker 的内网 IP 地址。

   - 启动一个可以同时接 P1 和 P2 任务的 worker

     ```bash
      lotus-worker run --listen=11.11.11.11:2345 --precommit1=true --precommit2=true -commit=false
     ```

   - 启动一个只接 C2 任务的 worker

     ```bash
      lotus-worker run --listen=11.11.11.11:2345 --precommit1=false --precommit2=false -commit=true
     ```

worker 启动之后会自动通过我们在 `lotus-worker` 脚本里配置的 API 信息，连接到 miner 领取任务，你可以通过下面的命令查看已经连接到 miner 的 worker 列表。

```bash
lotus-miner sealing workers
```

Worker 也启动了，那么接下来我们就可以开始质押扇区，启动挖矿了。

```bash
lotus-miner sectors pledge # 质押一个随机数据的扇区，开始密封
```

查询当前集群的任务分配情况：

```bash
lotus-miner sealing jobs
```