SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) SOUSCRIPTIONS_PROCHES_ECHEANCE ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SOUSCRIPTIONS_PROCHES_ECHEANCE'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Rapport généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) SOUSCRIPTIONS_PROCHES_ECHEANCE ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'SOUSCRIPTIONS_PROCHES_ECHEANCE'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Rapport généré avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

