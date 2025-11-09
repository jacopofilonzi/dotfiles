# Docker setup


## Networks


**172.30.0.0/16** viene sfruttato tramite subnetting di 172.30.0.0/24 con le seguenti specifiche


- **172.30.0.0/24:** Traefik
    - net addr: 172.30.0.1/24
    - dhcp assigned: 172.30.0.[2 - 254]

```bash
docker network create   
    --driver=bridge   
    --internal   
    --subnet=172.30.0.0/24   
    --gateway=172.30.0.1 
    cust_traefik
```

- **172.30.1.0/24:** dangling
    - net addr: 172.30.1.1/24
    - static ips: 172.30.1.[2 - 254]
    - predefined hosts:
        - 172.30.1.2 -> pihole
        - 172.30.1.3 -> traefik proxy


```bash
docker network create \
    --driver=bridge \
    --internal \
    --subnet=172.30.1.0/24 \
    --gateway=172.30.1.1 \
    --ip-range=172.30.1.0/32 \
    dangling
```

- **random**: net_access
    - permette l'accesso ad internet ai container

```bash
docker network create net_access
```
