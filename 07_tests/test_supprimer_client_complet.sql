-----------------------------
-- TESTS POUR Supprimer_Client
-----------------------------

-- Test 1 : Suppression autorisée avec GESTIONNAIRE
BEGIN
    Supprimer_Client(
        p_id_user_app => 22,  -- Assure-toi que ID_UTILISATEUR 2 est GESTIONNAIRE
        p_id_client   => 5  -- Supprimer n'importe quel client existant sans souscription
    );
    DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 1: Succès');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 1: ' || SQLERRM);
COMMIT;
END;
/

-- Test 2 : Suppression non autorisée (AGENT)
BEGIN
    Supprimer_Client(
        p_id_user_app => 3,  -- AGENT
        p_id_client   => 28  -- Client existant
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 2: ' || SQLERRM);
END;
/

-- Test 3 : Client inexistant
BEGIN
    Supprimer_Client(
        p_id_user_app => 2,  -- GESTIONNAIRE
        p_id_client   => 9999
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 3: ' || SQLERRM);
END;
/

-- Test 4 : Suppression sans p_id_user_app (Oracle direct)
BEGIN
    Supprimer_Client(
        p_id_client => 29  -- Client existant
    );
    DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 4: Succès (Oracle direct)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Supprimer_Client Test 4: ' || SQLERRM);
END;
/