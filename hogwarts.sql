CREATE DATABASE hogwarts;
USE hogwarts;

CREATE TABLE SortingQuestions (
    question_id INT PRIMARY KEY,
    question_text TEXT -- The question asked to the player
);

INSERT INTO SortingQuestions (question_id, question_text) VALUES
(1, 'Which quality do you value most?'),
(2, 'What would you do in a difficult situation?'),
(3, 'Which magical subject are you most excited to study?');

CREATE TABLE SortingAnswers (
    answer_id INT PRIMARY KEY,
    question_id INT, -- Foreign key linking to SortingQuestions
    answer_text VARCHAR(255), -- The answer option text
    gryffindor_points INT DEFAULT 0, -- Points allocated to Gryffindor
    slytherin_points INT DEFAULT 0,  -- Points allocated to Slytherin
    ravenclaw_points INT DEFAULT 0,  -- Points allocated to Ravenclaw
    hufflepuff_points INT DEFAULT 0, -- Points allocated to Hufflepuff
    FOREIGN KEY (question_id) REFERENCES SortingQuestions(question_id)
);

INSERT INTO SortingAnswers (answer_id, question_id, answer_text, gryffindor_points, slytherin_points, ravenclaw_points, hufflepuff_points) VALUES
(1, 1, 'Bravery', 10, 0, 0, 0),       -- Adds 10 points to Gryffindor
(2, 1, 'Ambition', 0, 10, 0, 0),      -- Adds 10 points to Slytherin
(3, 1, 'Wisdom', 0, 0, 10, 0),        -- Adds 10 points to Ravenclaw
(4, 1, 'Loyalty', 0, 0, 0, 10),       -- Adds 10 points to Hufflepuff

(5, 2, 'Face it head-on', 10, 0, 0, 0),        -- Gryffindor
(6, 2, 'Plan a clever escape', 0, 10, 0, 0),   -- Slytherin
(7, 2, 'Analyze the situation', 0, 0, 10, 0),  -- Ravenclaw
(8, 2, 'Ask for help from friends', 0, 0, 0, 10), -- Hufflepuff

(9, 3, 'Defense Against the Dark Arts', 10, 0, 0, 0),   -- Gryffindor
(10, 3, 'Potions', 0, 10, 0, 0),                       -- Slytherin
(11, 3, 'Charms', 0, 0, 10, 0),                        -- Ravenclaw
(12, 3, 'Herbology', 0, 0, 0, 10);                     -- Hufflepuff

SELECT * FROM SortingAnswers;

CREATE TABLE Potions (
    potion_id INT PRIMARY KEY,
    potion_name VARCHAR(100),
    difficulty_lvl INT,
    base_success_rate DECIMAL(4,3),
    effect TEXT
);

INSERT INTO Potions (potion_id, potion_name, difficulty_lvl, base_success_rate, effect)
VALUES (1,'Healing Potion',1,0.9,'Heals 20 HP'),
       (2,'Mana Elixir',1,0.8,'Restores 15 Mana');

SELECT * FROM Potions;

CREATE TABLE PotionRecipe (
    potion_id INT,
    step_num INT,
    step_instruction TEXT,
    action_required VARCHAR(50),
    stir_direction VARCHAR(50),
    success_impact DECIMAL(4,3),
    FOREIGN KEY (potion_id) REFERENCES Potions(potion_id)
);

INSERT INTO PotionRecipe (potion_id, step_num, step_instruction, action_required, stir_direction, success_impact) VALUES
(1, 1, 'Add 1 Unicorn Hair', 'Add Unicorn Hair', Null, 0.05),
(1, 2, 'Stir the mixture clockwise 3 times', 'Stir Stir Stir', 'clockwise', 0.1),
(1, 3, 'Heat the cauldron for 2 minutes', 'Heat Heat',Null, 0.1),

(2, 1, 'Add 2 Mandrake Root', 'Add Mandrake Root Add Mandrake Root',Null, 0.1),
(2, 2, 'Stir counterclockwise 2 times', 'Stir Stir','clockwise', 0.05),
(2, 3, 'Wait 5 minutes', 'Wait',Null,0.05);

SELECT * FROM PotionRecipe;

CREATE TABLE Spells (
    spell_id INT PRIMARY KEY,
    spell_name VARCHAR(100),
    effect TEXT,
    mana_cost INT,
    difficulty_level INT
);

INSERT INTO Spells (spell_id, spell_name, effect, mana_cost, difficulty_level) VALUES
(1, 'Expelliarmus', 'Disarms opponent', 10, 1),
(2, 'Stupefy', 'Stuns opponent for one turn', 15, 2),
(3, 'Protego', 'Shields player for one turn', 12, 1),
(4, 'Incendio', 'Deals 20 fire damage', 20, 3),
(5, 'Obliviate','Erases memories',30,3),
(6,'Aqua Eructo','Produces water',20,3);

SELECT * FROM Spells;

