SET SERVEROUTPUT ON;

-- =============================================
-- TEST PERFORMANCE_AGENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) PERFORMANCE_AGENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
p_procedure_name => 'PERFORMANCE_AGENT',
            p_params => q'{
                p_date_debut => SYSDATE - 30,
                p_date_fin => SYSDATE
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Rapport généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

