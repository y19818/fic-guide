# ceph 集群部署

## 要求

* Python 3
* Systemd
* Docker
* 时间同步（NTP）
* 硬盘支持LVM2

## 安装CEPHDM

### 使用curl安装
* 使用curl获取独立脚本的最新版本:    
	

```bash
# curl --silent --remote-name --location 
```

```bash
# https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
```

使cephadm脚本可执行：

```bash
# chmod +x cephadm
```

该脚本可以直接从当前目录运行:
	
```bash
# ./cephadm <arguments...>
```

* 安装提供cephadm用于Octopus发行版命令的软件包，请运行以下命令：
	
```bash
./cephadm install
./cephadm add-repo --release octopus
```

`cephadm`通过运行`which`以下命令确认该路径现在位于您的PATH中：

```bash
# which cephadm
```

成功的命令将返回以下内容：`which cephadm`

```bash
/usr/sbin/cephadm
```

### 在Ubuntu中直接安装：

```bash
# apt install -y cephadm
```


## 引导新集群

### 运行BOOTSTRAP命令

```bash 
# cephadm bootstrap --mon-ip *<mon-ip>* 
```

该命令将：

- 在本地主机上为新集群创建监视和管理器守护程序。
- 为Ceph集群生成一个新的SSH密钥，并将其添加到root用户的`/root/.ssh/authorized_keys`文件中。
- 将最小配置文件写入`/etc/ceph/ceph.conf`。与新群集通信时需要此文件。
- 向写入`client.admin`管理（特权！）秘密密钥的副本`/etc/ceph/ceph.client.admin.keyring`。
- 将公用密钥的副本写入`/etc/ceph/ceph.pub`。

## 启用CEPH CLI

``` bash
# cephadm shell
# cephadm add-repo --release octopus
# cephadm install ceph-common
```

通过以下`ceph`命令确认命令可以连接到集群及其状态：

```bash
# ceph status
```

## 添加主机

要将每个新主机添加到群集，请执行两个步骤：

1. 在新主机的根用户`authorized_keys`文件中安装群集的公共SSH密钥：

   ```bash
   # ssh-copy-id -f -i /etc/ceph/ceph.pub root@*<new-host>*
   ```

2. 告诉Ceph，新节点是集群的一部分：

   ```bash
   # ceph orch host add *newhost*
   ```

## 添加存储

```bash
# ceph orch apply osd --all-available-devices
```