CREATE TABLE PronunciationChallenge (
    spell_id INT,
    choice_id INT,
    choice_text VARCHAR(100), -- e.g., "Expelliarmus" (correct) vs. "Expelarmus" (incorrect)
    is_correct BOOLEAN, -- TRUE if it's the correct pronunciation
    PRIMARY KEY (spell_id,choice_id),
    FOREIGN KEY (spell_id) REFERENCES Spells(spell_id)
);

INSERT INTO PronunciationChallenge (spell_id, choice_id, choice_text, is_correct) VALUES
(1, 1, 'Expelliarmus', TRUE),
(1, 2, 'Expelarmus', FALSE),
(1, 3, 'Expelaramus', FALSE),
(1, 4, 'Exparmas', FALSE),

(2, 1, 'Stopify', FALSE),
(2, 2, 'Stupefy', TRUE),
(2, 3, 'Stupify', FALSE),
(2, 4, 'Stupafi', FALSE),

(3, 1, 'Protegero', FALSE),
(3, 2, 'Protogo', FALSE),
(3, 3, 'Protego', TRUE),
(3, 4, 'Protegro', FALSE),

(4, 1, 'Incendo', FALSE),
(4, 2, 'Incendio', TRUE),
(4, 3, 'Incendro', FALSE),
(4, 4, 'Ensendio', FALSE),

(5, 1, 'Obliviate', TRUE),
(5, 2, 'Oblivate', FALSE),
(5, 3, 'Oblivient', FALSE),
(5, 4, 'Oblibiate', FALSE),

(6, 1, 'Aqua Eructio', FALSE),
(6, 2, 'Agua Eracto', FALSE),
(6, 3, 'Aqua Arucio', FALSE),
(6, 4, 'Aqua Eructo', TRUE);

SELECT * FROM PronunciationChallenge;

CREATE TABLE WandMovementChallenge (
    spell_id INT,
    step_number INT,
    direction VARCHAR(50), -- Direction of the wand movement, e.g., "Up", "Down", "Left", "Right"
    FOREIGN KEY (spell_id) REFERENCES Spells(spell_id)
);

INSERT INTO WandMovementChallenge (spell_id, step_number, direction) VALUES
(1, 1, 'Up'),
(1, 2, 'Right'),
(1, 3, 'Down'),

(2,1,'Down'),
(2,2,'Right'),
(2,3,'Up'),
(2,4,'Down'),

(3,1,'Down'),
(3,2,'Up'),
(3,3,'Down'),

(4,1,'Down'),
(4,2,'Up'),
(4,3,'Up'),
(4,4,'Down'),
(4,5,'Left'),
(4,6,'Right');

SELECT * FROM WandMovementChallenge;

CREATE TABLE SpellMasteryLevels (
    spell_id INT,
    mastery_level INT,
    success_rate DECIMAL(4,3), -- Success rate at this mastery level
    mana_cost INT, -- Mana cost at this mastery level (may decrease with mastery)
    effect TEXT, -- Effect at this mastery level, e.g., "Deals 25 damage at level 3"
    FOREIGN KEY (spell_id) REFERENCES Spells(spell_id)
);

INSERT INTO SpellMasteryLevels (spell_id, mastery_level, success_rate, mana_cost, effect) VALUES
-- Expelliarmus: Disarms opponent
(1, 1, 0.6, 10, 'Disarms opponent'),
(1, 2, 0.7, 10, 'Disarms opponent'),
(1, 3, 0.8, 9, 'Disarms opponent and causes slight damage'),
(1, 4, 0.9, 8, 'Disarms opponent and reduces opponent''s mana'),
(1, 5, 1.0, 7, 'Disarms opponent and reduces opponent''s mana significantly'),

-- Stupefy: Stuns opponent
(2, 1, 0.5, 15, 'Stuns opponent for one turn'),
(2, 2, 0.65, 14, 'Stuns opponent for one turn'),
(2, 3, 0.8, 13, 'Stuns opponent for two turns'),
(2, 4, 0.9, 12, 'Stuns opponent for two turns and reduces accuracy of opponent''s spells'),
(2, 5, 1.0, 11, 'Stuns opponent for two turns, reduces accuracy and damage of opponent''s spell'),

-- Protego: Shields player
(3, 1, 0.6, 12, 'Shields player for one turn'),
(3, 2, 0.7, 11, 'Shields player and reduces damage by 20% for one turn'),
(3, 3, 0.8, 10, 'Shields player and reduces damage by 30% for two turns'),
(3, 4, 0.9, 10, 'Shields player, reduces damage by 40%, and reflects 10% damage'),
(3, 5, 1.0, 9, 'Shields player, reduces damage by 50%, and reflects 20% damage'),

