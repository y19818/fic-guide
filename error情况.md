## 报错
### 更新PC1状态报错
```
2021-07-13T05:11:32.048Z	DEBUG	advmgr	sector-storage/sched.go:483	SCHED Acceptable win: [[4 5]]
2021-07-13T05:11:32.050Z	DEBUG	advmgr	sector-storage/sched.go:506	SCHED try assign sqi:0 sector 2 to window 4
2021-07-13T05:11:32.050Z	DEBUG	advmgr	sector-storage/sched.go:513	SCHED ASSIGNED sqi:0 sector 2 task seal/v0/precommit/1 to window 4
2021-07-13T05:11:32.052Z	DEBUG	advmgr	sector-storage/sched.go:528	SCHED ASSIGNED sqi:0 sector 2 task seal/v0/precommit/1 to window 4
run task worker id: aee85c47-d8c7-4fc2-baad-ff0090da67ba
2021-07-13T05:11:32.052Z	DEBUG	advmgr	sector-storage/sched_worker.go:370	assign worker sector 2
2021-07-13T05:11:32.054Z	DEBUG	advmgr	sector-storage/sched.go:368	SCHED 0 queued; 6 open windows
2021-07-13T05:11:32.079Z	DEBUG	stores	stores/index.go:397	not allocating on 6dc4e4db-a354-4b20-b29a-60f373eb90b3, didn't receive heartbeats for 24h14m49.693916381s
2021-07-13T05:11:32.086Z	WARN	advmgr	sector-storage/manager_calltracker.go:149	canceling started (not running) work seal/v0/precommit/1([[{"ID":{"Miner":625063,"Number":2},"ProofType":6},"TYzsaLgE4OgsHPmsarXjBJpQHE6GQAJoktjGYY48jV8=",[{"Size":17179869184,"PieceCID":{"/":"baga6ea4seaqg2nsld34emra2ljfgrbrdcswmbjdpaftrpzjuipudt3w7qpbikpa"}}]]])
2021-07-13T05:11:32.086Z	DEBUG	advmgr	sector-storage/sched_worker.go:280	task done	{"workerid": "aee85c47-d8c7-4fc2-baad-ff0090da67ba"}
2021-07-13T05:11:32.086Z	DEBUG	advmgr	sector-storage/sched.go:368	SCHED 0 queued; 6 open windows
2021-07-13T05:11:32.089Z	ERROR	evtsm	go-statemachine@v0.0.0-20200925024713-05bd7c71fbfe/machine.go:83	Executing event planner failed: running planner for state PreCommit1 failed:
    github.com/filecoin-project/lotus/extern/storage-sealing.(*Sealing).plan
        /mnt/jenkins/workspace/FIC-Intel-Rel1.2_github/lotus/extern/storage-sealing/fsm.go:218
  - planner for state PreCommit1 received unexpected event sealing.SectorRetrySealPreCommit1 ({User:{}}):
    github.com/filecoin-project/lotus/extern/storage-sealing.planOne.func1
        /mnt/jenkins/workspace/FIC-Intel-Rel1.2_github/lotus/extern/storage-sealing/fsm.go:523
```
