.headers on
.mode column

DROP TABLE IF EXISTS match_statistics;
CREATE VIEW IF NOT EXISTS match_statistics
AS
    SELECT
        match_id,
        player_name,
        SUM(kill_count) AS kill_count,
        SUM(suicide_count) AS suicide_count,
        SUM(death_count) AS death_count,
        ROUND(
            SUM(kill_count) * 100.0 / (SUM(kill_count) + SUM(death_count) + SUM(death_count)),
            2
        ) AS efficiency
    FROM
        (
        SELECT
            match_id,
            killer_name AS player_name,
            COUNT(victim_name) AS kill_count,
            COUNT(*) - COUNT(victim_name) AS suicide_count,
            0 AS death_count
        FROM match_frag
        GROUP BY match_id, player_name
        UNION ALL
        SELECT
            match_id,   
            victim_name AS player_name,
            0 AS kill_count,
            0 AS suicide_count,
            count(victim_name) AS death_count
        FROM match_frag
        WHERE player_name NOT NULL
        GROUP BY match_id, player_name
        ORDER BY match_id, player_name
        )
    GROUP BY match_id, player_name;
SELECT * FROM match_statistics ORDER BY efficiency ASC;
DROP VIEW IF EXISTS match_statistics;