SET SERVEROUTPUT ON;

-- =============================================
-- TEST SOUSCRIPTIONS_PROCHES_ECHEANCE (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SOUSCRIPTIONS_PROCHES_ECHEANCE ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SOUSCRIPTIONS_PROCHES_ECHEANCE',
            p_params => NULL
        );

        DBMS_OUTPUT.PUT_LINE('✅ Rapport echeances généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

