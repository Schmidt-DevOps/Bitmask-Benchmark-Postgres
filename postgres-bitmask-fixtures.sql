DROP VIEW IF EXISTS view_bitmask_demo;
DROP TABLE IF EXISTS bitmask_demo;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE bitmask_demo
(
    id             BIGSERIAL PRIMARY KEY,
    status         INTEGER DEFAULT 0 NOT NULL,
    character_name VARCHAR(36)       NOT NULL
);

CREATE OR REPLACE FUNCTION insert_named_characters()
    RETURNS VOID AS
$$
DECLARE
    is_female      INTEGER := 2 ^ 0;
    is_male        INTEGER := 2 ^ 1;
    is_scientist   INTEGER := 2 ^ 2;
    is_european    INTEGER := 2 ^ 3;
    is_american    INTEGER := 2 ^ 4;
    is_activist    INTEGER := 2 ^ 5;
    is_fictional   INTEGER := 2 ^ 6;
    is_politician  INTEGER := 2 ^ 7;
    is_space_farer INTEGER := 2 ^ 8;
    is_academic    INTEGER := 2 ^ 9;
    is_terran      INTEGER := 2 ^ 10;
BEGIN
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_academic | is_male | is_scientist | is_american, 'Anthony Fauci');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_academic | is_male | is_scientist | is_european, 'Chr. Drosten');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_academic | is_male | is_activist | is_european, 'Hermann Gmeiner');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_fictional | is_male | is_american, 'Justus Jonas');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_fictional | is_male | is_american, 'Hank Hill');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_space_farer | is_fictional | is_male | is_american | is_scientist, 'Rick Sanchez');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_academic | is_politician | is_female | is_european, 'Ursula von der Leyen');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_terran | is_politician | is_fictional | is_male | is_american | is_european, 'Abradolf Lincler');
    INSERT INTO bitmask_demo (status, character_name)
    VALUES (is_space_farer | is_politician | is_fictional | is_male | is_activist, 'Shrimply Pibbles');
    INSERT INTO bitmask_demo (status, character_name) VALUES (is_terran | is_male | is_european, 'Georg Elser');
END;
$$ LANGUAGE plpgsql;
SELECT insert_named_characters();

CREATE OR REPLACE FUNCTION insert_random_characters()
    RETURNS VOID AS
$$
DECLARE
    i            INTEGER := 1;
    random_value FLOAT;
    rnd_exp      INTEGER;
BEGIN
    WHILE i <= 5000000
        LOOP
            random_value := random();
            rnd_exp := floor(random_value * 11);
            INSERT INTO bitmask_demo (status, character_name) VALUES (2 ^ rnd_exp, uuid_generate_v4());
            i := i + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT insert_random_characters();

-- CREATE INDEX bitmask_demo_status_index ON public.bitmask_demo (status);
CREATE INDEX is_european_idx ON bitmask_demo ((status & 8 = 8));

-- Create dedicated index for bits you want to order by
-- DROP INDEX IF EXISTS is_european_idx;
-- CREATE INDEX is_european_idx ON bitmask_demo ((status & 8 = 8));

-- CREATE VIEW view_bitmask_demo AS
-- SELECT id,
--        character_name,
--        status,
--        status & 1 = 1       AS is_female,
--        status & 2 = 2       AS is_male,
--        status & 4 = 4       AS is_scientist,
--        status & 8 = 8       AS is_european,
--        status & 16 = 16     AS is_american,
--        status & 32 = 32     AS is_activist,
--        status & 64 = 64     AS is_fictional,
--        status & 128 = 128   AS is_politician,
--        status & 256 = 256   AS is_space_farer,
--        status & 512 = 512   AS is_academic,
--        status & 1024 = 1024 AS is_terran
-- FROM bitmask_demo
-- ORDER BY id;
