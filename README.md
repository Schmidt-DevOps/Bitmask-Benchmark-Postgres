# What's this?

tbd

# Usage

```sh
docker compose build
```

You may then start the services. This will launch PostgreSQL, as well as the pgweb interface.

```sh
docker compose up -d
```

```sh
docker compose down
```

# Preliminary results

BITMASK:

total_size: 109 MB
data_size: 81 MB
index_size: 28 MB
MEM USAGE: ~91 MB (PEAK: ~206 MB)
BLOCK I/O: 153 MB/831 MB

BOOLEAN:

total_size: 139 MB
data_size: 81 MB
index_size: 59 MB
MEM USAGE: ~92 MB (PEAK: ~225 MB)
BLOCK I/O: 153 MB/1.59 GB !
