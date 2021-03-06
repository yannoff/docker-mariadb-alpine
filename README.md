# yannoff/docker-mariadb-alpine

A light-weight [MariaDB server](https://mariadb.org/ "MariaDB Project") [docker](https://www.docker.com/ "docker") image based on [Alpine](https://alpinelinux.org/ "Alpine Linux").

## Step-by-step instructions


In the above examples, we'll assume the following use-case:

- We'll use `dbserver` for the service name.
- Persisted data is stored under `/path/to/your/data` on host machine.
- Service should be accessible on port `3307` from host machine.
- Admin password for the mariadb server is `your_root_password`.

### Step one: run init image

```bash
docker run --rm --name dbinit -e MYSQL_ROOT_PASSWORD=your_root_password -v /path/to/your/data:/var/lib/mysql yannoff/mariadb-light-init
```

### Step two: remove init image
```bash
docker rmi -f yannoff/mariadb-light-init
```

### Step three: run image (standalone)

From command-line, this image can be run directly using [docker](https://www.docker.com/ "docker").

```bash
docker run --rm --name dbserver -e MYSQL_ROOT_PASSWORD=your_root_password -v /path/to/your/data:/var/lib/mysql -p 3307:3306 yannoff/mariadb-light
```

### Step three: run image (in a stack)

This image is ready for use in a [docker-compose](https://github.com/docker/compose "Docker Compose Project") stack.


```yaml
# docker-compose.yml
dbserver:
    image: yannoff/mariadb-light
    ports:
        - "3307:3306"
    volumes:
        - /path/to/your/data:/var/lib/mysql
    environment:
        - MYSQL_ROOT_PASSWORD: you_root_password
```

Then start your stack using docker-compose command-line.


```bash
docker-compose up -d
```
