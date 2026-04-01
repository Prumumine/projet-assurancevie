SET SERVEROUTPUT ON;

-- =============================================
-- TEST 1 : CLIENT (non autorisé)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) ===');

    BEGIN
        -- Appel du wrapper global dans SYSTEM
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'AJOUTER_AGENT',
            p_params => q'{
                p_numero_matricule => ''CLI-001'',
                p_nom => ''Dupont'',
                p_prenom => ''Test'',
                p_telephone => ''70000001'',
                p_date_embauche => SYSDATE
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Agent ajouté (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/