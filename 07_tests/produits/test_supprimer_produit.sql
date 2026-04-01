SET SERVEROUTPUT ON;

-- =============================================
-- TEST SUPPRIMER_PRODUIT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_PRODUIT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_PRODUIT',
            p_params => q'{
                p_id_produit => 999
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Produit supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

