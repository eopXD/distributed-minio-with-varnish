# A survey on Minio with Varnish

## Introduction

This is a documentation for what we had surveyed on **Minio** & **Varnish** as a storage system for **online course platform** for the Digital Learning Center (DLC) of National Taiwan University. This documentation is filed for future storage system selection.

## DLC requirements

- Approximate user: the whole school(30,000) * 5% = 1,500 users
- A S3 compatible storage system, which is able to store videos and provide **video-streaming** service.
- **Load-balancing** for multiple users, to deal with peak browsing circumstances (during exam weeks).

## Proposed solution

We tried to reach the requirement through combining Minio and Varnish.

We selected Minio because it is a **free open-source S3 compatible storage system**. It is light-weighted and easy to install. It has been developed recently and **still in progress**, so functions maynot act as expected and frequent update may cause us need to adjust settings.

### Structures of Minio

Minio is trying to reach for simple but powerful goals.

- A easy set-up storage system dedicated for a single user.
- Support distributed system for data to be secured with abundant backup.

Minio system recognize nodes, it is originally designed for one server to act as one node. So if we want to set-up a distributed minio that fits its original purpose, we suppose to have multiple servers and storages behind the servers.

Minio promises data availability by sacraficing storage space and creating parity drives. It uses **Reed-Solomon encoding** to maintain availability when under half of the servers are down. Also it prevents **Bit-rot** of storage devices by certain extra coding. 

So with [Reed-Solomon](https://www.cs.cmu.edu/~guyb/realworld/reedsolomon/reed_solomon_codes.html), data are all distributed partly on each node. **This means that all the I/O have to be done by server comunicating with each other**.

So now assume we have 6 nodes (A, B, C, D, E, F) on 3 servers. (2 nodes each) If we want to access uploaded data through A, distributed-minio supports data availability when at least half of the drive is online, so if there are equal or more than 3 servers online (including A), then A will communicate with the other online servers and recover the Reed-Solomon encoded data. Our main concern is the communication between server cannot be avoid in disrtibuted-minio. This communication will take network bandwidth and delay download speed compare to a single node minio or other single point database.

![minio structure](https://images.ctfassets.net/le3mxztn6yoo/38fEm2fQRaMy88M6mIkM0Y/755670b7ffb4af158f91f3bd92893b12/minio.png)

The interface [`ObjectLayer`](https://github.com/minio/minio/blob/master/cmd/object-api-interface.go) is responsible for the actual persistence of objects and is implemented by

- [`fsObjects`](https://github.com/minio/minio/blob/master/cmd/fs-v1.go) 
- [`xlObjects`](https://github.com/minio/minio/blob/master/cmd/xl-v1.go)
- [`GatewayLayer`](https://github.com/minio/minio/blob/master/cmd/gateway-router.go)

### fsObjects

`fsObjects` is responsible for the implementation of the File System mode of operation of Minio. In this mode all content that is stored under a single directory path is represented as an object store.

Buckets are top-level directories and new objects that are uploaded are stored as regular files under their respective path with which they are uploaded. Listing operations will list the local directory structure and return the results in batches. Multipart uploads construct the individual parts into a single concatenated file and move it in place once completed.

Get and put operations either read or write to the correspondingly underlying file and deal with the contents according to the S3 API protocol.

### xlObjects

`xlObjects` is responsible for the implementation of the Erasure Coding mode of operation of Minio. In this mode objects are written across either multiple disks or multiple servers with additional error correction information that protects against failure of one or more disks or servers.

### Minio + Varnish

We planned to approach load-balancing by adding Varnish on to one of the Minio server, where Varnish will redirect the request to other server via internet connection with the other servers. Varnish contains functions such as health check, caching. Where we thought to be useful to be added to a distributed system.

## Evaluation

We originally chose Minio because it supports *distributing system*, and thought that by setting up *reverse proxy* throught Varnish, we can have a load-balanced system through this approach. However there are some reasons that distributed-minio may not be a good solution.

1. Since Minio is encoded with Reed-Solomon, so any I/O have to be done by servers comunicating with each other, that means that there is requirements for inter-connections between the servers. This contradicts with the original purpose where we want a **load-balancing** system.

2. Minio does data redundency to ensure data availability. **However we bought good NAS as our storage device, and the NAS do RAID 1+0 for the data**. There is no need for a another security on data availability. So with distributed-minio it may seem to be a waste of storage space.

3. Although we achieved some kind of load-balancing with Varnish. All requests still goes back from the original access point. So if we want to resolve for maximum usage, there will be bottleneck on the sigle acces point. This is means that Varnish is not the solution we are looking for.

4. In the future we may face a scaling problem, where we buy more server and more NAS. **Minio right now is not scalable.** If we have to add nodes to the system, we have to download all files down and re-upload them.

