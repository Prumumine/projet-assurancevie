CREATE OR REPLACE PROCEDURE Historique_Client (
    p_session_user IN VARCHAR2
)
AS
    v_id_client NUMBER;
    v_role      VARCHAR2(30);
BEGIN
    SELECT client_id, role_name
    INTO v_id_client, v_role
    FROM APP_USERS
    WHERE username = p_session_user;

    FOR rec IN (
        SELECT *
        FROM V_HISTO_CLIENT
        WHERE 
            (v_role = 'ROLE_CLIENT' AND ID_CLIENT = v_id_client)

            OR

            (v_role = 'ROLE_AGENT' AND ID_CLIENT IN (
                SELECT DISTINCT ID_CLIENT
                FROM SOUSCRIPTION
                WHERE ID_AGENT = v_id_client
            ))

            OR

            (v_role = 'ROLE_GESTIONNAIRE')
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.CLIENT || ' | ' || rec.NOM_PRODUIT);
    END LOOP;

END;
/