# Distributed-minio set-up
##### environment -- CentOS Linux release 7.4.1708

Assume there are 3 servers, server1, server2, server3.
We set 4 disks on each of the server.

Download `distributed.sh` to each of the 3 servers, configure the ip address to your's.
```bash
wget https://raw.githubusercontent.com/eopXD/distributed-minio-with-varnish/minio/master/distributed.sh 
```
Let the script be executable.
```bash
sudo chmod +x distributed.sh
```
Before you run the script...
- check [firewall](https://github.com/eopXD/distributed-minio-with-varnish/wiki/Configure-firewall) is opened for connection
- check if the servers' [system time](https://github.com/eopXD/distributed-minio-with-varnish/wiki/Sync-system-time) is synchronized.

