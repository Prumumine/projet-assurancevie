SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_CLIENT',
            p_params => q'{(p_numero_identite => 'CLI-001', p_nom => 'Dupont', p_prenom => 'Test', p_date_naissance => SYSDATE - 365*30, p_telephone => '70000001', p_adresse => '123 Rue Test', p_profession => 'Testeur')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) AJOUTER_CLIENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_CLIENT',
            p_params => q'{(p_numero_identite => 'GEST-CLI-001', p_nom => 'Martin', p_prenom => 'Jean', p_date_naissance => SYSDATE - 365*30, p_telephone => '70000002', p_adresse => '456 Rue Gest', p_profession => 'Gestionnaire')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Client ajouté avec succès');
        -- Teardown
        DELETE FROM CLIENT WHERE NUMERO_IDENTITE = 'GEST-CLI-001';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

