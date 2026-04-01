SET SERVEROUTPUT ON;

-- =============================================
-- TEST MODIFIER_AGENT SECURITY (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_AGENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_AGENT',
            p_params => q'{
                p_id_agent => 999,
                p_nom => 'TestUpdated'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Agent modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

