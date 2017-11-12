# yannoff/docker-mariadb-alpine/init

A light-weight [MariaDB server](https://mariadb.org/ "MariaDB Project") [docker](https://www.docker.com/ "docker") image based on [Alpine](https://alpinelinux.org/ "Alpine Linux").

## Usage

In the above examples, we'll assume the following use-case:

- We'll use `dbinit` for the container name.
- Persisted data is stored under `/path/to/your/data` on host machine.
- Admin password for the mariadb server is `your_root_password`.

### Step one: run init image

From command-line, this image can be run directly using [docker](https://www.docker.com/ "docker").

```bash
docker run --rm --name dbinit -e MYSQL_ROOT_PASSWORD=your_root_password -v /path/to/your/data:/var/lib/mysql yannoff/mariadb-light-init
```

### Step two: remove init image
```bash
docker rmi -f yannoff/mariadb-light-init
```
