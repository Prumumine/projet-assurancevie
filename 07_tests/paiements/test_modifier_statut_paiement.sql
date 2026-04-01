SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO PAIEMENT (ID_PAIEMENT, DATE_PAIEMENT, MONTANT, MODE_PAIEMENT, STATUT, DEVISE) VALUES (999, SYSDATE, 1000, 1, 'VALIDE', 1);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test paiement 999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_STATUT_PAIEMENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_PAIEMENT',
            p_params => q'{(p_id_paiement => 999, p_statut => 'REJECTED')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Statut modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) MODIFIER_STATUT_PAIEMENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_PAIEMENT',
            p_params => q'{(p_id_paiement => 999, p_statut => 'REJECTED')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Statut modifié avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Teardown
BEGIN
  DELETE FROM PAIEMENT WHERE ID_PAIEMENT = 999;
  COMMIT;
END;
/

