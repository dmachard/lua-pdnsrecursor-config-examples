## LUA Scripts for Recursor

LUA scripts examples for Recursor PowerDNS 

**Miscs**:
- [Get private EDNS option and set RequestorID ](./miscs_read_edns.lua)

# Run config from docker

Start

```bash
sudo docker run -d -p 8053:53/udp -p 8053:53/tcp -p 8082:8082 --name=recursor -v ./recursor.yml:/etc/powerdns/recursor.yml -v ./script.lua:/etc/powerdns/script.lua -v ./basic.rpz:/etc/powerdns/basic.rpz powerdns/pdns-recursor-51:5.1.3
```

Reload configuration

```bash
sudo docker stop recursor && sudo docker start recursor
```

Display logs

```bash
sudo docker logs recursor
Dec 22 10:45:56 PowerDNS Recursor 5.1.3 (C) PowerDNS.COM BV
Dec 22 10:45:56 Using 64-bits mode. Built using gcc 10.2.1 20210110 on Nov  4 2024 11:27:46 by root@localhost.
....
Dec 22 10:41:35 msg="Loading Lua script from file" subsystem="runtime" level="0" prio="Warning" tid="2" ts="1734864095.584" name="/etc/powerdns/script.lua"
Dec 22 10:41:38 msg="Polled security status of version, no known issues reported" subsystem="housekeeping" level="0" prio="Notice" tid="0" ts="1734864098.911" query="recursor-5.1.3.security-status.secpoll.powerdns.com" securitymessage="OK" status="1" version="5.1.3"
```

Testing DNS resolution

```bash
dig @127.0.0.1 -p 8053 +tcp google.com
```

Testing Web console access

```bash
curl -u admin:open http://127.0.0.1:8082
```
