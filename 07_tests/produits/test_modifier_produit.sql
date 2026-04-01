SET SERVEROUTPUT ON;

-- =============================================
-- TEST MODIFIER_PRODUIT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_PRODUIT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_PRODUIT',
            p_params => q'{
                p_id_produit => 999,
                p_nom_produit => 'Produit Updated'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Produit modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

v