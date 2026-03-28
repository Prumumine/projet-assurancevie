CREATE OR REPLACE PROCEDURE Modifier_Client(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_client IN NUMBER,
    p_numero_identite IN VARCHAR2 DEFAULT NULL,
    p_nom IN VARCHAR2 DEFAULT NULL,
    p_prenom IN VARCHAR2 DEFAULT NULL,
    p_date_naissance IN DATE DEFAULT NULL,
    p_telephone IN VARCHAR2 DEFAULT NULL,
    p_adresse IN VARCHAR2 DEFAULT NULL,
    p_profession IN VARCHAR2 DEFAULT NULL
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
    FROM CLIENT
    WHERE ID_CLIENT = p_id_client;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,'Client inexistant');
    END IF;

    -- Modification
    UPDATE CLIENT
    SET NUMERO_IDENTITE = NVL(p_numero_identite, NUMERO_IDENTITE),
        NOM = NVL(p_nom, NOM),
        PRENOM = NVL(p_prenom, PRENOM),
        DATE_NAISSANCE = NVL(p_date_naissance, DATE_NAISSANCE),
        TELEPHONE = NVL(p_telephone, TELEPHONE),
        ADRESSE = NVL(p_adresse, ADRESSE),
        PROFESSION = NVL(p_profession, PROFESSION),
        UPDATED_AT = SYSDATE
    WHERE ID_CLIENT = p_id_client;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification client: '||SQLERRM);
END;
/