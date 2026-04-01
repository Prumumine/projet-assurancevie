SET SERVEROUTPUT ON;

-- =============================================
-- TEST AJOUTER_PRODUIT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_PRODUIT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_PRODUIT',
            p_params => q'{
                p_nom_produit => 'Produit Test',
                p_description => 'Description test',
                p_type_produit => 'Vie',
                p_montant_min => 1000,
                p_taux_commission => 5
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Produit ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

