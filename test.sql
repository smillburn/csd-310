CREATE VIEW fullRoster AS
SELECT first_name, last_name, team_name 
FROM player
INNER JOIN team
ON player.team_id = team.team_id;

select * from fullRoster
WHERE team_name = 'TEAM SORA'
AND first_name != 'Mickey';

SELECT player_id, first_name, last_name, team_name 
FROM player 
INNER JOIN team 
ON player.team_id = team.team_id;

INSERT INTO player (first_name, last_name, team_id) VALUES('Smeagol', 'Shire Folk', 1);
UPDATE player SET team_id = 2, first_name = 'Gollum', last_name = 'Ring Stealer' WHERE first_name = 'Smeagol';
DELETE FROM player WHERE first_name = 'Gollum';


DROP USER IF EXISTS 'outland_adventures_user'@'localhost';

-- create outland_adventures_user and grant them all priveledges to the outland_adventures database
CREATE USER 'outland_adventures_user'@'localhost' IDENTIFIED WITH mysql_native_password By 'Cactusjuice17!';

-- grant all priveleges to the outland_adventures database to user outland_adventures_user on localhost
GRANT ALL PRIVILEGES ON outland_adventures.* TO 'outland_adventures_user'@'localhost';