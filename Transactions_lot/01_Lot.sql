SET SERVEROUTPUT ON;

DECLARE
    id_client      CLIENT.ID_CLIENT%TYPE;
    date_naissance DATE;
    taille_batch   CONSTANT NUMBER := 100;
BEGIN
    FOR i IN 1..1000 LOOP
        BEGIN
            SAVEPOINT sp_client;

            -- Génération d'une date de naissance  (18 à 65 ans)
            date_naissance := ADD_MONTHS(TRUNC(SYSDATE), -12 * (18 + MOD(i,48)));

            -- Insertion du client
            INSERT INTO CLIENT (
                NOM, PRENOM, DATE_NAISSANCE, TELEPHONE, ADRESSE, PROFESSION
            )
            VALUES (
                'Nom' || i,
                'Prenom' || i,
                date_naissance,
                '70' || LPAD(i, 8, '0'),
                'Adresse ' || i,
                'Profession ' || MOD(i,10)
            )
            RETURNING ID_CLIENT INTO id_client;

            -- Insertion de la souscription associée
            INSERT INTO SOUSCRIPTION (
                ID_CLIENT,
                ID_AGENT,
                ID_PRODUIT,
                DUREE,
                MONTANT_PRIME,
                DATE_SOUSCRIPTION,
                STATUT
            )
            VALUES (
                id_client,
                MOD(i,5)+1,
                MOD(i,3)+1,
                12,
                100000 + i,
                SYSDATE,
                'ACTIVE'
            );

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO sp_client;
                DBMS_OUTPUT.PUT_LINE('Erreur à la ligne ' || i || ' : ' || SQLERRM);
        END;

        -- Commit par batch
        IF MOD(i, taille_batch) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE(taille_batch || ' clients insérés avec succès.');
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Insertion complète de tous les clients et souscriptions.');

END;
/