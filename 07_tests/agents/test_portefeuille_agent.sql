SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) ETAT_PORTFEUILLE_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'ETAT_PORTFEUILLE_AGENT',
            p_params => q'{(p_id_agent => 1)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Portefeuille généré (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) ETAT_PORTFEUILLE_AGENT ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'ETAT_PORTFEUILLE_AGENT',
            p_params => q'{(p_id_agent => 1)}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Portefeuille généré avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

