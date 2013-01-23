CREATE TABLE stories(
  story_id INTEGER PRIMARY KEY,
  headline VARCHAR(255),
  link VARCHAR(255),
  user_id INTEGER,
  user_screen_name VARCHAR(255)
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE users(
  user_id INTEGER PRIMARY KEY,
  screen_name VARCHAR(255)
);

CREATE TABLE comments(
  comment_id INTEGER PRIMARY KEY,
  comment_text TEXT,
  user_id INTEGER,
  story_id INTEGER
  FOREIGN KEY (user_id) REFERENCES users(user_id)
  FOREIGN KEY (story_id) REFERENCES stories(story_id)
);