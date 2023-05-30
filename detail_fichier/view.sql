-- VUE POUR AFFICHER LES PRODUITS CRÉER PAR LES DIFFÉRENTS UTILISATEURS

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

-- VUE POUR AFFICHER L'ENSEMBLE DES MESSAGES RÉDIGER 

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

-- VUE POUR AFFICHER LES SUJETS CRÉÉ PAR LES UTILISATEURS 

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