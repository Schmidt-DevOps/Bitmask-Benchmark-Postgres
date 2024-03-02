SELECT
    pg_size_pretty(pg_total_relation_size('bitmask_demo')) AS total_size,
    pg_size_pretty(pg_relation_size('bitmask_demo')) AS data_size,
    pg_size_pretty(pg_total_relation_size('bitmask_demo') - pg_relation_size('bitmask_demo')) AS index_size;
