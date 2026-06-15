WITH sr AS (
  SELECT DISTINCT
      s.id                      AS sprint_id,
      s.title                   AS sprint_title,
      s.board_id,
      s.start_date              AS sprint_start_date,
      (s.start_date::timestamptz + interval '1 day') AS cutoff_ts,
      sp.title                  AS team
  FROM sprint s
  JOIN space_boards sb ON sb.board_id = s.board_id
  JOIN space sp        ON sp.id = sb.space_id
),

events AS (
  SELECT
      a.card_id,
      a.board_id,
      a.created AS ts,
      CASE
        WHEN a.action IN ('card_add','card_join_board') THEN 'in'
        WHEN a.action IN ('card_leave_board','card_archive') THEN 'out'
        ELSE NULL
      END AS kind
  FROM activity a
  WHERE a.action IN ('card_add','card_join_board','card_leave_board','card_archive')
),

last_evt AS (
  SELECT sprint_id, card_id, kind
  FROM (
    SELECT
        sr.sprint_id,
        e.card_id,
        e.kind,
        e.ts,
        ROW_NUMBER() OVER (
          PARTITION BY sr.sprint_id, e.card_id
          ORDER BY e.ts DESC
        ) AS rn
    FROM sr
    JOIN events e
      ON e.board_id = sr.board_id
     AND e.ts < sr.cutoff_ts
  ) x
  WHERE rn = 1
),

cards_on_cutoff AS (
  SELECT sprint_id, card_id
  FROM last_evt
  WHERE kind = 'in'
),

cards AS (
  SELECT
    sr.sprint_id,
    sr.sprint_title,
    sr.sprint_start_date,
    sr.team,
    sr.board_id,
    ct.name AS card_type_name,
    c.id    AS card_id
  FROM sr
  JOIN cards_on_cutoff cos ON cos.sprint_id = sr.sprint_id
  JOIN card c              ON c.id = cos.card_id
  JOIN card_type ct        ON ct.id = c.type_id
  WHERE c.type_id IN (37,14,16,47)
)

SELECT
  c.team AS Команда,
  c.board_id,
  c.sprint_id,
  c.sprint_title AS Итерация,
  c.sprint_start_date,

  COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Bug')                AS "Bug",
  COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'User Story')         AS "User Story",
  COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Enabler User Story') AS "Enabler User Story",
  COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Support')            AS "Support",

  COUNT(DISTINCT c.card_id) AS "Sum",

  ROUND(
    COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Bug')::numeric
    / NULLIF(COUNT(DISTINCT c.card_id),0) * 100, 2
  ) AS "% Bug",

  ROUND(
    COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'User Story')::numeric
    / NULLIF(COUNT(DISTINCT c.card_id),0) * 100, 2
  ) AS "% User Story",

  ROUND(
    COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Enabler User Story')::numeric
    / NULLIF(COUNT(DISTINCT c.card_id),0) * 100, 2
  ) AS "% Enabler User Story",

  ROUND(
    COUNT(DISTINCT c.card_id) FILTER (WHERE c.card_type_name = 'Support')::numeric
    / NULLIF(COUNT(DISTINCT c.card_id),0) * 100, 2
  ) AS "% Support"

FROM cards c
GROUP BY c.team, c.board_id, c.sprint_id, c.sprint_title, c.sprint_start_date
ORDER BY c.sprint_start_date, c.sprint_title;
