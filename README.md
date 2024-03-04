# What's this?

This is a follow-up to
my [Medium.com post about the concept of bitmasks in SQL databases](https://medium.com/learning-sql/efficient-dbms-storage-of-yes-no-attributes-349d7b4c2ccd).

The scripts in this repo benchmark two Postgres tables that store a bunch of attributes either in dedicated bool fields
or in an INT bitmask.

# Requirements

- Linux
- Docker
- Make

# Usage

TL;DR: *Typically*, you'd want to run the suite like this:

```bash
# Choose what concept you want to test:
# 1. Saving attributes as dedicated BOOL fields
# 2. Saving attributes as INT bitmask

export FIXTURES=boolean
# OR
export FIXTURES=bitmask
```

```bash
make down; make clean && make up && make record 
# then check the results-*.txt for the results.
```

# Results

Notes:

1. All values are rounded to integers
2. Block IO values were taken from the first time CPU load dropped to about 0 during recording. They fluctuate due to
   manual interaction.

## Bitmasks

These are the results for 11-31 attributes.

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block IO MB |
|-------|----------|----------|---------|----------|-------------|-------------|
| 1     | 21       | 541      | 403     | 138      | 238         | 155/3550    |
| 2     | 21       | 541      | 403     | 138      | 244         | 155/3600    |
| 3     | 21       | 541      | 403     | 138      | 229         | 157/3570    |
| 4     | 21       | 541      | 403     | 138      | 229         | 154/3670    |
| 5     | 21       | 541      | 403     | 138      | 233         | 154/3670    |
| 6     | 20       | 541      | 403     | 138      | 234         | 155/3610    |

### Unoptimized query

```sql
SELECT *
FROM view_bitmask_demo
WHERE is_male IS false
  AND (is_female IS false AND is_scientist IS true)
ORDER BY is_european;
```

Result size is 455,583.

| Run # | Execution Time (ms) | Fetch Time (ms) |
|-------|---------------------|-----------------|
| 1     | 408                 | 10              |
| 2     | 417                 | 10              |
| 3     | 427                 | 10              |
| 4     | 414                 | 9               |
| 5     | 407                 | 9               |
| 6     | 398                 | 10              |


### Optimized query

This query only calculates status when it's needed.

```sql
SELECT *, status & 8 = 8 AS is_european
FROM bitmask_demo
WHERE status & 2 != 2
  AND (status & 1 != 1 AND status & 4 = 4)
ORDER BY is_european;
```

Result size is 455,583.

| Run # | Execution Time (ms) | Fetch Time (ms) |
|-------|---------------------|-----------------|
| 1     | 279                 | 14              |
| 2     | 296                 | 13              |
| 3     | 284                 | 7               |
| 4     | 299                 | 8               |
| 5     | 299                 | 7               |
| 6     | 324                 | 7               |

## Booleans

These are the results for 11 attributes. More attributes mean more indexes and thus
more resources.

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block IO MB |
|-------|----------|----------|---------|----------|-------------|-------------|
| 1     | 52       | 848      | 403     | 446      | 237         | 159/7740    |
| 2     | 51       | 848      | 403     | 446      | 236         | 167/7750    |
| 3     | 52       | 848      | 403     | 446      | 234         | 162/7650    |
| 4     | 51       | 848      | 403     | 446      | 234         | 157/7670    |
| 5     | 51       | 848      | 403     | 446      | 234         | 160/7740    |
| 6     | 51       | 848      | 403     | 446      | 267         | 162/7690    |

```sql
SELECT *
FROM view_bitmask_demo
WHERE is_male IS false
  AND (is_female IS false AND is_scientist IS true)
ORDER BY is_european;
```

Result size is 453,836.

| Run # | Execution Time (ms) | Fetch Time (ms) |
|-------|---------------------|-----------------|
| 1     | 561                 | 28              |
| 2     | 288                 | 21              |
| 3     | 281                 | 12              |
| 4     | 274                 | 14              |
| 5     | 287                 | 16              |
| 6     | 242                 | 14              |
