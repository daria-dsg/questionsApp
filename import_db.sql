PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE questions_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    body TEXT NOT NULL,

    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE questions_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO users(fname, lname)
VALUES ('Catalina', 'Marks');

INSERT INTO users(fname, lname)
VALUES ('Ruby', 'Pope');


INSERT INTO questions(title, body, user_id)
VALUES ('Catalina question', 'What''s something you learned in the last week?', 1);

INSERT INTO questions(title, body, user_id)
VALUES ('Ruby question', 'When people come to you for help, what do they usually want help with?', 2);

INSERT INTO questions(title, body, user_id)
VALUES ('Second question of Catalina', 'What is something you can never seem to finish?', 1);


INSERT INTO questions_follows(question_id, user_id)
VALUES (1, 2);

INSERT INTO questions_follows(question_id, user_id)
VALUES (2, 1);


INSERT INTO replies(user_id, question_id, body)
VALUES (1, 2, 'Catalina is answering on Ruby''s question');

INSERT INTO replies(user_id, question_id, body)
VALUES (2, 1, 'Ruby is answering on Catalina''s question');


INSERT INTO questions_likes(question_id, user_id)
VALUES (1, 2);

INSERT INTO questions_likes(question_id, user_id)
VALUES (2, 1);


