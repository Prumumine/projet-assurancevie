SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO CLIENT (ID_CLIENT, NUMERO_IDENTITE, NOM, PRENOM, DATE_NAISSANCE, TELEPHONE, ADRESSE, PROFESSION) VALUES (999, 'TEST-CLI-999', 'Test', 'ToDelete', SYSDATE - 365*30, '999999', 'Test Addr', 'TestProf');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test client 999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_CLIENT',
            p_params => q'{(p_id_client => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) SUPPRIMER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_CLIENT',
            p_params => q'{(p_id_client => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client supprimé avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Teardown (if needed)
BEGIN
  DELETE FROM CLIENT WHERE ID_CLIENT = 999;
  COMMIT;
END;
/

