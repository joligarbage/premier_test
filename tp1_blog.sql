DROP DATABASE IF EXISTS tp1_sql_blog;
CREATE DATABASE tp1_sql_blog CHARACTER SET 'utf8';
USE tp1_sql_blog;


/* LES TABLES */

CREATE TABLE Article (
	id INT UNSIGNED AUTO_INCREMENT,
	titre VARCHAR(100) NOT NULL,
	texte TEXT NOT NULL,
	resume TINYTEXT NOT NULL,
	auteur_id INT UNSIGNED NOT NULL,
	date_publication DATETIME NOT NULL,
	categorie_defaut INT UNSIGNED NOT NULL, 
	PRIMARY KEY(id)
)ENGINE=InnoDB;


CREATE TABLE Commentaire (
	id INT UNSIGNED AUTO_INCREMENT,
	article_id INT UNSIGNED NOT NULL,
	auteur_id INT UNSIGNED,
	texte TEXT NOT NULL,
	date_commentaire DATETIME NOT NULL,
	PRIMARY KEY(id)
)ENGINE=InnoDB;


CREATE TABLE Utilisateur (
	id INT UNSIGNED AUTO_INCREMENT,
	pseudo VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(50),
	password VARCHAR(255) NOT NULL,
	PRIMARY KEY(id)
)ENGINE=InnoDB;


CREATE TABLE Categorie (
	id INT UNSIGNED AUTO_INCREMENT,
	nom VARCHAR(150) NOT NULL,
	description TINYTEXT NOT NULL,
	PRIMARY KEY(id)
)ENGINE=InnoDB;


CREATE TABLE Categorie_article (
	categorie_id INT UNSIGNED,
	article_id INT UNSIGNED,
	PRIMARY KEY (categorie_id, article_id)
)ENGINE=InnoDB;



/*LES FOREIGN KEYS */

/*Foreign key de Article*/
ALTER TABLE Article
ADD CONSTRAINT fk_auteur_id FOREIGN KEY (auteur_id) REFERENCES Utilisateur(id);

ALTER TABLE Article
ADD CONSTRAINT fk_categorie_defaut_id FOREIGN KEY (categorie_defaut) REFERENCES Categorie(id);

/*Foreign key de Commentaire*/
ALTER TABLE Commentaire
ADD CONSTRAINT fk_commentaire_auteur_id FOREIGN KEY (auteur_id) REFERENCES Utilisateur(id) ON DELETE SET NULL;

ALTER TABLE Commentaire
ADD CONSTRAINT fk_article_article_id FOREIGN KEY (article_id) REFERENCES Article(id) ON DELETE CASCADE;


/*Foreign key de Categorie_article*/
ALTER TABLE Categorie_article
ADD CONSTRAINT fk_Categorie_article_categorie_id FOREIGN KEY (categorie_id) REFERENCES Categorie(id) ON DELETE CASCADE;

ALTER TABLE Categorie_article
ADD CONSTRAINT fk_Categorie_article_article_id FOREIGN KEY (article_id) REFERENCES Article(id) ON DELETE CASCADE;


/* LES INDEX */

/*Pour accelerer la page accueil*/
ALTER TABLE Article
ADD INDEX page_accueil (date_publication,titre,auteur_id,resume(50));

/*Pour accelerer la page d'affichage des commentaire d chaue article*/
ALTER TABLE Commentaire
ADD INDEX commentaire_article (article_id,date_commentaire,auteur_id,texte(100));
