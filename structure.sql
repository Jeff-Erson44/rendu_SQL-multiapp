-- CREÉATION DES SCHÉMA DE L'APPLIACTION

-- créer schéma Shop
CREATE SCHEMA Shop;
-- création du schéma Forum
CREATE SCHEMA Forum;

CREATE SCHEMA Images;


-- CREÉATION DES TABLES DE L'APPLIACTION

-- ON CRÉE LA TABLE USER EN GLOBAL DANS LE SCHEMA PUBLIC POUR ÉVITER D'AVOIR UNE TABLE USER DANS LES DIFFÉRENTS SCHEMA, 
-- NOTRE APPLICATION AUTHENTIFIERA LE USER UNE SEULE FOIS PEU IMPORTE L'ACTION QU'IL DÉSIRE EFFECTUER SUR LE SITE 

-- Création de domain pour la vérification des champs pour la création d'un compte 

-- Création d'un nouveau domaine avec une contrainte de validation pour l'email
CREATE DOMAIN email_type AS VARCHAR
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Création d'un nouveau domaine avec une contrainte de validation pour le mot de passe
CREATE DOMAIN password_type AS VARCHAR
    CHECK (LENGTH(VALUE) >= 8 AND VALUE ~ '[A-Z]');

DROP TABLE users;

-- création de la table users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0), -- on vérifie que l'id est supérieur à 0
    email email_type NOT NULL UNIQUE, -- unique pour éviter d'avoir plusisuer fois le même email + permettra de générer le token de récupération de mot de passe 
    password VARCHAR(128) NOT NULL, -- 128 caratères pour le hash du mot de passe SHA512(64 octest)
    username VARCHAR(50) NOT NULL UNIQUE,
    user_count BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifier son mdp ou son email, le timestamp sera mis à jour
);

-- CRÉATION DE LA TABLE Products , Commandes et Product_commands (realtion Many-to-many)  DANS LE SCHÉMA SHOP

DROP TABLE products;

-- Création d'un nouveau domaine avec une contrainte de validation pour le prix
CREATE DOMAIN positive_price AS MONEY   
    CHECK (VALUE >= 0);

-- création de la table products

CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE, -- on supprime le user et ses produits / on récupère les produits mis en vente par le user via son user id du schéma public
    name VARCHAR(100) NOT NULL UNIQUE,
    price positive_price, -- un produit sans prix et sans prix positif ne sera pas accepté
    reduction DECIMAL,
    description TEXT,
    image VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifie un champs de son produit, le timestamp sera mis à jour
);


CREATE TABLE IF NOT EXISTS commands (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifie un champs de son produit, le timestamp sera mis à jour
);


CREATE TABLE IF NOT EXISTS product_command(
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
    command_id BIGINT NOT NULL REFERENCES commands(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- CRÉATION DE LA TABLE Subject et Message DANS LE SCHÉMA FORUM

DROP TABLE subjects;

-- création de la table subjects
CREATE TABLE IF NOT EXISTS subjects(
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);


-- création de la table des messages 
CREATE TABLE IF NOT EXISTS messages(
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subject_id BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE ON UPDATE CASCADE,
    content VARCHAR(500), -- je veux limité la longueur d'un message a 500 caractères raison pour laquelle je ne met pas un TEXT 
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- CRÉATION DE LA TABLE images DANS LE SCHÉMA IMAGE

DROP TABLE images;

-- création de la table images

CREATE TABLE IF NOT EXISTS images(
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    product_id BIGINT NOT NULL REFERENCES shop.products(id) ON DELETE CASCADE ON UPDATE CASCADE,
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE, -- dans le cas ou l'on voudrait trier la gallerie photo par le nom d'un user
    content VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- CRÉATION DES VIEWS DE L'APPLIACTION

-- Vue pour afficher les produits créé par les utilisateurs

CREATE VIEW users_products
AS
    SELECT 
        U.id AS user_id,
        u.username,
        P.id AS product_id,
        P.name,
        price,
        description,
        image
    FROM public.users AS U
    JOIN products AS P
        ON U.id = P.user_id;

SELECT username, name, price, image FROM users_products;


-- vue pour afficher les produits par prix croissant

CREATE VIEW products_by_price AS
    SELECT *
    FROM products
    ORDER BY price ASC;

SELECT * FROM products_by_price;


-- Vue pour afficher l'ensemble des messages rédigés par les utilisateurs

CREATE VIEW users_messages
AS
    SELECT 
        U.id AS user_id,
        content,
        P.id AS message_id
    FROM public.users AS U
    JOIN messages AS P
        ON U.id = P.user_id;

SELECT content FROM users_messages;

-- Vue pour afficher les sujets créé par les utilisateurs

CREATE VIEW users_subjects
AS
    SELECT 
        U.id AS user_id,
        P.name,
        P.id AS subjects_id
    FROM public.users AS U
    JOIN subjects AS P
        ON U.id = P.user_id;

SELECT name FROM users_subjects

-- vue pour afficher les messages écrit sur un sujet précis

CREATE VIEW subject_messages AS
    SELECT
        M.id AS message_id,
        M.content,
        M.user_id
    FROM
        Messages AS M
    WHERE
        M.subject_id = 1;

SELECT message_id, content, user_id FROM subject_messages;


-- CREATION DES TRIGGERS

-- Trigger pour compter le nombre d'utilisateur créé depuis le début
CREATE OR REPLACE FUNCTION trigger_user_count()
RETURNS TRIGGER
AS $$
    BEGIN
        UPDATE users SET  user_count =  user_count + 1;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER incr_user_count
    AFTER INSERT ON users
    EXECUTE PROCEDURE trigger_user_count();

-- CREATION D'UNE FONCTION QUI SUPPRIME LES PRODUITS QUI SONT EN BASE DE DONNÉES DEPUIS PLUS D'UN AN 

CREATE OR REPLACE FUNCTION delete_old_products()
RETURNS VOID AS $$
    BEGIN
        DELETE FROM products WHERE created_at < NOW() - INTERVAL '1 year';
    END;
$$ LANGUAGE PLPGSQL;


