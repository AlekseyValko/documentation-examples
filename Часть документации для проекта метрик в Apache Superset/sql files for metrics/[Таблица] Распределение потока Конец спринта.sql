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
    s.sprint_title AS iteration,
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
),

pivoted AS (
  SELECT
    cbt.team,
    cbt.sprint_id,
    cbt.iteration,
    s.sprint_end,
    COALESCE(SUM(CASE WHEN cbt.card_type_name = 'Bug' THEN cbt.done_cards_cnt END), 0) AS bug,
    COALESCE(SUM(CASE WHEN cbt.card_type_name = 'User Story' THEN cbt.done_cards_cnt END), 0) AS user_story,
    COALESCE(SUM(CASE WHEN cbt.card_type_name = 'Enabler User Story' THEN cbt.done_cards_cnt END), 0) AS enabler_user_story,
    COALESCE(SUM(CASE WHEN cbt.card_type_name = 'Support' THEN cbt.done_cards_cnt END), 0) AS support
  FROM cards_by_type cbt
  JOIN s ON s.sprint_id = cbt.sprint_id
  GROUP BY cbt.team, cbt.sprint_id, cbt.iteration, s.sprint_end
)

SELECT
  p.team        AS "Команда",
  p.sprint_id,
  p.iteration   AS "Итерация",
  p.sprint_end,
  p.bug         AS "Bug",
  p.user_story  AS "User Story",
  p.enabler_user_story AS "Enabler User Story",
  p.support     AS "Support",
  (p.bug + p.user_story + p.enabler_user_story + p.support) AS "Sum",
  ROUND(100.0 * p.bug / NULLIF((p.bug + p.user_story + p.enabler_user_story + p.support),0), 2) AS "% Bug",
  ROUND(100.0 * p.user_story / NULLIF((p.bug + p.user_story + p.enabler_user_story + p.support),0), 2) AS "% User Story",
  ROUND(100.0 * p.enabler_user_story / NULLIF((p.bug + p.user_story + p.enabler_user_story + p.support),0), 2) AS "% Enabler User Story",
  ROUND(100.0 * p.support / NULLIF((p.bug + p.user_story + p.enabler_user_story + p.support),0), 2) AS "% Support"
FROM pivoted p
ORDER BY p.sprint_id, p.iteration;