DELIMITER //

CREATE PROCEDURE CreatePlayerProfile(
    IN playerName VARCHAR(100)
)
BEGIN
    -- Insert new player profile with house set to NULL and xp_lvl initialized to 1
    INSERT INTO playerprofile (player_name, house, xp_lvl)
    VALUES (playerName, NULL, 1);

    -- Return a success message
    SELECT CONCAT('Player profile for "', playerName, '" created successfully.') AS success_message;
END //

DELIMITER ;

-- CALL CreatePlayerProfile('Suzad Mohammad');
