CREATE OR REPLACE PROCEDURE Ajouter_Agent_Safe(
    p_numero_matricule IN VARCHAR2,
    p_nom IN VARCHAR2,
    p_prenom IN VARCHAR2,
    p_telephone IN VARCHAR2,
    p_date_embauche IN DATE
)
AS
    v_current_user VARCHAR2(128);
BEGIN
    SELECT USER INTO v_current_user FROM DUAL;
    
    -- Simple USER check (fix SYS_CONTEXT ORA-02003)
    DECLARE
        v_username VARCHAR2(128);
    BEGIN
        v_username := USER;
        DBMS_OUTPUT.PUT_LINE('Debug - User: ' || v_username);
        IF UPPER(v_username) NOT IN ('GESTIONNAIRE', 'ADMIN') THEN
            RAISE_APPLICATION_ERROR(-20010, 
                'Permission insuffisante. Utilisateur connecté: ' || v_username || 
                '. Seuls GESTIONNAIRE_USER/ADMIN_USER autorisés.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('Debug user autorisé: ' || v_username);
    END;
    
    Ajouter_Agent(NULL, p_numero_matricule, p_nom, p_prenom, p_telephone, p_date_embauche);
END;
/