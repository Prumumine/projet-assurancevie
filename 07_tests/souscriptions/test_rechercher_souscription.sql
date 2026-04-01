SET SERVEROUTPUT ON;

-- Case 1: CLIENT (non autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) RECHERCHER_SOUSCRIPTION ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RECHERCHER_SOUSCRIPTION',
            p_params => q'{(p_nom_client => 'Dupont')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Recherche effectuée (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

-- Case 2: GESTIONNAIRE (autorisé)
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST GESTIONNAIRE (autorisé) RECHERCHER_SOUSCRIPTION ===');
    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'RECHERCHER_SOUSCRIPTION',
            p_params => q'{(p_nom_client => 'Martin')}'
        );
        DBMS_OUTPUT.PUT_LINE('✅ Recherche effectuée avec succès');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

