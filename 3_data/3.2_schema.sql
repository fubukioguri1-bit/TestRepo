-- 例: テーブル定義
CREATE TABLE example (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
