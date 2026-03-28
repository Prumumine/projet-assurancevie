CREATE OR REPLACE PROCEDURE Modifier_Statut_Paiement(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_paiement IN NUMBER,
    p_statut IN VARCHAR2 DEFAULT 'EN_ATTENTE'
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

    -- Vérifier que le paiement existe
    SELECT COUNT(*) INTO v_count
    FROM PAIEMENT
    WHERE ID_PAIEMENT = p_id_paiement;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Paiement inexistant');
    END IF;

    -- Modification
    UPDATE PAIEMENT
    SET STATUT = NVL(p_statut, STATUT),
        UPDATED_AT = SYSDATE
    WHERE ID_PAIEMENT = p_id_paiement;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification du paiement: '||SQLERRM);
END;
/