SET SERVEROUTPUT ON;

-- =============================================
-- TEST MODIFIER_STATUT_PAIEMENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_STATUT_PAIEMENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_PAIEMENT',
            p_params => q'{
                p_id_paiement => 999,
                p_statut => 'REJECTED'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Statut paiement modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

