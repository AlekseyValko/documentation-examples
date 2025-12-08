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
)

SELECT
  sr.team,
  sr.board_id,
  CONCAT(LPAD(sr.sprint_id::text, 4, '0'), ':', sr.sprint_title) AS iteration,
  sr.sprint_start_date,
  ct.name                           AS card_type_name,
  ARRAY_AGG(DISTINCT c.id ORDER BY c.id) AS card_ids,
  COUNT(DISTINCT c.id)              AS cards_cnt,
  ROUND(
    COUNT(DISTINCT c.id)::numeric 
    / SUM(COUNT(DISTINCT c.id)) OVER (PARTITION BY sr.sprint_id) * 100,
    2
  ) AS percent_of_total
FROM sr
JOIN cards_on_cutoff cos ON cos.sprint_id = sr.sprint_id
JOIN card c              ON c.id = cos.card_id
JOIN card_type ct        ON ct.id = c.type_id
WHERE c.type_id IN (37,14,16,47)
GROUP BY sr.team, sr.sprint_id, sr.sprint_title, sr.board_id, sr.sprint_start_date, ct.name
ORDER BY sr.sprint_start_date ASC, sr.sprint_title, ct.name;
