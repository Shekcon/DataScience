SELECT 
    F.match_id, 
    F.killer_name,
    F.victim_name as favorite_victim_name,
    F.kill_count
FROM
    (
    SELECT 
        match_id,
        killer_name,
        victim_name,
        row_number() OVER (PARTITION by killer_name ORDER BY count(victim_name) DESC) ,
        count(victim_name) as kill_count
    FROM match_frag
    WHERE weapon_code is NOT NULL
    GROUP BY match_id, killer_name, victim_name
    ORDER BY killer_name
    ) F
WHERE F.row_number = 1;