SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO AGENT_COMMERCIAL (NUMERO_MATRICULE, NOM, PRENOM, TELEPHONE, DATE_EMBAUCHE) VALUES ('TEST-999', 'Test', 'ToDelete', '999999', SYSDATE);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test agent ID ~999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_AGENT',
            p_params => q'{(p_id_agent => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) SUPPRIMER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_AGENT',
            p_params => q'{(p_id_agent => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent supprimé avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Teardown
BEGIN
  DELETE FROM AGENT_COMMERCIAL WHERE NUMERO_MATRICULE = 'TEST-999';
  COMMIT;
END;
/

