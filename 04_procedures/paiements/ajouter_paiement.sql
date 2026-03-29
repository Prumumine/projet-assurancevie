CREATE OR REPLACE PROCEDURE Ajouter_Paiement(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_date_paiement IN DATE,
    p_montant IN NUMBER,
    p_mode_paiement IN NUMBER,
    p_satut IN VARCHAR2,
    p_devise IN NUMBER
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
    INSERT INTO PAIEMENT(DATE_PAIEMENT, MONTANT, MODE_PAIEMENT, STATUT, DEVISE)
    VALUES(p_date_paiement, p_montant, p_mode_paiement, p_satut, p_devise);
    

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur lors de l''ajout du paiement: ' || SQLERRM);
END;
/