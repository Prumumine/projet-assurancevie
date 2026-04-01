SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO PRODUIT (ID_PRODUIT, NOM_PRODUIT, DESCRIPTION, TYPE_PRODUIT, MONTANT_MIN, TAUX_COMMISSION) VALUES (999, 'TestToDel', 'To Delete', 'Vie', 1000, 5);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test produit 999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SUPPRIMER_PRODUIT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_PRODUIT',
            p_params => q'{(p_id_produit => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Produit supprimé (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) SUPPRIMER_PRODUIT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SUPPRIMER_PRODUIT',
            p_params => q'{(p_id_produit => 999)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Produit supprimé avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Teardown
BEGIN
  DELETE FROM PRODUIT WHERE ID_PRODUIT = 999;
  COMMIT;
END;
/

