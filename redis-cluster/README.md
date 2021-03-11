Redis Cluster
==========================

### 生成集群配置
```
./redis-cluster-config.sh
```

### 启动Docker Redis Cluster
```
docker-compose up -d
```

### 创建集群
```
$ docker exec -it redis7001 redis-cli -p 7001 --cluster create 192.168.0.9:7001 192.168.0.9:7002 192.168.0.9:7003 192.168.0.9:7004 192.168.0.9:7005 192.168.0.9:7006 --cluster-replicas 1
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 192.168.0.9:7005 to 192.168.0.9:7001
Adding replica 192.168.0.9:7006 to 192.168.0.9:7002
Adding replica 192.168.0.9:7004 to 192.168.0.9:7003
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18 192.168.0.9:7001
   slots:[0-5460] (5461 slots) master
M: 463dc60882ef73607134e47b1fd7b5a2311a49cb 192.168.0.9:7002
   slots:[5461-10922] (5462 slots) master
M: 9b614efc00c505d4d54434e420215b9e94349189 192.168.0.9:7003
   slots:[10923-16383] (5461 slots) master
S: af0366c9b2a60c827a8826aa6f8e563521c655ec 192.168.0.9:7004
   replicates 9b614efc00c505d4d54434e420215b9e94349189
S: 7168a4d7242f5f1f32959a92173c7b075be698fd 192.168.0.9:7005
   replicates 6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18
S: 6c2b1c30fbafa630fb0fa030a6584179158125f7 192.168.0.9:7006
   replicates 463dc60882ef73607134e47b1fd7b5a2311a49cb
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 192.168.0.9:7001)
M: 6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18 192.168.0.9:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: af0366c9b2a60c827a8826aa6f8e563521c655ec 192.168.0.9:7004
   slots: (0 slots) slave
   replicates 9b614efc00c505d4d54434e420215b9e94349189
S: 7168a4d7242f5f1f32959a92173c7b075be698fd 192.168.0.9:7005
   slots: (0 slots) slave
   replicates 6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18
M: 9b614efc00c505d4d54434e420215b9e94349189 192.168.0.9:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
M: 463dc60882ef73607134e47b1fd7b5a2311a49cb 192.168.0.9:7002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 6c2b1c30fbafa630fb0fa030a6584179158125f7 192.168.0.9:7006
   slots: (0 slots) slave
   replicates 463dc60882ef73607134e47b1fd7b5a2311a49cb
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

### 测试Redis
```
docker exec -it redis7001 redis-cli -h 192.168.0.9 -p 7005 ping
PONG
```

### 查看集群状态

#### 查看集群信息
```
$ docker exec -it redis7001 bash
root@8543131f958e:/data# redis-cli -p 7001
127.0.0.1:7001> cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:224
cluster_stats_messages_pong_sent:238
cluster_stats_messages_sent:462
cluster_stats_messages_ping_received:233
cluster_stats_messages_pong_received:224
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:462
```

#### 查看集群节点
```
192.168.0.9:7002> cluster nodes
6c2b1c30fbafa630fb0fa030a6584179158125f7 192.168.0.9:7006@17006 slave 463dc60882ef73607134e47b1fd7b5a2311a49cb 0 1615433844504 2 connected
9b614efc00c505d4d54434e420215b9e94349189 192.168.0.9:7003@17003 master - 0 1615433843998 3 connected 10923-16383
463dc60882ef73607134e47b1fd7b5a2311a49cb 192.168.0.9:7002@17002 myself,master - 0 1615433844000 2 connected 5461-10922
6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18 192.168.0.9:7001@17001 master - 0 1615433844000 1 connected 0-5460
7168a4d7242f5f1f32959a92173c7b075be698fd 192.168.0.9:7005@17005 slave 6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18 0 1615433843000 1 connected
af0366c9b2a60c827a8826aa6f8e563521c655ec 192.168.0.9:7004@17004 slave 9b614efc00c505d4d54434e420215b9e94349189 0 1615433844000 3 connected
```

#### 查看集群Slots
```
192.168.0.9:7002> cluster slots
1) 1) (integer) 10923
   2) (integer) 16383
   3) 1) "192.168.0.9"
      2) (integer) 7003
      3) "9b614efc00c505d4d54434e420215b9e94349189"
   4) 1) "192.168.0.9"
      2) (integer) 7004
      3) "af0366c9b2a60c827a8826aa6f8e563521c655ec"
2) 1) (integer) 5461
   2) (integer) 10922
   3) 1) "192.168.0.9"
      2) (integer) 7002
      3) "463dc60882ef73607134e47b1fd7b5a2311a49cb"
   4) 1) "192.168.0.9"
      2) (integer) 7006
      3) "6c2b1c30fbafa630fb0fa030a6584179158125f7"
3) 1) (integer) 0
   2) (integer) 5460
   3) 1) "192.168.0.9"
      2) (integer) 7001
      3) "6bc7e6d9c29f8ac9803d2516644c68ebf23f8f18"
   4) 1) "192.168.0.9"
      2) (integer) 7005
      3) "7168a4d7242f5f1f32959a92173c7b075be698fd"
```


### 测试集群读写
```
$ docker exec -it redis7001 redis-cli -h 192.168.0.9 -p 7003 -c
192.168.0.9:7003> set name admin
-> Redirected to slot [5798] located at 192.168.0.9:7002
OK
192.168.0.9:7002> get name
"admin"
```

```
$ docker exec -it redis7001 redis-cli -h 192.168.0.9 -p 7001 -c
192.168.0.9:7001> get name
-> Redirected to slot [5798] located at 192.168.0.9:7002
"admin"
```