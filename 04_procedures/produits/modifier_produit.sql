CREATE OR REPLACE PROCEDURE Modifier_Produit(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_produit IN NUMBER,
    p_nom_produit IN VARCHAR2,
    p_description IN VARCHAR2,
    p_type_produit IN VARCHAR2,
    p_montant_min IN NUMBER,
    p_taux_commission IN NUMBER
   
)
AS
    v_role VARCHAR2(20);
    v_count NUMBER;
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
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée');
        END IF;
    END IF;

    -- Vérifier que le produit existe
    SELECT COUNT(*) INTO v_count
    FROM PRODUIT
    WHERE ID_PRODUIT = p_id_produit;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Produit inexistant');
    END IF;

    -- Modification
    UPDATE PRODUIT
    SET NOM_PRODUIT = p_nom_produit,
        DESCRIPTION = p_description,
        TYPE_PRODUIT = p_type_produit,
        MONTANT_MIN = p_montant_min,
        TAUX_COMMISSION = p_taux_commission
    WHERE ID_PRODUIT = p_id_produit;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification du produit: '||SQLERRM);
END;
/