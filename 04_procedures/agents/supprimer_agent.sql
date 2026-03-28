SET SERVEROUTPUT ON;
-----------------------------
-- PROCÉDURE SUPPRIMER_CLIENT CORRIGÉE
-----------------------------
CREATE OR REPLACE PROCEDURE Supprimer_Agent(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_agent IN NUMBER
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

    -- Vérifier que le client existe
    SELECT COUNT(*) INTO v_count
    FROM AGENT_COMMERCIAL
    WHERE ID_AGENT = p_id_agent;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003,'Agent inexistant');
    END IF;

    -- Vérifier qu'il n'a aucune souscription
    SELECT COUNT(*) INTO v_count
    FROM SOUSCRIPTION
    WHERE ID_AGENT = p_id_agent;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004,'Impossible de supprimer : Agent lié à des souscriptions');
    END IF;

    -- Suppression
    DELETE FROM AGENT_COMMERCIAL
    WHERE ID_AGENT = p_id_agent;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005,'Erreur suppression Agent: '||SQLERRM);
END;
/