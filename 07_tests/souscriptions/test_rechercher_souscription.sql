SET SERVEROUTPUT ON;

-- =============================================
-- TEST RECHERCHER_SOUSCRIPTION (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) RECHERCHER_SOUSCRIPTION ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RECHERCHER_SOUSCRIPTION',
            p_params => q'{
                p_nom_client => 'Dupont'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Recherche effectuée (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

