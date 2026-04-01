SET SERVEROUTPUT ON;

-- =============================================
-- TEST AJOUTER_SOUSCRIPTION (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_SOUSCRIPTION ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_SOUSCRIPTION',
            p_params => q'{
                p_nom_souscription => 'Souscription Test',
                p_date_souscription => SYSDATE,
                p_duree => 12,
                p_date_fin => SYSDATE + 365,
                p_montant_prime => 10000,
                p_satut => 'ACTIVE'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Souscription ajoutée (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

