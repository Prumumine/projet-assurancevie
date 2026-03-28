CREATE OR REPLACE PROCEDURE Modifier_Agent(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_agent IN NUMBER,
    p_numero_matricule IN VARCHAR2 DEFAULT NULL,
    p_nom IN VARCHAR2 DEFAULT NULL,
    p_prenom IN VARCHAR2 DEFAULT NULL,
    p_telephone IN VARCHAR2 DEFAULT NULL,
    p_date_embauche IN DATE DEFAULT NULL
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

    -- Vérifier que le client existe
    SELECT COUNT(*) INTO v_count
    FROM AGENT_COMMERCIAL
    WHERE ID_AGENT = p_id_agent;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Agent inexistant');
    END IF;

    -- Modification
    UPDATE AGENT_COMMERCIAL
    SET NUMERO_MATRICULE = NVL(p_numero_matricule, NUMERO_MATRICULE),
        NOM = NVL(p_nom, NOM),
        PRENOM = NVL(p_prenom, PRENOM),
        TELEPHONE = NVL(p_telephone, TELEPHONE),
        DATE_EMBAUCHE = NVL(p_date_embauche, DATE_EMBAUCHE),
        UPDATED_AT = SYSDATE
    WHERE ID_AGENT = p_id_agent;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification agent: '||SQLERRM);
END;
/