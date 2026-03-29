SET SERVEROUTPUT ON;
-----------------------------
-- TESTS POUR Modifier_Client
-----------------------------
-- Test 1 : Modification autorisée (GESTIONNAIRE)
BEGIN
    Modifier_Client(
        p_id_user_app => 2,  -- GESTIONNAIRE
        p_id_client => 1,
        p_numero_identite => 'CNI-1001A',
        p_nom => 'DIALLO',
        p_prenom => 'Amadou Modifié',
        p_date_naissance => DATE '1990-01-15',
        p_telephone => '70123456',
        p_adresse => 'Ouagadougou',
        p_profession => 'Comptable'
    );
    DBMS_OUTPUT.PUT_LINE('Modifier_Client Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Modifier_Client Test 1: ' || SQLERRM);
END;
/

-- Test 2 : Modification non autorisée (AGENT)
BEGIN
    Modifier_Client(
        p_id_user_app => 3,  -- AGENT
        p_id_client => 1,
        p_numero_identite => 'CNI-1001B',
        p_nom => 'DIALLO',
        p_prenom => 'Amadou Agent',
        p_date_naissance => DATE '1990-01-15',
        p_telephone => '70123456',
        p_adresse => 'Ouagadougou',
        p_profession => 'Comptable'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Modifier_Client Test 2: ' || SQLERRM);
END;
/

-- Test 3 : Client inexistant
BEGIN
    Modifier_Client(
        p_id_user_app => 2,  -- GESTIONNAIRE
        p_id_client => 9999,  -- inexistant
        p_numero_identite => 'CNI-9999',
        p_nom => 'TEST',
        p_prenom => 'Inexistant',
        p_date_naissance => SYSDATE,
        p_telephone => '70000000',
        p_adresse => 'Test',
        p_profession => 'Test'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Modifier_Client Test 3: ' || SQLERRM);
END;
/