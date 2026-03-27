@@ajout_utilisateur_app.sql
@@ajout_client_test_data.sql

SET SERVEROUTPUT ON;

BEGIN
    Supprimer_Client(
        p_id_user_app => 2,  -- GESTIONNAIRE (ID=2)
        p_id_client => 5     -- BOUGMA (ID=5)
    );
    DBMS_OUTPUT.PUT_LINE('✅ Supprimer_Client Test 1: SUCCÈS');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Supprimer_Client Test 1: ' || SQLERRM);
END;
/

-- Vérification suppression
SELECT 'Client supprimé ✓' as STATUS FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM CLIENT WHERE ID_CLIENT = 5);

