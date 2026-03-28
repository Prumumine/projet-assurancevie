SET SERVEROUTPUT ON;
-----------------------------
-- TESTS POUR Ajouter_Client
-----------------------------
-- Test 1 : Ajout avec un rôle autorisé (ADMIN)
BEGIN
    Ajouter_Agent(
        p_id_user_app => 21,  -- ADMIN
        p_numero_matricule => 'MA-1001',
        p_nom => 'DIALLO',
        p_prenom => 'SAROU',
        p_telephone => '70123456',
        p_date_embauche=> DATE '2019-01-15'
    );
    DBMS_OUTPUT.PUT_LINE('Ajouter_Agent Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Agent en tant que admin Test 1: ' || SQLERRM);
    COMMIT;
END;
/

-- Test 2 : Ajout avec rôle non autorisé (AGENT)
BEGIN
    Ajouter_Agent(
        p_id_user_app => 23,  
        p_numero_matricule => 'MA-1001',
        p_nom => 'DIALLO',
        p_prenom => 'SAROU',
        p_telephone => '70123456',
        p_date_embauche=> DATE '2019-01-15'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Agent avec role agent Test 2: ' || SQLERRM);
END;
/

-- Test 3 : Ajout sans user_app (Oracle direct)
BEGIN
    Ajouter_Agent(
        p_numero_matricule => 'MA-1004',
        p_nom => 'FANDIE',
        p_prenom => 'Michel',
        p_telephone => '70123456',
        p_date_embauche=> DATE '2025-01-15'
    );
    DBMS_OUTPUT.PUT_LINE('Ajouter_Agent sans user_id Test 3: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ajouter_Agent sans user_id Test 3: ' || SQLERRM);
    COMMIT;
END;
/
