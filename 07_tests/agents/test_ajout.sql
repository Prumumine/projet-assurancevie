SET SERVEROUTPUT ON;

-- Setup not needed for create

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_AGENT',
            p_params => q'{(p_numero_matricule => 'CLI-001', p_nom => 'Dupont', p_prenom => 'Test', p_telephone => '70000001', p_date_embauche => SYSDATE)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
    COMMIT;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) AJOUTER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_AGENT',
            p_params => q'{(p_numero_matricule => 'GEST-001', p_nom => 'Martin', p_prenom => 'Jean', p_telephone => '70000002', p_date_embauche => SYSDATE)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent ajouté avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
    COMMIT;
END;
/


