SET SERVEROUTPUT ON;

-- =============================================
-- TEST RAPPORT_PAIEMENTS_EN_RETARD (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) RAPPORT_PAIEMENTS_EN_RETARD ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RAPPORT_PAIEMENTS_EN_RETARD',
            p_params => NULL
        );

        DBMS_OUTPUT.PUT_LINE('✅ Rapport retard généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

