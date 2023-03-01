-- name: Get :one
SELECT
    *
FROM
    songs
WHERE
    id = $1
LIMIT 1;
