SET SERVEROUTPUT ON;

-- =============================================
-- TEST SUPPRIMER_CLIENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_CLIENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_CLIENT',
            p_params => q'{
                p_id_client => 999
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Client supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

