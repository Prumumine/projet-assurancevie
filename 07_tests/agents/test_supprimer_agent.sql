SET SERVEROUTPUT ON;

-- =============================================
-- TEST SUPPRIMER_AGENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_AGENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_AGENT',
            p_params => q'{
                p_id_agent => 999
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Agent supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

