-- SHOW DATABASES;
-- USE hogwarts;

-- DROP PROCEDURE IF EXISTS SortingHatCeremony;

DELIMITER $$

CREATE PROCEDURE SortingHatCeremony (
    IN player_id INT,
    IN answer_text VARCHAR(255),
    OUT winning_house VARCHAR(255),
    OUT gryffindor_score INT,
    OUT slytherin_score INT,
    OUT ravenclaw_score INT,
    OUT hufflepuff_score INT
)
BEGIN
    DECLARE total_score INT;

    -- Match the input answer_text with SortingAnswers and fetch scores
    SELECT
        IFNULL(SUM(sa.gryffindor_points), 0),
        IFNULL(SUM(sa.slytherin_points), 0),
        IFNULL(SUM(sa.ravenclaw_points), 0),
        IFNULL(SUM(sa.hufflepuff_points), 0)
    INTO
        gryffindor_score,
        slytherin_score,
        ravenclaw_score,
        hufflepuff_score
    FROM SortingAnswers sa
    WHERE sa.answer_text = answer_text;

    -- Calculate the total score
    SET total_score = gryffindor_score + slytherin_score + ravenclaw_score + hufflepuff_score;

     -- Determine the winning house
     IF total_score = 0 THEN
        SET winning_house = 'Invalid answer';
    ELSE
        IF gryffindor_score >= slytherin_score AND gryffindor_score >= ravenclaw_score AND gryffindor_score >= hufflepuff_score THEN
            SET winning_house = 'Gryffindor';
        ELSEIF slytherin_score >= gryffindor_score AND slytherin_score >= ravenclaw_score AND slytherin_score >= hufflepuff_score THEN
            SET winning_house = 'Slytherin';
        ELSEIF ravenclaw_score >= gryffindor_score AND ravenclaw_score >= slytherin_score AND ravenclaw_score >= hufflepuff_score THEN
            SET winning_house = 'Ravenclaw';
        ELSE
            SET winning_house = 'Hufflepuff';
        END IF;
    END IF;

END$$

DELIMITER ;

-- CALL SortingHatCeremony(1, 'Bravery', @winning_house, @gryffindor_score, @slytherin_score, @ravenclaw_score, @hufflepuff_score);
