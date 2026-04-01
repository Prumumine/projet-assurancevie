-- test_global_wrapper.sql - Tests unitaires Global_Execute_Proc_Oracle RBAC matrix
-- Basé sur Global_Execute_Proc_Oracle et USER_ROLE_EXISTS
-- Run: sqlplus - connect as GESTIONNAIRE/ADMIN + @test_global_wrapper.sql

SET SERVEROUTPUT ON SIZE 1000000;
SET FEEDBACK OFF;
SET DEFINE OFF;

PROMPT === Global Wrapper Tests: Setup ===
DECLARE
BEGIN
  -- Cleanup fixtures
  DELETE FROM AGENT_COMMERCIAL WHERE NUMERO_MATRICULE LIKE 'TEST%';
  DELETE FROM CLIENT WHERE NOM LIKE 'TEST%';
  -- Assume roles available: ROLE_GESTIONNAIRE, ROLE_AGENT
  
  DBMS_OUTPUT.PUT_LINE('Setup complete. Ensure connected as GESTIONNAIRE/ADMIN or SET ROLE ROLE_GESTIONNAIRE');
END;
/

-- =======================================
-- AGENTS TESTS
-- =======================================

PROMPT === Test 1: AJOUTER_AGENT allowed (GESTIONNAIRE/ROLE_GESTIONNAIRE) ===
DECLARE
  v_params CLOB := '(p_numero_matricule => ''TEST001'', p_nom => ''Doe'', p_prenom => ''John'', p_telephone => ''123'', p_date_embauche => SYSDATE)';
  v_count NUMBER;
BEGIN
  Global_Execute_Proc_Oracle('AJOUTER_AGENT', v_params);
  
  SELECT COUNT(*) INTO v_count FROM AGENT_COMMERCIAL WHERE NUMERO_MATRICULE = 'TEST001';
  IF v_count = 1 THEN
    DBMS_OUTPUT.PUT_LINE('PASS: AJOUTER_AGENT allowed ✓');
  ELSE
    DBMS_OUTPUT.PUT_LINE('FAIL: AJOUTER_AGENT not executed');
  END IF;
END;
/

PROMPT === Test 2: AJOUTER_AGENT denied (no role) ===
-- Manual: REVOKE ROLE ROLE_GESTIONNAIRE; then run and expect -20010

PROMPT === Test 3: MODIFIER_AGENT allowed ===
DECLARE
  v_id NUMBER;
  v_params CLOB := '(1, p_numero_matricule => ''TEST001-UPD'', p_nom => ''Doe2'')';  -- Assume ID=1 from prev
BEGIN
  -- Get ID
  SELECT ID_AGENT INTO v_id FROM AGENT_COMMERCIAL WHERE NUMERO_MATRICULE = 'TEST001';
  v_params := '(p_id_user_app=>NULL, p_id_agent=>' || v_id || ', p_numero_matricule => ''TEST001-UPD'')';
  
  Global_Execute_Proc_Oracle('MODIFIER_AGENT', v_params);
  DBMS_OUTPUT.PUT_LINE('PASS: MODIFIER_AGENT allowed ✓');
END;
/

PROMPT === Test 4: PERFORMANCE_AGENT / PORTFEUILLE_AGENT (always allowed read) ===
BEGIN
  Global_Execute_Proc_Oracle('PERFORMANCE_AGENT', '(p_id_agent => 1)');
  DBMS_OUTPUT.PUT_LINE('PASS: PERFORMANCE_AGENT allowed ✓');
END;
/

-- =======================================
-- CLIENTS TESTS (similar pattern)
-- =======================================

PROMPT === Test 5: AJOUTER_CLIENT always allowed ===
DECLARE
  v_params CLOB := '(p_nom => ''TestClient'', p_prenom => ''Test'', p_telephone => ''456'', p_date_naissance => SYSDATE - 10000)';
BEGIN
  Global_Execute_Proc_Oracle('AJOUTER_CLIENT', v_params);
  DBMS_OUTPUT.PUT_LINE('PASS: AJOUTER_CLIENT allowed ✓');
END;
/

PROMPT === Test 6: MODIFIER_CLIENT allowed (ROLE_AGENT/GESTIONNAIRE) ===
-- Similar to above, adjust params

-- Add more for SUPPRIMER_*, CALCULER_COMMISSION, AJOUTER_PAIEMENT etc.

PROMPT === Test USER_ROLE_EXISTS ===
BEGIN
  IF USER_ROLE_EXISTS('ROLE_GESTIONNAIRE') THEN
    DBMS_OUTPUT.PUT_LINE('PASS: USER_ROLE_EXISTS true ✓');
  ELSE
    DBMS_OUTPUT.PUT_LINE('WARN: Set role first');
  END IF;
END;
/

PROMPT === Wrapper tests completed. Manual deny tests needed per role. ===
COMMIT;