-- Incendio: Deals fire damage
(4, 1, 0.5, 20, 'Deals 20 fire damage'),
(4, 2, 0.6, 19, 'Deals 25 fire damage'),
(4, 3, 0.75, 18, 'Deals 30 fire damage and has a chance to burn opponent'),
(4, 4, 0.85, 17, 'Deals 35 fire damage, burns opponent, and reduces opponent''s defense'),
(4, 5, 1.0, 16, 'Deals 40 fire damage, burns opponent, and weakens opponent''s next spell'),

-- Obliviate: Erases memory
(5, 1, 0.5, 18, 'Erases a small part of opponent''s memory, causing slight confusion'),
(5, 2, 0.65, 17, 'Erases a part of opponent''s memory, causing confusion for one turn'),
(5, 3, 0.8, 16, 'Erases memory, causes confusion for two turns, and reduces opponent''s spell accuracy'),
(5, 4, 0.9, 15, 'Erases memory, causes confusion for two turns, and weakens opponent''s spells'),
(5, 5, 1.0, 14, 'Completely erases memory, causing opponent confusion and inability to cast complex spells'),

-- Aqua Eructo: Conjures water jet
(6, 1, 0.55, 10, 'Conjures a jet of water to douse flames'),
(6, 2, 0.7, 9, 'Conjures a jet of water to douse flames and push objects back'),
(6, 3, 0.8, 8, 'Conjures a powerful water jet that douses flames and knocks back opponents'),
(6, 4, 0.9, 7, 'Conjures a powerful water jet that drenches opponent and slows their movements'),
(6, 5, 1.0, 6, 'Conjures a high-pressure water jet, douses flames, knocks back opponent, and stuns');

SELECT * FROM SpellMasteryLevels;

CREATE TABLE Duel (
    duel_id INT PRIMARY KEY,
    player1_id INT,
    player2_id INT,
    player1_health INT DEFAULT 100,
    player2_health INT DEFAULT 100,
    player1_mana INT DEFAULT 100,
    player2_mana INT DEFAULT 100,
    duel_status VARCHAR(50) DEFAULT 'in_progress', -- E.g., 'in_progress', 'won', 'lost'
    last_turn_by VARCHAR(50) -- Tracks the last action by 'player' or 'opponent'
);

CREATE TABLE DuelActions (
    action_id INT PRIMARY KEY,
    duel_id INT,
    turn_number INT,
    acting_player VARCHAR(50), -- 'player' or 'opponent'
    action_type VARCHAR(50), -- 'spell', 'potion', 'defend'
    spell_id INT, -- Links to the spell used (if any)
    damage INT, -- Damage dealt during this action
    mana_used INT, -- Mana used during this action
    result VARCHAR(100), -- E.g., "success", "missed", "stunned opponent"
    FOREIGN KEY (duel_id) REFERENCES Duel(duel_id),
    FOREIGN KEY (spell_id) REFERENCES Spells(spell_id)
);

CREATE TABLE PlayerProfile (
    player_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique player identifier
    player_name VARCHAR(100), -- Name of the player
    house VARCHAR(50), -- Assigned house (e.g., 'Gryffindor', 'Slytherin')
    xp_lvl INT DEFAULT 0 -- XP lvl
);

INSERT INTO PlayerProfile (player_name, house, xp_lvl) VALUES
('Harry Potter', 'Gryffindor', 3),
('Hermione Granger', 'Gryffindor', 3),
('Draco Malfoy', 'Slytherin', 3);

CREATE TABLE PlayerInventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique inventory item ID
    player_id INT, -- Links to PlayerProfile
    potion_id INT, -- Links to Potions table
    quantity INT DEFAULT 0, -- Quantity of the potion
    FOREIGN KEY (player_id) REFERENCES PlayerProfile(player_id),
    FOREIGN KEY (potion_id) REFERENCES Potions(potion_id)
);

INSERT INTO PlayerInventory (player_id, potion_id, quantity) VALUES
(1, 1, 3), -- Player 1 (Harry) has 3 Healing Potions
(1, 2, 2), -- Player 1 (Harry) has 2 Mana Elixirs
(2, 1, 5), -- Player 2 (Hermione) has 5 Healing Potions
(3, 2, 1); -- Player 3 (Draco) has 1 Mana Elixirs

CREATE TABLE PlayerSpells (
    player_id INT, -- Links to PlayerProfile
    spell_id INT, -- Links to Spells table
    spell_level INT DEFAULT 1, -- Current level of the spell
    practice_attempts INT DEFAULT 0, -- Number of practice attempts
    FOREIGN KEY (player_id) REFERENCES PlayerProfile(player_id),
    FOREIGN KEY (spell_id) REFERENCES Spells(spell_id)
);

INSERT INTO PlayerSpells (player_id, spell_id, spell_level, practice_attempts) VALUES
(1, 1, 3, 15), -- Harry has level 3 Expelliarmus and practiced it 15 times
(2, 2, 4, 20), -- Hermione has level 4 Stupefy and practiced it 20 times
(3, 4, 2, 10); -- Draco has level 2 Incendio and practiced it 10 times



