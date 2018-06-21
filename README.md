# sparklecoin/sparklecoind

Sparklecoind docker image. 

## Supported tags and respective `Dockerfile` links
- `1.1.1` ([1.1.1/Dockerfile](https://github.com/sparklecoin/docker-sparklecoind/blob/master/1.1.1/Dockerfile))

## Usage
### How to use this image

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `sparklecoind` binary:

```sh
$ docker run --name sparklecoind -d sparklecoin/sparklecoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo
```

Due to this you can use the same command to start the testnet container:

```sh
$ docker run --name sparklecoind-testnet -d sparklecoin/sparklecoind \
  -rpcallowip=* \
  -rpcpassword=bar \
  -rpcuser=foo \
  -testnet=1
```

By default, `sparklecoin` will run as as user `coin` for security reasons and with its default data dir (`~/.sparklecoin`). If you'd like to customize where `sparklecoin` stores its data, you must use the `SPRK_DATA` environment variable. The directory will be automatically created with the correct permissions for the `coin` user and `sparklecoin` automatically configured to use it.

```sh
$ docker run --env SPRK_DATA=/var/lib/sparklecoin --name sparklecoind -d sparklecoin/sparklecoind
```

You can also mount a directory it in a volume under `/home/coin/.sparklecoin` in case you want to access it on the host:

```sh
$ docker run -v /opt/sparklecoin:/home/coin/.sparklecoin --name sparklecoind -d sparklecoin/sparklecoind
```
That will allow to access containers `~/.sparklecoin` directory in `/opt/sparklecoin` on the host.


```sh
$ docker run -v ${PWD}/data:/home/coin/.sparklecoin --name sparklecoind -d sparklecoin/sparklecoind
```
will mount current directory in containers `~/.sparklecoin`

To map container RPC ports to localhost start container with following command:

```sh
$ docker run -v /opt/sparklecoin:/home/coin/.sparklecoin -p 6020:6020 -p 6021:6021 -p 16020:16020 -p 16021:16021 --name sparklecoind -d sparklecoin/sparklecoind -rpcallowip=* testnet
```
You may want to change the port that it is being mapped to if you already run a sparklecoin instance on the localhost.
For example: `-p 9999:16021` will map port 16021 from container to localhost:9999.

Now you will be able to `curl` the sparklecoin RPC in the container:

`curl --user bitcoin:password --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' -H 'cont ent-type: text/plain;' `docker inspect sparklecoind-testnet | grep -F "\"IPAddress" | head -n1 | awk -F\" '{print $(NF-1)}'`:16021/`

> {"result":{"version":"v1.1.1.0-unk","protocolversion":60007,"walletversion":60000,"balance":0.00000000,"newmint":0.00000000,"stake":0.00000000,"blocks":34637,"moneysupply":1122301.05214500,"connections":1,"proxy":"","ip":"217.170.90.9","difficulty":0.25689120,"testnet":true,"keypoololdest":1529589770,"keypoolsize":101,"paytxfee":0.01000000,"errors":""},"error":null,"id":"curltest"}
