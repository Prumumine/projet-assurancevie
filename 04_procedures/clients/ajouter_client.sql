CREATE OR REPLACE PROCEDURE Ajouter_Client(
    p_id_user_app IN NUMBER DEFAULT NULL,
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

        IF v_role NOT IN ('CLIENT','AGENT','GESTIONNAIRE','ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée pour ce rôle applicatif');
        END IF;
    END IF;

    -- Insertion client
    INSERT INTO CLIENT(NUMERO_IDENTITE, NOM, PRENOM, DATE_NAISSANCE, TELEPHONE, ADRESSE, PROFESSION)
    VALUES(p_numero_identite, p_nom, p_prenom, p_date_naissance, p_telephone, p_adresse, p_profession);


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur lors de l''ajout du client: ' || SQLERRM);
END;
/