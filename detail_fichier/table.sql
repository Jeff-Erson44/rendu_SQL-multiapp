-- ON CRÉE LA TABLE USER EN GLOBAL DANS LE SCHEMA PUBLIC POUR ÉVITER D'AVOIR UNE TABLE USER DANS LES DIFFÉRENTS SCHEMA, 
-- NOTRE APPLICATION AUTHENTIFIERA LE USER UNE SEULE FOIS PEU IMPORTE L'ACTION QU'IL DÉSIRE EFFECTUER SUR LE SITE 

DROP TABLE users;

CREATE DOMAIN email_type AS VARCHAR
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


-- création de la table users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0), -- on vérifie que l'id est supérieur à 0
    email email_type NOT NULL UNIQUE, -- unique pour éviter d'avoir plusisuer fois le même email + permettra de générer le token de récupération de mot de passe 
    password VARCHAR(128) NOT NULL, -- 128 caratères pour le hash du mot de passe SHA512(64 octest)
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifier son mdp ou son email, le timestamp sera mis à jour
);

INSERT INTO "users" ("id", "email", "password", "username", "created_at", "updated_at") VALUES
(1,	'jeff@gmail.com',	'root',	'jeff',	'2023-05-22 20:19:58.452194',	'2023-05-22 20:19:58.452194'),
(2,	'justine@gmail.com',	'root',	'justine',	'2023-05-22 20:20:11.999386',	'2023-05-22 20:20:11.999386');

-- CRÉATION DE LA TABLE Products , Commandes et Product_commands (realtion Many-to-many)  DANS LE SCHÉMA SHOP

DROP TABLE products;

-- création de la table products

CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE, -- on supprime le user et ses produits / on récupère les produits mis en vente par le user via son user id du schéma public
    name VARCHAR(100) NOT NULL UNIQUE,
    price MONEY NOT NULL, -- un produit sans prix ne sera pas accepté
    reduction DECIMAL,
    description TEXT,
    image VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifie un champs de son produit, le timestamp sera mis à jour
);

INSERT INTO "products" ("id", "user_id", "name", "price", "reduction", "description", "image", "created_at", "updated_at") VALUES
(1,	1,	'Maillot Bayern Munchen 2022/2023',	'$90.00',	NULL,	'Maillot domicile Homme année 2022-2023
avec ce magnifique maillot on fait une belle saison blanche parce qu''on a viré nagelsmann',	NULL,	'2023-05-22 20:35:52.444643',	'2023-05-22 20:35:52.444643'),
(2,	2,	'Maillot Manchester City 2022/2023',	'$90.00',	NULL,	'Maillot avec Haaland va soulever la Ligue des champions',	NULL,	'2023-05-22 20:37:05.146065',	'2023-05-22 20:37:05.146065');

CREATE TABLE IF NOT EXISTS commands (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW() -- si le user modifie un champs de son produit, le timestamp sera mis à jour
);

INSERT INTO "commands" ("id", "user_id", "created_at", "updated_at") VALUES
(1,	1,	'2023-05-22 20:37:22.183738',	'2023-05-22 20:37:22.183738');

CREATE TABLE IF NOT EXISTS product_command(
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
    command_id BIGINT NOT NULL REFERENCES commands(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO "product_command" ("product_id", "command_id") VALUES
(1,	1);

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

INSERT INTO "subjects" ("id", "user_id", "name", "created_at", "updated_at") VALUES
(1,	1,	'Pourquoi Tuchel est entrain de tuer le Bayern ',	'2023-05-22 20:42:12.673702',	'2023-05-22 20:42:12.673702'),
(2,	2,	'Haaland sera-t-il ballon d''or ?',	'2023-05-22 20:42:34.905397',	'2023-05-22 20:42:34.905397'),
(4,	2,	'Mbappé doit-il quitté le PSG ',	'2023-05-22 21:15:21.32458',	'2023-05-22 21:15:21.32458'),
(6,	2,	'Mbappé doit-il quitté le PSG ',	'2023-05-22 21:16:09.674213',	'2023-05-22 21:16:09.674213'),
(3,	2,	'Mbappé doit-il quitté le PSG ?',	'2023-05-22 21:14:36.659696',	'2023-05-22 21:14:36.659696');


-- création de la table des messages 
CREATE TABLE IF NOT EXISTS messages(
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    subject_id BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE ON UPDATE CASCADE,
    content VARCHAR(500), -- je veux limité la longueur d'un message a 500 caractères raison pour laquelle je ne met pas un TEXT 
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO "messages" ("id", "user_id", "subject_id", "content", "created_at", "updated_at") VALUES
(1,	1,	1,	'Je sais plus quoi penser de tuchel, ca a viré nagelsmann alors qu''on etait en quart de LDC toujours en couurse pour la Bundes et en coupe d''allemagne, mais bon Oliver Kahn a voulu montrer les crocs ont perd tous du coup ...',	'2023-05-22 20:47:34.404721',	'2023-05-22 20:47:34.404721'),
(2,	2,	2,	'avec la saison d''haaland , je vois pas comment il peut ne pas etre ballon d''or, il bat tous les records ',	'2023-05-22 20:48:16.390993',	'2023-05-22 20:48:16.390993');

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

INSERT INTO "images" ("id", "product_id", "user_id", "created_at", "updated_at", "content") VALUES
(1,	1,	1,	'2023-05-22 20:54:57.651155',	'2023-05-22 20:54:57.651155',	NULL),
(2,	2,	2,	'2023-05-22 20:55:06.152372',	'2023-05-22 20:55:06.152372',	NULL),
(3,	1,	1,	'2023-05-22 21:17:13.595279',	'2023-05-22 21:17:13.595279',	NULL);