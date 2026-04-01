SET SERVEROUTPUT ON;

-- Setup
BEGIN
  INSERT INTO SOUSCRIPTION (ID_SOUSCRIPTION, NOM_SOUSCRIPTION, DATE_SOUSCRIPTION, DUREE, DATE_FIN, MONTANT_PRIME, STATUT) VALUES (999, 'TestSousc', SYSDATE, 12, SYSDATE + 365, 10000, 'ACTIVE');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Test souscription 999 created');
END;
/

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_STATUT_SOUSCRIPTION ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_SOUSCRIPTION',
            p_params => q'{(p_id_souscription => 999, p_statut => 'CANCELED')}'
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
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) MODIFIER_STATUT_SOUSCRIPTION ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_STATUT_SOUSCRIPTION',
            p_params => q'{(p_id_souscription => 999, p_statut => 'CANCELED')}'
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
  DELETE FROM SOUSCRIPTION WHERE ID_SOUSCRIPTION = 999;
  COMMIT;
END;
/

