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

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block IO MB |
|-------|----------|----------|---------|----------|-------------|-------------|
| 1     | 21       | 541      | 403     | 138      | 238         | 155/3550    |
| 2     | 21       | 541      | 403     | 138      | 244         | 155/3600    |
| 3     | 21       | 541      | 403     | 138      | 229         | 157/3570    |
| 4     | 21       | 541      | 403     | 138      | 229         | 154/3670    |
| 5     | 21       | 541      | 403     | 138      | 233         | 154/3670    |
| 6     | 20       | 541      | 403     | 138      | 234         | 155/3610    |

## Booleans

| Run # | Time (s) | Total MB | Data MB | Index MB | Peak MEM MB | Block IO MB |
|-------|----------|----------|---------|----------|-------------|-------------|
| 1     | 52       | 848      | 403     | 446      | 237         | 159/7740    |
| 2     | 51       | 848      | 403     | 446      | 236         | 167/7750    |
| 3     | 52       | 848      | 403     | 446      | 234         | 162/7650    |
| 4     | 51       | 848      | 403     | 446      | 234         | 157/7670    |
| 5     | 51       | 848      | 403     | 446      | 234         | 160/7740    |
| 6     | 51       | 848      | 403     | 446      | 267         | 162/7690    |
