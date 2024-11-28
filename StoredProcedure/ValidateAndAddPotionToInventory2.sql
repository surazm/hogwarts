DELIMITER $$

CREATE PROCEDURE ValidateAndAddPotionToInventory2(
    IN player_id INT,
    IN potion_id INT,
    IN stir_inputs TEXT,          -- Comma-separated stir directions entered by the player
    IN action_inputs TEXT         -- Comma-separated actions entered by the player
)
BEGIN
    DECLARE step_count INT;
    DECLARE correct_stir_direction VARCHAR(255);
    DECLARE correct_action_required VARCHAR(255);
    DECLARE success_status INT DEFAULT 1;  -- Start with success (1)
    DECLARE stir_input VARCHAR(255);
    DECLARE action_input VARCHAR(255);
    DECLARE idx INT DEFAULT 1;  -- Index for the steps

    -- Step 1: Get the number of steps for this potion
    SELECT COUNT(*) INTO step_count
    FROM PotionRecipe
    WHERE potion_id = potion_id;

    -- Step 2: Start looping through each step of the potion
    potion_creation_loop: LOOP
        -- Exit the loop if we have checked all steps
        IF idx > step_count THEN
            LEAVE potion_creation_loop;
        END IF;

        -- Get the required stir direction and action for the current step
        SELECT stir_direction, action_required
        INTO correct_stir_direction, correct_action_required
        FROM PotionRecipe
        WHERE potion_id = potion_id;  -- Assuming `step_number` exists in PotionRecipe

        -- Get the corresponding stir_input and action_input for the current step from the player's input
        SET stir_input = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(stir_inputs, ',', idx), ',', -1));
        SET action_input = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(action_inputs, ',', idx), ',', -1));

        -- Step 3: Compare stir_input and action_input with the required values for the current step
        IF stir_input = correct_stir_direction AND action_input = correct_action_required THEN
            -- Both inputs are correct for this step
            SET success_status = success_status * 1;  -- Continue with success status (no change)
        ELSE
            -- If any input is incorrect, mark the potion creation as a failure
            SET success_status = 0;
            LEAVE potion_creation_loop;  -- Exit the loop as the potion creation has failed
        END IF;

        -- Move to the next step
        SET idx = idx + 1;
    END LOOP;

    -- Step 4: Add the potion to the player's inventory with the success status
    INSERT INTO PlayerInventory (player_id, potion_id, success_status)
    VALUES (player_id, potion_id, success_status);

    -- Optionally, return a message indicating the result
    SELECT 'Potion added to inventory for player_id: ', player_id,
           ' with success status: ', success_status;

END $$

DELIMITER ;


CALL ValidateAndAddPotionToInventory2(
    1,                         -- player_id
    1,                       -- potion_id
    'Clockwise,Counter-Clockwise,Clockwise',  -- stir directions entered by the player
    'Add Dragon Blood,Add Mandrake Root,Add Phoenix Feather'  -- actions entered by the player
);
