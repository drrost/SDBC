
CREATE TABLE book (
    "book_id" INTEGER,
    "name" TEXT,
    "cover" BLOB,
    "created_at" REAL
);

CREATE TABLE user(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "first_name" TEXT,
  "last_name" TEXT,
  "age" INTEGER
);
