SET SERVEROUTPUT ON;

-- =============================================
-- TEST MODIFIER_CLIENT (non autorisé CLIENT)
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST CLIENT (non autorisé) MODIFIER_CLIENT ===');

    BEGIN
        SYSTEM.Global_Execute_Proc_Oracle(
            p_procedure_name => 'MODIFIER_CLIENT',
            p_params => q'{
                p_id_client => 999,
                p_nom => 'Updated'
            }'
        );

        DBMS_OUTPUT.PUT_LINE('✅ Client modifié (inattendu)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ Erreur: ' || SQLERRM);
    END;
END;
/

