SET SERVEROUTPUT ON;

BEGIN
    Supprimer_Client(
        p_id_user_app => 2,  -- GESTIONNAIRE
        p_id_client => 24     -- BOUGMA
    );
    DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 1: ' || SQLERRM);
END;
/
