SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) AJOUTER_PRODUIT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_PRODUIT',
            p_params => q'{(p_nom_produit => 'Produit Test', p_description => 'Description test', p_type_produit => 'Vie', p_montant_min => 1000, p_taux_commission => 5)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Produit ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) AJOUTER_PRODUIT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_PRODUIT',
            p_params => q'{(p_nom_produit => 'Produit Gest', p_description => 'Gest test', p_type_produit => 'Vie', p_montant_min => 2000, p_taux_commission => 6)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Produit ajouté avec succès');
        -- Teardown
        DELETE FROM PRODUIT WHERE NOM_PRODUIT = 'Produit Gest';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

