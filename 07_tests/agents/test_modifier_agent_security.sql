SET SERVEROUTPUT ON;


-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_AGENT',
            p_params => q'{(p_id_agent => 9, p_nom => 'UpdatedName')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
    COMMIT;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) MODIFIER_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_AGENT',
            p_params => q'{(p_id_agent => 9, p_nom => 'UpdatedName')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Agent modifié avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
    COMMIT;
END;
/
