SET SERVEROUTPUT ON;
-----------------------------
-- PROCÉDURE PRODUIT 
-----------------------------
CREATE OR REPLACE PROCEDURE Supprimer_Produit(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_produit IN NUMBER
)
AS
    v_role  VARCHAR2(20);
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
        RAISE_APPLICATION_ERROR(-20003,'Produit inexistant');
    END IF;

    -- Vérifier qu'il n'a aucune souscription
    SELECT COUNT(*) INTO v_count
    FROM SOUSCRIPTION
    WHERE ID_PRODUIT = p_id_produit;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004,'Impossible de supprimer : produit lié à des souscriptions');
    END IF;

    -- Suppression
    UPDATE PRODUIT
    SET DELETED_AT = SYSDATE,
        UPDATED_AT = SYSDATE
    WHERE ID_PRODUIT = p_id_produit;


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005,'Erreur suppression du produit: '||SQLERRM);
END;
/