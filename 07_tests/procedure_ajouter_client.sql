SET SERVEROUTPUT ON;
-----------------------------
-- TESTS POUR Ajouter_Client
-----------------------------
-- Test 1 : Ajout avec un rôle autorisé (ADMIN)
BEGIN
    Ajouter_Client(
        p_id_user_app => 1,  -- ADMIN
        p_numero_identite => 'CNI-1001',
        p_nom => 'DIALLO',
        p_prenom => 'Amadou',
        p_date_naissance => DATE '1990-01-15',
        p_telephone => '70123456',
        p_adresse => 'Ouagadougou',
        p_profession => 'Comptable'
    );
    DBMS_OUTPUT.PUT_LINE('Ajouter_Client Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Client Test 1: ' || SQLERRM);
END;
/

-- Test 2 : Ajout avec rôle non autorisé (AGENT)
BEGIN
    Ajouter_Client(
        p_id_user_app => 3,  -- AGENT
        p_numero_identite => 'CNI-1002',
        p_nom => 'OUEDRAOGO',
        p_prenom => 'Paul',
        p_date_naissance => DATE '1995-05-10',
        p_telephone => '70234567',
        p_adresse => 'Koudougou',
        p_profession => 'Ingénieur'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Client Test 2: ' || SQLERRM);
END;
/

-- Test 3 : Ajout sans user_app (Oracle direct)
BEGIN
    Ajouter_Client(
        p_numero_identite => 'CNI-1003',
        p_nom => 'KABORE',
        p_prenom => 'Fatou',
        p_date_naissance => DATE '1992-07-20',
        p_telephone => '70345678',
        p_adresse => 'Bobo-Dioulasso',
        p_profession => 'Secrétaire'
    );
    DBMS_OUTPUT.PUT_LINE('Ajouter_Client Test 3: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Client Test 3: ' || SQLERRM);
END;
/
