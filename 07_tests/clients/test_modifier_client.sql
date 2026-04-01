SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO CLIENT (ID_CLIENT, NUMERO_IDENTITE, NOM, PRENOM, DATE_NAISSANCE, TELEPHONE, ADRESSE, PROFESSION) VALUES (999, 'TEST-CLI-999', 'TestOld', 'Old', SYSDATE - 365*30, '999999', 'Old Addr', 'OldProf');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test client 999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_CLIENT',
            p_params => q'{(p_id_client => 999, p_nom => 'ClientUpdated')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) MODIFIER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_CLIENT',
            p_params => q'{(p_id_client => 999, p_nom => 'GestUpdated', p_adresse => 'New Addr')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client modifié avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Teardown
BEGIN
  DELETE FROM CLIENT WHERE ID_CLIENT = 999;
  COMMIT;
END;
/

