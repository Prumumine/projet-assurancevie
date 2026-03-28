SET SERVEROUTPUT ON;
-----------------------------
-- TESTS POUR Modifier_Client
-----------------------------
-- Test 1 : Modification autorisée (GESTIONNAIRE)
BEGIN
    Modifier_Agent(
        p_id_user_app => 22,  -- GESTIONNAIRE
        p_id_agent => 1,
        p_numero_matricule => 'MAT-1001A',
        p_nom => 'DIALLO',
        p_prenom => 'Amadou Modifié',
        p_telephone => '70123456',
        p_date_embauche => DATE '2024-01-15'
    );
    DBMS_OUTPUT.PUT_LINE('Modifier_Agent Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Modifier_Agent Test 1: ' || SQLERRM);
    COMMIT;
END;
/

-- -- Test 2 : Modification non autorisée (AGENT)
-- BEGIN
--     Modifier_Agent(
--         p_id_user_app => 24,  -- GESTIONNAIRE
--         p_id_agent => 1,
--         p_numero_matricule => 'MAT-1001A',
--         p_nom => 'DIALLO',
--         p_prenom => 'Amadou Modifié',
--         p_telephone => '70123456',
--         p_date_embauche => DATE '2024-01-15'
--     );
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('Modifier_Agent avec role non autorige Test 2: ' || SQLERRM);
-- END;
-- /

-- -- Test 3 : Client inexistant
-- BEGIN
--     Modifier_Agent(
--         p_id_user_app => 22,  -- GESTIONNAIRE
--         p_id_agent => 199,
--         p_numero_matricule => 'MAT-1001A',
--         p_nom => 'DIALLO',
--         p_prenom => 'Amadou Modifié',
--         p_telephone => '70123456',
--         p_date_embauche => DATE '2024-01-15'
--     );
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('Modifier_Agent inexistant Test 3: ' || SQLERRM);
-- END;
-- /
-- -- Test 4: Modification direct dans oracle
-- BEGIN
--     Modifier_Agent(
--         p_id_agent => 2,
--         p_numero_matricule => 'MAT-1001A',
--         p_nom => 'FANDIE',
--         p_prenom => 'YOMBISSE MICHEL',
--         p_telephone => '70123456',
--         p_date_embauche => DATE '2024-01-15'
--     );
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('Modifier_Agent directement dans oracle Test 4: ' || SQLERRM);
-- END;
-- /