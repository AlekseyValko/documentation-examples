WITH sr AS (
  SELECT DISTINCT
      s.id                      AS sprint_id,
      s.title                   AS sprint_title,
      s.board_id,
      (s.start_date::timestamptz + interval '1 day') AS sprint_start,
      s.actual_finish_date::timestamptz AS sprint_end,
      sp.title                  AS team
  FROM sprint s
  JOIN space_boards sb ON sb.board_id = s.board_id
  JOIN space sp        ON sp.id = sb.space_id
),

events AS (
  SELECT
      a.card_id,
      a.board_id,
      a.created,
      CASE
        WHEN a.action IN ('card_add','card_join_board') THEN 'in'
        WHEN a.action IN ('card_leave_board','card_archive') THEN 'out'
        ELSE NULL
      END AS kind
  FROM activity a
  WHERE a.action IN ('card_add','card_join_board','card_leave_board','card_archive')
),

cards_at_start AS (
  SELECT DISTINCT
      sr.sprint_id,
      e.card_id
  FROM sr
  JOIN events e
    ON e.board_id = sr.board_id
   AND e.created <= sr.sprint_start
  WHERE e.kind = 'in'
),

added_after_start AS (
  SELECT DISTINCT
      sr.sprint_id,
      e.card_id
  FROM sr
  JOIN events e
    ON e.board_id = sr.board_id
   AND e.kind = 'in'
   AND e.created > sr.sprint_start
   AND e.created <= sr.sprint_end
),

cards AS (
  SELECT DISTINCT
    sr.sprint_id,
    sr.sprint_title,
    sr.sprint_start,
    sr.team,
    sr.board_id,
    ct.name AS card_type_name,
    c.id    AS card_id
  FROM sr
  JOIN added_after_start aas ON aas.sprint_id = sr.sprint_id
  JOIN card c                ON c.id = aas.card_id
  JOIN card_type ct          ON ct.id = c.type_id
  WHERE c.type_id IN (37,14,16,47)
),

base_counts AS (
  SELECT
    sr.sprint_id,
    COUNT(DISTINCT cas.card_id) AS start_cards
  FROM sr
  LEFT JOIN cards_at_start cas ON cas.sprint_id = sr.sprint_id
  GROUP BY sr.sprint_id
)

SELECT
  c.team AS Команда,
  c.board_id,
  c.sprint_id,
  c.sprint_title AS Итерация,
  c.sprint_start,
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
  ) AS "% Support",

  ROUND(
    COUNT(DISTINCT c.card_id)::numeric 
    / NULLIF(bc.start_cards,0) * 100, 2
  ) AS "% Добавлено от стартовых"

FROM cards c
JOIN base_counts bc ON bc.sprint_id = c.sprint_id
GROUP BY c.team, c.board_id, c.sprint_id, c.sprint_title, c.sprint_start, bc.start_cards
ORDER BY c.sprint_start, c.sprint_title;
