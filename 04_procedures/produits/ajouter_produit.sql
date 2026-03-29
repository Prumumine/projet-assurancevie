CREATE OR REPLACE PROCEDURE Ajouter_Produit(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_nom_produit IN VARCHAR2,
    p_description IN VARCHAR2,
    p_type_produit IN VARCHAR2,
    p_montant_min IN NUMBER,
    p_taux_commission IN NUMBER
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

        IF v_role NOT IN ('GESTIONNAIRE','ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée pour ce rôle applicatif');
        END IF;
    END IF;

    -- Insertion client
    INSERT INTO PRODUIT(NOM_PRODUIT, DESCRIPTION, TYPE_PRODUIT, MONTANT_MIN, TAUX_COMMISSION)
    VALUES(p_nom_produit, p_description, p_type_produit, p_montant_min, p_taux_commission);
    

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur lors de l''ajout du produit: ' || SQLERRM);
END;
/