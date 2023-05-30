-- Création d'un nouveau domaine avec une contrainte de validation pour l'email
CREATE DOMAIN email_type AS VARCHAR
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Création d'un nouveau domaine avec une contrainte de validation pour le mot de passe
CREATE DOMAIN password_type AS VARCHAR
    CHECK (LENGTH(VALUE) >= 8 AND VALUE ~ '[A-Z]');


-- Création d'un nouveau domaine avec une contrainte de validation pour le prix
CREATE DOMAIN positive_price AS MONEY   
    CHECK (VALUE >= 0);