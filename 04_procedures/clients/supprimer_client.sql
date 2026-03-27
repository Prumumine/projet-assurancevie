CREATE OR REPLACE PROCEDURE Supprimer_Client(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_client IN NUMBER
)
AS
    v_role VARCHAR2(20);
    v_count NUMBER;
BEGIN
    -- Vérification RBAC
    IF p_id_user_app IS NOT NULL THEN
        SELECT ROLE INTO v_role
        FROM UTILISATEUR
        WHERE ID_UTILISATEUR = p_id_user_app;

        IF v_role NOT IN ('GESTIONNAIRE','ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée');
        END IF;
    END IF;

    -- Vérifier que le client existe
    SELECT COUNT(*) INTO v_count
    FROM CLIENT
    WHERE ID_CLIENT = p_id_client;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Client inexistant');
    END IF;

    --Vérifier qu'il n'a aucune souscription
    SELECT COUNT(*) INTO v_count
    FROM SOUSCRIPTION
    WHERE ID_CLIENT = p_id_client;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004,'Impossible de supprimer : client lié à des souscriptions');
    END IF;

    -- Suppression
    DELETE FROM CLIENT
    WHERE ID_CLIENT = p_id_client;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005,'Erreur suppression client: '||SQLERRM);
END;
/