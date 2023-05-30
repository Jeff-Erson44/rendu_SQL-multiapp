    BEGIN;

    --Insertion d'un nouveau sujet 
    INSERT INTO subjects(name, user_id) VALUES('Mbappé doit-il quitté le PSG ', 2);
    UPDATE subjects SET name = 'Mbappé doit-il quitté le PSG ?' WHERE id = 3;

    END;

