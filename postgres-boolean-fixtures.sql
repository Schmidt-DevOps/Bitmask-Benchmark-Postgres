DROP VIEW IF EXISTS view_bitmask_demo;
DROP TABLE IF EXISTS bitmask_demo;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE bitmask_demo
(
    id             BIGSERIAL PRIMARY KEY,
    character_name VARCHAR(36) NOT NULL,
    is_female      BOOLEAN DEFAULT false,
    is_male        BOOLEAN DEFAULT false,
    is_scientist   BOOLEAN DEFAULT false,
    is_european    BOOLEAN DEFAULT false,
    is_american    BOOLEAN DEFAULT false,
    is_activist    BOOLEAN DEFAULT false,
    is_fictional   BOOLEAN DEFAULT false,
    is_politician  BOOLEAN DEFAULT false,
    is_space_farer BOOLEAN DEFAULT false,
    is_academic    BOOLEAN DEFAULT false,
    is_terran      BOOLEAN DEFAULT false
);

CREATE OR REPLACE FUNCTION insert_named_characters()
    RETURNS VOID AS
$$
BEGIN
    INSERT INTO bitmask_demo (character_name, is_terran, is_academic, is_male, is_scientist, is_american)
    VALUES ('Anthony Fauci', true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_academic, is_male, is_scientist, is_european)
    VALUES ('Chr. Drosten', true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_academic, is_male, is_activist, is_european)
    VALUES ('Hermann Gmeiner', true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_fictional, is_male, is_american)
    VALUES ('Justus Jonas', true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_fictional, is_male, is_american)
    VALUES ('Hank Hill', true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_space_farer, is_fictional, is_male, is_american,
                              is_scientist)
    VALUES ('Rick Sanchez', true, true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_academic, is_politician, is_female, is_european)
    VALUES ('Ursula von der Leyen', true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_politician, is_fictional, is_male, is_american, is_european)
    VALUES ('Abradolf Lincler', true, true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_space_farer, is_politician, is_fictional, is_male, is_activist)
    VALUES ('Shrimply Pibbles', true, true, true, true, true);
    INSERT INTO bitmask_demo (character_name, is_terran, is_male, is_european) VALUES ('Georg Elser', true, true, true);
END;
$$ LANGUAGE plpgsql;
SELECT insert_named_characters();

CREATE OR REPLACE FUNCTION insert_random_characters()
    RETURNS VOID AS
$$
DECLARE
    i                  INTEGER := 1;
    random_value       FLOAT;
    rnd_exp            INTEGER;
    status             INTEGER;
BEGIN
    WHILE i <= 5000000
        LOOP
            random_value := random();
            rnd_exp := floor(random_value * 11);
            status := 2 ^ rnd_exp;

            INSERT
            INTO bitmask_demo
            (character_name, is_female, is_male, is_scientist, is_european, is_american, is_activist,
             is_fictional, is_politician, is_space_farer, is_academic, is_terran)
            VALUES (uuid_generate_v4(),
                    status & 1 = 2 ^ 0,
                    status & 2 = 2 ^ 1,
                    status & 4 = 2 ^ 2,
                    status & 8 = 2 ^ 3,
                    status & 16 = 2 ^ 4,
                    status & 32 = 2 ^ 5,
                    status & 64 = 2 ^ 6,
                    status & 128 = 2 ^ 7,
                    status & 256 = 2 ^ 8,
                    status & 512 = 2 ^ 9,
                    status & 1024 = 2 ^ 10);
            i := i + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT insert_random_characters();

-- CREATE INDEX bitmask_demo_is_female_index
--     ON public.bitmask_demo (is_female);
-- CREATE INDEX bitmask_demo_is_male_index
--     ON public.bitmask_demo (is_male);
-- CREATE INDEX bitmask_demo_is_scientist_index
--     ON public.bitmask_demo (is_scientist);
CREATE INDEX bitmask_demo_is_european_index
    ON public.bitmask_demo (is_european);
-- CREATE INDEX bitmask_demo_is_american_index
--     ON public.bitmask_demo (is_american);
-- CREATE INDEX bitmask_demo_is_activist_index
--     ON public.bitmask_demo (is_activist);
-- CREATE INDEX bitmask_demo_is_fictional_index
--     ON public.bitmask_demo (is_fictional);
-- CREATE INDEX bitmask_demo_is_politician_index
--     ON public.bitmask_demo (is_politician);
-- CREATE INDEX bitmask_demo_is_space_farer_index
--     ON public.bitmask_demo (is_space_farer);
-- CREATE INDEX bitmask_demo_is_academic_index
--     ON public.bitmask_demo (is_academic);
-- CREATE INDEX bitmask_demo_is_terran_index
--     ON public.bitmask_demo (is_terran);

-- CREATE VIEW view_bitmask_demo AS
-- SELECT id,
--        character_name,
--        is_female,
--        is_male,
--        is_scientist,
--        is_european,
--        is_american,
--        is_activist,
--        is_fictional,
--        is_politician,
--        is_space_farer,
--        is_academic,
--        is_terran
-- FROM bitmask_demo
-- ORDER BY id;
