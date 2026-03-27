CREATE OR REPLACE PROCEDURE Modifier_Client(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_id_client IN NUMBER,
    p_numero_identite IN VARCHAR2,
    p_nom IN VARCHAR2,
    p_prenom IN VARCHAR2,
    p_date_naissance IN DATE,
    p_telephone IN VARCHAR2,
    p_adresse IN VARCHAR2,
    p_profession IN VARCHAR2
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

    -- Modification
    UPDATE CLIENT
    SET NUMERO_IDENTITE = p_numero_identite,
        NOM = p_nom,
        PRENOM = p_prenom,
        DATE_NAISSANCE = p_date_naissance,
        TELEPHONE = p_telephone,
        ADRESSE = p_adresse,
        PROFESSION = p_profession
    WHERE ID_CLIENT = p_id_client;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur modification client: '||SQLERRM);
END;
/