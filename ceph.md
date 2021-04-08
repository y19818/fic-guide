# ceph 集群部署

## 要求

* Python 3
* Systemd
* Docker（如果没有提前完成安装需要在cephadm install那一步显示失败之后执行docker的sh安装脚本）
```bash 
# curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```
提前使用sh脚本会对环境产生影响导致cephadm install失败
* 时间同步（NTP）
* 硬盘支持LVM2

## 安装CEPHADM

### 使用curl安装
* 使用curl获取独立脚本的最新版本:    
	

```bash
$ curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
```

使cephadm脚本可执行：

```bash
$ chmod +x cephadm
```

该脚本可以直接从当前目录运行:
	
```bash
$ ./cephadm <arguments...>
```

* 安装提供cephadm用于Octopus发行版命令的软件包，请运行以下命令：
	
```bash
$ ./cephadm install
$ ./cephadm add-repo --release octopus
```
PS:如果出现key验证错误需要添加 release.asc 内的密钥：

```bash
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
```

`cephadm`通过运行`which`以下命令确认该路径现在位于您的PATH中：

```bash
$ which cephadm
```

成功的命令将返回以下内容：`which cephadm`

```bash
/usr/sbin/cephadm
```

### 在Ubuntu中直接安装：

```bash
$ apt install -y cephadm
```


## 引导新集群

### 运行BOOTSTRAP命令

```bash 
$ cephadm bootstrap --mon-ip *<mon-ip>* 
```

该命令将：

- 在本地主机上为新集群创建监视和管理器守护程序。
- 为Ceph集群生成一个新的SSH密钥，并将其添加到root用户的`/root/.ssh/authorized_keys`文件中。
- 将最小配置文件写入`/etc/ceph/ceph.conf`。与新群集通信时需要此文件。
- 向写入`client.admin`管理（特权！）秘密密钥的副本`/etc/ceph/ceph.client.admin.keyring`。
- 将公用密钥的副本写入`/etc/ceph/ceph.pub`。

## 启用CEPH CLI

``` bash
$ cephadm shell
$ cephadm add-repo --release octopus
$ cephadm install ceph-common
```

通过以下`ceph`命令确认命令可以连接到集群及其状态：

```bash
$ ceph status
```

## 添加主机

要将每个新主机添加到群集，请执行两个步骤：

1. 在新主机的根用户`authorized_keys`文件中安装群集的公共SSH密钥：

   ```bash
   $ ssh-copy-id -f -i /etc/ceph/ceph.pub root@*<new-host>*
   ```
需要提前在/etc/hosts和/etc/hostname修改需要添加的host名称和内网IP地址

2. 告诉Ceph，新节点是集群的一部分：

   ```bash
   $ ceph orch host add *newhost*
   ```
这一步无法将节点设置成mon 需要再执行下列指令：
   ```bash
   $ ceph orch apply mon *<host1,host2,host3,...>*
   ```
3. 查看集群当前服务分布：
   ```bash
   $ ceph orch ps
   ```
## 添加存储
将新磁盘设备加入集群：

```bash
$ ceph orch apply osd --all-available-devices
```

查看设备信息：

```bash
$ ceph orch device ls
```
查看挂载好的osd信息：

```bash
$ ceph osd df
```

## 其他节点安装ceph-common
为了在其他节点也能够直接访问Ceph集群，我们需要在其他节点上也安装ceph-common。
cephadm以外的其他节点执行:
```bash
$ mkdir ~/cephadmin
$ mkdir /etc/ceph
```

从cephadm节点以拷贝cephadm，ceph集群配置文件，ceph客户端管理员密钥到其他节点：

```bash
$ scp ~/cephadmin/cephadm root@manager01.xxx.com:~/cephadmin/
$ scp ~/cephadmin/cephadm root@manager02.xxx.com:~/cephadmin/
$ scp ~/cephadmin/cephadm root@worker01.xxx.com:~/cephadmin/

$ scp /etc/ceph/ceph.conf root@manager01.xxx.com:/etc/ceph/
$ scp /etc/ceph/ceph.conf root@manager02.xxx.com:/etc/ceph/
$ scp /etc/ceph/ceph.conf root@worker01.xxx.com:/etc/ceph/

$ scp /etc/ceph/ceph.client.admin.keyring root@manager01.xxx.com:/etc/ceph/
$ scp /etc/ceph/ceph.client.admin.keyring root@manager02.xxx.com:/etc/ceph/
$ scp /etc/ceph/ceph.client.admin.keyring root@worker01.xxx.com:/etc/ceph/
```
其他节点执行:
```bash
$ cd ~/cephadmin
$ ./cephadm install ceph-common
$ ceph -s
```

# 部署cephfs服务
## 创建cephfs
任意节点上执行:
```bash
#创建一个用于cephfs数据存储的池，相关参数自行参阅社区文档。
$ ceph osd pool create cephfs_data 64 64
#创建一个用于cephfs元数据存储的池
$ ceph osd pool create cephfs_metadata 32 32
#创建一个新的fs服务，名为cephfs
$ ceph fs new cephfs cephfs_metadata cephfs_data
#查看集群当前的fs服务
$ ceph fs ls
#设置cephfs最大mds服务数量
$ ceph fs set cephfs max_mds 3
#部署3个mds服务
$ ceph orch apply mds cephfs --placement="3 node1 node2 node3"
#查看mds服务是否部署成功
$ ceph orch ps --daemon-type mds
```

## 挂载cephfs到各节点本地目录
在各个节点执行：
```bash
$ mkdir /mnt/mycephfs/
$ mount -t ceph :/ /mnt/mycephfs -o name=admin
```
