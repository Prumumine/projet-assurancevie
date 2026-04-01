SET SERVEROUTPUT ON;

-- =============================================
-- TEST AJOUTER_PAIEMENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_PAIEMENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_PAIEMENT',
            p_params => q'{
                p_date_paiement => SYSDATE,
                p_montant => 1000,
                p_mode_paiement => 1,
                p_satut => 'VALIDE',
                p_devise => 1
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Paiement ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

