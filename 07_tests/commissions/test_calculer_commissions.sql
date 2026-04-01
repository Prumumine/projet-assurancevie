SET SERVEROUTPUT ON;

-- =============================================
-- TEST CALCULER_COMMISSIONS (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) CALCULER_COMMISSIONS ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'CALCULER_COMMISSIONS',
            p_params => q'{
                p_date_debut => SYSDATE - 30,
                p_date_fin => SYSDATE
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Commissions calculées (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

