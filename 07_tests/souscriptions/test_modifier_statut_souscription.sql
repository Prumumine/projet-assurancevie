SET SERVEROUTPUT ON;

-- =============================================
-- TEST MODIFIER_STATUT_SOUSCRIPTION (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_STATUT_SOUSCRIPTION ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_SOUSCRIPTION',
            p_params => q'{
                p_id_souscription => 999,
                p_statut => 'CANCELED'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Statut modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

