-- TABLE messages ---------------------------------------------------------------


INSERT INTO "messages" ("id", "user_id", "subject_id", "content", "created_at", "updated_at") VALUES
(1,	1,	1,	'Je sais plus quoi penser de tuchel, ca a viré nagelsmann alors qu''on etait en quart de LDC toujours en couurse pour la Bundes et en coupe d''allemagne, mais bon Oliver Kahn a voulu montrer les crocs ont perd tous du coup ...',	'2023-05-22 20:47:34.404721',	'2023-05-22 20:47:34.404721'),
(2,	2,	2,	'avec la saison d''haaland , je vois pas comment il peut ne pas etre ballon d''or, il bat tous les records ',	'2023-05-22 20:48:16.390993',	'2023-05-22 20:48:16.390993'),
(3,	1,	3,	'Je confirme c''est un infiltré il a tué l''équipe sur la fin de saison ',	'2023-05-23 09:09:29.648934',	'2023-05-23 09:09:29.648934'),
(4,	3,	2,	'Haaland fait une saison stratosphérique ',	'2023-05-23 09:10:14.565336',	'2023-05-23 09:10:14.565336');

-- TABLE Subjects ---------------------------------------------------------------

INSERT INTO "subjects" ("id", "user_id", "name", "created_at", "updated_at") VALUES
(1,	1,	'Pourquoi Tuchel est entrain de tuer le Bayern ',	'2023-05-22 20:42:12.673702',	'2023-05-22 20:42:12.673702'),
(2,	2,	'Haaland sera-t-il ballon d''or ?',	'2023-05-22 20:42:34.905397',	'2023-05-22 20:42:34.905397'),
(3,	2,	'Mbappé doit-il quitté le PSG ?',	'2023-05-22 21:14:36.659696',	'2023-05-22 21:14:36.659696'),
(7,	3,	'Tuchel est il un envoyé de dortmund ?',	'2023-05-23 09:08:06.028999',	'2023-05-23 09:08:06.028999');

-- TABLE Products ---------------------------------------------------------------

INSERT INTO "products" ("id", "user_id", "name", "price", "reduction", "description", "image", "created_at", "updated_at") VALUES
(1,	1,	'Maillot Bayern Munchen 2022/2023',	'$90.00',	NULL,	'Maillot domicile Homme année 2022-2023
avec ce magnifique maillot on fait une belle saison blanche parce qu''on a viré nagelsmann',	NULL,	'2023-05-22 20:35:52.444643',	'2023-05-22 20:35:52.444643'),
(2,	2,	'Maillot Manchester City 2022/2023',	'$90.00',	NULL,	'Maillot avec Haaland va soulever la Ligue des champions',	NULL,	'2023-05-22 20:37:05.146065',	'2023-05-22 20:37:05.146065'),
(3,	3,	'Maillot Borussia Dortmund 2022/ 2023',	'$89.00',	NULL,	'Maillot des éternels 2eme de Bundesliga sauf peut etre cette année',	NULL,	'2023-05-23 09:01:10.109248',	'2023-05-23 09:01:10.109248'),
(4,	1,	'Maillot Arsenal 2022/2023',	'$89.00',	NULL,	'Dominateur pendant plus de 200jours pour en fin de compte perdre la PL',	NULL,	'2023-05-23 09:03:06.8413',	'2023-05-23 09:03:06.8413'),
(5,	2,	'Maillot extérieur Manchester City 2022/2023',	'$85.00',	NULL,	'Maillot extérieur noir et fluo ',	NULL,	'2023-05-23 09:04:56.838599',	'2023-05-23 09:04:56.838599'),
(6,	3,	'Maillot extérieur Arsenal 2022/2023',	'$80.00',	NULL,	'Maillot full black ',	NULL,	'2023-05-23 09:06:03.507462',	'2023-05-23 09:06:03.507462');


-- TABLE Commands ---------------------------------------------------------------

INSERT INTO "commands" ("id", "user_id", "created_at", "updated_at") VALUES
(1,	1,	'2023-05-22 20:37:22.183738',	'2023-05-22 20:37:22.183738'),
(2,	3,	'2023-05-23 09:15:44.591081',	'2023-05-23 09:15:44.591081'),
(3,	2,	'2023-05-23 09:15:51.474456',	'2023-05-23 09:15:51.474456');

-- Table Command_products ---------------------------------------------------------------

INSERT INTO "product_command" ("product_id", "command_id") VALUES
(1,	1),
(4,	2),
(3,	2);

-- TABLE Images ---------------------------------------------------------------

INSERT INTO "images" ("id", "product_id", "user_id", "created_at", "updated_at", "content") VALUES
(1,	1,	1,	'2023-05-22 20:54:57.651155',	'2023-05-22 20:54:57.651155',	NULL),
(2,	2,	2,	'2023-05-22 20:55:06.152372',	'2023-05-22 20:55:06.152372',	NULL),
(3,	1,	1,	'2023-05-22 21:17:13.595279',	'2023-05-22 21:17:13.595279',	NULL);