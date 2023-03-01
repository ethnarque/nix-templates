CREATE TABLE songs (
    id bigserial PRIMARY KEY,
    src varchar NOT NULL
);

CREATE TABLE song_metadata (
    song_id bigserial PRIMARY KEY,
    artist varchar,
    title varchar
);
