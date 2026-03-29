CREATE OR REPLACE PROCEDURE Ajouter_Souscription(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_nom_souscription IN VARCHAR2,
    p_date_souscription IN DATE,
    p_duree IN NUMBER,
    p_date_fin IN DATE,
    p_montant_prime IN NUMBER,
    p_satut IN VARCHAR2
)
AS
    v_role VARCHAR2(20);
BEGIN
    -- Vérification RBAC
    IF p_id_user_app IS NOT NULL THEN
        BEGIN
            SELECT ROLE INTO v_role
            FROM UTILISATEUR
            WHERE ID_UTILISATEUR = p_id_user_app;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20002,'Utilisateur inexistant');
        END;

        IF v_role NOT IN ('CLIENT','AGENT','GESTIONNAIRE','ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée pour ce rôle applicatif');
        END IF;
    END IF;

    -- Insertion souscription
    INSERT INTO SOUSCRIPTION(DATE_SOUSCRIPTION, DUREE, DATE_FIN, MONTANT_PRIME, STATUT)
    VALUES(p_date_souscription, p_duree, p_date_fin, p_montant_prime, p_satut);
    

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur lors de l''ajout du souscription: ' || SQLERRM);
END;
/