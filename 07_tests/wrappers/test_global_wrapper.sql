SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé) - Test wrapper with AJOUTER_AGENT
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) GLOBAL_WRAPPER ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_AGENT',
            p_params => q'{(p_numero_matricule => 'TEST001', p_nom => 'Doe', p_prenom => 'John', p_telephone => '123', p_date_embauche => SYSDATE)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Wrapper success (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé) - Test wrapper with AJOUTER_AGENT
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) GLOBAL_WRAPPER ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_AGENT',
            p_params => q'{(p_numero_matricule => 'GEST-TEST001', p_nom => 'GestDoe', p_prenom => 'GestJohn', p_telephone => '456', p_date_embauche => SYSDATE)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Wrapper success avec succès');
        -- Teardown
        DELETE FROM AGENT_COMMERCIAL WHERE NUMERO_MATRICULE = 'GEST-TEST001';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

