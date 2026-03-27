CREATE OR REPLACE PROCEDURE Modifier_Statut_Souscription(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_souscription IN NUMBER,
    p_statut IN VARCHAR2
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

    -- Vérifier que la souscription existe
    SELECT COUNT(*) INTO v_count
    FROM SOUSCRIPTION
    WHERE ID_SOUSCRIPTION = p_id_souscription;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Souscription inexistant');
    END IF;

    -- Modification
    UPDATE SOUSCRIPTION
    SET STATUT = p_statut
    WHERE ID_SOUSCRIPTION = p_id_souscription;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification du statut de la souscription: '||SQLERRM);
END;
/