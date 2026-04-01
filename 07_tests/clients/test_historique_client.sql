SET SERVEROUTPUT ON;

-- =============================================
-- TEST HISTORIQUE_CLIENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) HISTORIQUE_CLIENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'HISTORIQUE_CLIENT',
            p_params => q'{
                p_id_client => 999
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Historique généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

