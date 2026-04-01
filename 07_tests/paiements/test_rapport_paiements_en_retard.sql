SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) RAPPORT_PAIEMENTS_EN_RETARD ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RAPPORT_PAIEMENTS_EN_RETARD'
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
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) RAPPORT_PAIEMENTS_EN_RETARD ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RAPPORT_PAIEMENTS_EN_RETARD'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Rapport généré avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

