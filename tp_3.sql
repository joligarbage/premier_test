
/*Exercice 1 */

/*On ajoute la colonne nb_commentaire à la table article pour stocker le nombre de commentaires pour chaque article*/
ALTER TABLE Article ADD COLUMN nb_commentaires INT DEFAULT 0;

/*On met à jour la table Article en fonction du nombre de commentaires déjà existant*/
UPDATE Article SET nb_commentaires = (select count(*) from commentaire where commentaire.article_id=Article.id);

/*On met en place les triggers permettant de mettre à jour automatiquement nb_commentaire de article à chaque ajout/suppression de commentaire*/
DELIMITER |
CREATE TRIGGER after_insert_commentaire AFTER INSERT
ON Commentaire FOR EACH ROW
BEGIN
    UPDATE Article
    SET nb_commentaires = nb_commentaires +1
    WHERE id = NEW.article_id;
END |

CREATE TRIGGER after_delete_commentaire AFTER DELETE
ON Commentaire FOR EACH ROW
BEGIN
    UPDATE Article
    SET nb_commentaires = nb_commentaires -1
    WHERE id = OLD.article_id;
END |

DELIMITER ;



/*Exercice 2 */

/*Création d'un trigger à l'insertion d'un nouvel article crée automatiquement un résumé en prenant les 150 premiers caractères de l’article, si l’auteur n’en a pas écrit. */
DELIMITER |
CREATE TRIGGER before_insert_article BEFORE INSERT
ON Article FOR EACH ROW
BEGIN
	IF NEW.resume IS NULL
    THEN SET NEW.resume=RPAD(NEW.contenu, 150, ' ');
    END IF;
END |
DELIMITER ;



/*Exercice 3 */

/*On crée une vue materialisée contenant les infos voulue : info utilisateur, le nombre d’articles écrits, la date du dernier article, le nombre de commentaires écrits et la date du dernier commentaire*/
CREATE TABLE VM_Stat_utilisateurs
ENGINE = InnoDB
SELECT Utilisateur.id AS Utilisateur_id, Utilisateur.pseudo AS Utilisateur_pseudo, count(DISTINCT Article.id) AS NB_articles, 
max(Article.date_publication) AS Date_dernier_article, count(DISTINCT Commentaire.id) AS NB_commentaires, max(Commentaire.date_commentaire) AS Date_dernier_commentaire

FROM Utilisateur 
left outer join Article on Utilisateur.id = Article.auteur_id
left outer join Commentaire on Utilisateur.id = Commentaire.auteur_id

GROUP BY Utilisateur.id;

/*Un INDEX sur les pseudo d'utilisateurs pour accellerer d'éventuelle recherches */
ALTER TABLE VM_Stat_utilisateurs ADD INDEX (Utilisateur_pseudo);


/*On crée une procedue de mise à jour de la vue matérialisée */
DELIMITER |
CREATE PROCEDURE maj_vm_stat_utilisateurs()
BEGIN
    TRUNCATE VM_Stat_utilisateurs;

    INSERT INTO VM_Stat_utilisateurs
	SELECT Utilisateur.id AS Utilisateur_id, Utilisateur.pseudo AS Utilisateur_pseudo, count(DISTINCT Article.id) AS NB_articles, 
max(Article.date_publication) AS Date_dernier_article, count(DISTINCT Commentaire.id) AS NB_commentaires, max(Commentaire.date_commentaire) AS Date_dernier_commentaire

	FROM Utilisateur 
	left outer join Article on Utilisateur.id = Article.auteur_id
	left outer join Commentaire on Utilisateur.id = Commentaire.auteur_id

	GROUP BY Utilisateur.id;
END |
DELIMITER ;


/*Pour appeler la procedue de mise à jour de VM_Stat_utilisateurs*/
CALL maj_vm_stat_utilisateurs();