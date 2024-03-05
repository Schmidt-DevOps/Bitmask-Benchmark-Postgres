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

These are the results loading fixtures for 11-31 attributes. Note that the values for "Index" 
include a dedicated "is_european" index (see SQL below).

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block I MB | Block O MB |
|-------|----------|----------|---------|----------|-------------|------------|------------|
| 1     | 18       | 543      | 403     | 140      | 267         | 158        | 3450       |
| 2     | 20       | 543      | 403     | 140      | 299         | 156        | 3410       |
| 3     | 19       | 543      | 403     | 140      | 262         | 153        | 3440       |
| 4     | 18       | 543      | 403     | 140      | 325         | 153        | 3450       |
| 5     | 20       | 543      | 403     | 140      | 282         | 153        | 3450       |
| 6     | 19       | 543      | 403     | 140      | 255         | 167        | 3420       |

* Median value for "Peak MEM MB": 275,5
* Median value for "Block Input MB": 154.5
* Median value for "Block Output MB": 3445

This query only calculates what's needed.

```sql
-- Create dedicated index for bits you want to order by
DROP INDEX IF EXISTS is_european_idx;
CREATE INDEX is_european_idx ON bitmask_demo ((status & 8 = 8) );

SELECT *, status & 8 = 8 AS is_european
FROM bitmask_demo
WHERE status & 2 != 2 -- is_male IS false
   OR (status & 1 != 1 AND status & 4 = 4) -- OR (is_female IS false AND is_scientist IS true)
ORDER BY is_european ASC;
```

Result size is 4,546,503

| Run # | Execution Time (ms) | Fetch Time (ms) |
|-------|---------------------|-----------------|
| 1     | 119                 | 12              |
| 2     | 6                   | 21              |
| 3     | 7                   | 38              |
| 4     | 6                   | 36              |
| 5     | 6                   | 42              |
| 6     | 7                   | 20              |

* Median value for "Execution time (ms)": 6.5
* Median value for "Fetch time (ms)": 28.5

## Booleans

These are the results loading fixtures for 11 attributes. More attributes mean more indexes and thus
more resources.

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block I MB | Block O MB |
|-------|----------|----------|---------|----------|-------------|------------|------------|
| 1     | 26       | 543      | 403     | 140      | 231         | 154        | 3470       |
| 2     | 26       | 543      | 403     | 140      | 294         | 154        | 3470       |
| 3     | 28       | 543      | 403     | 140      | 228         | 153        | 3460       |
| 4     | 29       | 543      | 403     | 140      | 292         | 153        | 3470       |
| 5     | 30       | 543      | 403     | 140      | 324         | 153        | 3460       |
| 6     | 57       | 543      | 403     | 140      | 276         | 153        | 3470       |

* Median value for "Peak MEM MB": 284
* Median value for "Block Input MB": 153
* Median value for "Block Output MB": 3470

```sql
-- Create dedicated index for attributes you want to order by
DROP INDEX IF EXISTS is_european_idx;
CREATE INDEX is_european_idx ON bitmask_demo ((status & 8 = 8));

SELECT id, character_name
FROM bitmask_demo
WHERE is_male IS false
   OR (is_female IS false AND is_scientist IS true)
ORDER BY is_european ASC;
```

Result size is 4,546,059.

| Run # | Execution Time (ms) | Fetch Time (ms) |
|-------|---------------------|-----------------|
| 1     | 108                 | 17              |
| 2     | 10                  | 19              |
| 3     | 7                   | 11              |
| 4     | 7                   | 27              |
| 5     | 10                  | 20              |
| 6     | 8                   | 27              |

* Median value for "Execution time (ms)": 9
* Median value for "Fetch time (ms)": 19.5