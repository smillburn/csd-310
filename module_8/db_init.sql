-- drop test user if exists 
DROP USER IF EXISTS 'pysports_user'@'localhost';

-- create pysports_user and grant them all priveleges to the pysports database
CREATE USER 'pysports_user'@'localhost' IDENTIFIED WITH mysql_native_password By 'MySQL8IsGreat!';

-- grant all priveleges to the pysports database to user pysports_user on localhost
GRANT ALL PRIVILEGES ON pysports.* TO 'pysports_user'@'localhost';

-- drop tables if they are present
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS team;

-- create the team table
CREATE TABLE team (
    team_id     INT             NOT NULL    AUTO_INCREMENT,
    team_name   VARCHAR(75)     NOT Null,
    mascot      VARCHAR (75)    NOT NULL,
    PRIMARY KEY(team_id)
);

-- create the player table and set the foreign key
CREATE TABLE player (
    player_id   INT             NOT NULL    AUTO_INCREMENT,
    first_name  VARCHAR(75)     NOT NULL,
    last_name   VARCHAR(75)     NOT NULL,
    team_id     INT             NOT NULL,
    PRIMARY KEY(player_id),
    CONSTRAINT fk_team
    FOREIGN KEY(team_id)
        REFERENCES team(team_id)
);

-- insert team records
INSERT INTO team(team_name, mascot)
    VALUES('TEAM Gandalf', 'White Wizards');

INSERT INTO team(team_name, mascot)
    VALUES('TEAM Rathalos', 'Red Wyvern');

INSERT INTO team(team_name, mascot)
    VALUES('TEAM Sora', 'Heart');

-- Insert players onto Team Gandalf
INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Funky', 'Fred', 1);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('fluffy', 'frank', 1);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('freaky', 'bob', 1);

-- Insert players onto Team Rathalos
INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Joe', 'Lagiacrus', 2);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Danny', 'Diablos', 2);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Nancy', 'Nergigante', 2);

-- Insert players onto Team Heart
INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Donald', 'Duck', 3);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Goofey', 'Goofey', 3);

INSERT INTO player(first_name,  last_name, team_id)
    VALUES('Mickey', 'Mouse', 3);

-- Test selections
SELECT * FROM player WHERE team_id = 1;
SELECT * FROM player WHERE team_id = 2;
SELECT * FROM player WHERE team_id = 3;

