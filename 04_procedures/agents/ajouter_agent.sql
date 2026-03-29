CREATE OR REPLACE PROCEDURE Ajouter_Agent(
    p_id_user_app IN NUMBER DEFAULT NULL,
    p_numero_matricule IN VARCHAR2,
    p_nom IN VARCHAR2,
    p_prenom IN VARCHAR2,
    p_telephone IN VARCHAR2,
    p_date_embauche IN DATE
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

        IF v_role NOT IN ('GESTIONNAIRE','ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20001,'Permission refusée pour ce rôle applicatif');
        END IF;
    END IF;

    -- Insertion agent
    INSERT INTO AGENT_COMMERCIAL(NUMERO_MATRICULE, NOM, PRENOM,TELEPHONE, DATE_EMBAUCHE)
    VALUES(p_numero_matricule, p_nom, p_prenom, p_telephone, p_date_embauche);


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'Erreur lors de l''ajout du agent: ' || SQLERRM);
END;
/