WITH s AS (
  SELECT
    s.id                      AS sprint_id,
    s.title                   AS sprint_title,
    s.board_id,
    s.start_date::timestamptz AS sprint_start,
    (s.actual_finish_date::date + INTERVAL '1 day')::timestamptz AS sprint_end,
    sp.title                  AS team
  FROM sprint s
  JOIN space_boards sb ON sb.board_id = s.board_id
  JOIN space sp        ON sp.id = sb.space_id
),

moves AS (
  SELECT
    s.sprint_id,
    s.sprint_title,
    s.team,
    a.card_id,
    (a.data->'dump'->'column'->>'type')::int AS to_type,
    a.created
  FROM s
  JOIN activity a
    ON a.board_id = s.board_id
   AND a.action::text = 'card_move'
   AND a.created >= s.sprint_start
   AND a.created <  s.sprint_end
),

last_move AS (
  SELECT
    sprint_id,
    sprint_title,
    team,
    card_id,
    to_type
  FROM (
    SELECT
      m.*,
      ROW_NUMBER() OVER (PARTITION BY m.sprint_id, m.card_id ORDER BY m.created DESC) AS rn
    FROM moves m
  ) x
  WHERE rn = 1
),

cards_by_type AS (
  SELECT
    s.sprint_id,
    s.sprint_title,
    s.team,
    ct.name        AS card_type_name,
    COUNT(DISTINCT c.id) AS done_cards_cnt
  FROM last_move lm
  JOIN s       ON s.sprint_id = lm.sprint_id
  JOIN card c  ON c.id = lm.card_id
  JOIN card_type ct ON ct.id = c.type_id
  WHERE lm.to_type = 3
    AND ct.id IN (37,14,16,47)
  GROUP BY s.sprint_id, s.sprint_title, s.team, ct.name
)

SELECT
  cbt.team,
  CONCAT(LPAD(cbt.sprint_id::text, 4, '0'), ':', cbt.sprint_title) AS iteration,
  s.sprint_end,
  cbt.card_type_name,
  cbt.done_cards_cnt,
  ROUND(
    100.0 * cbt.done_cards_cnt 
    / SUM(cbt.done_cards_cnt) OVER (PARTITION BY cbt.sprint_id),
    2
  ) AS percent_in_sprint
FROM cards_by_type cbt
JOIN s ON cbt.sprint_id = s.sprint_id
ORDER BY cbt.sprint_id, cbt.sprint_title, cbt.card_type_name;
