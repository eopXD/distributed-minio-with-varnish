# Varnish set-up
##### environment -- CentOS Linux release 7.4.1708

Assume there are 3 servers, server1, srever2, server3/

[Install Varnish](https://github.com/eopXD/distributed-minio-with-varnish/wiki/Install-Varnish) on one of the server. Usually on the one with largest RAM, where VArnish needs space for caching.

Copy `default.vcl` to `/etc/varnish/default.vcl` and configure the server ip and port.

(For port minio's default is 9000)
```bash
wget https://raw.githubusercontent.com/eopXD/distributed-,inio-with-varnish/varnish/default.vcl
```
2 methods is declared in `vcl_init`. Weighted load-balancing `foo` and Round-robin scheduling `bar`.

In `vcl_recv`, **Un-hashtag** the one you want.

In `/etc/varnish/varnish.param` change the listening port to 80, so Varnish will start to listen to HTTP requests recieved. 
```
VARNISH_LISTEN_PORT=80
```

(Be reminded that the admin listen address is defaulted `127.0.0.1:6082`)

For health-checking for backend server, [see here](https://github.com/eopXD/distributed-minio-with-varnish/wiki/varnish-health-check). 
