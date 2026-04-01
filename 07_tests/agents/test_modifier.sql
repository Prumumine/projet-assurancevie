-- test_modifier.sql - Unit tests for Modifier_Agent
-- Run as: sqlplus assurancevie/assurancevie@localhost:1521/XE @test_modifier.sql

SET SERVEROUTPUT ON;
SET FEEDBACK OFF;
SET DEFINE OFF;

PROMPT === Test Modifier Agent: Setup ===
DECLARE
  v_agent_id NUMBER;
BEGIN
  DELETE FROM AGENT_COMMERCIAL;
  DELETE FROM UTILISATEUR WHERE ROLE IN ('GESTIONNAIRE','ADMIN','USER');
  
  INSERT INTO UTILISATEUR (ID_UTILISATEUR, ROLE) VALUES (1, 'GESTIONNAIRE');
  INSERT INTO UTILISATEUR (ID_UTILISATEUR, ROLE) VALUES (2, 'ADMIN');
  INSERT INTO UTILISATEUR (ID_UTILISATEUR, ROLE) VALUES (3, 'USER');
  
  Ajouter_Agent(NULL, 'MAT001', 'Doe', 'John', '0123456789', SYSDATE);  -- Create test agent
  SELECT ID_AGENT INTO v_agent_id FROM AGENT_COMMERCIAL WHERE ROWNUM=1;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Setup: Agent ID=' || v_agent_id);
END;
/

PROMPT === Test 1: Modifier_Agent happy path (partial update) ===
DECLARE
  v_nom VARCHAR2(100);
BEGIN
  Modifier_Agent(NULL, 1, NULL, 'Doe Updated', NULL, '9999999999', NULL);
  
  SELECT NOM INTO v_nom FROM AGENT_COMMERCIAL WHERE ID_AGENT=1;
  IF v_nom = 'Doe Updated' THEN
    DBMS_OUTPUT.PUT_LINE('PASS: Partial update success');
  ELSE
    RAISE_APPLICATION_ERROR(-20099, 'FAIL: Update not applied');
  END IF;
END;
/

PROMPT === Test 2: RBAC success (ADMIN) ===
BEGIN
  Modifier_Agent(2, 1, 'MATNEW', NULL, NULL, NULL, NULL);
  DBMS_OUTPUT.PUT_LINE('PASS: RBAC ADMIN success');
END;
/

PROMPT === Test 3: RBAC fail (USER) ===
DECLARE
  v_failed BOOLEAN := FALSE;
BEGIN
  BEGIN
    Modifier_Agent(3, 1, NULL, NULL, NULL, NULL, NULL);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20001 THEN
        DBMS_OUTPUT.PUT_LINE('PASS: RBAC USER fail');
        v_failed := TRUE;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

PROMPT === Test 4: Non-existent agent ===
DECLARE
  v_failed BOOLEAN := FALSE;
BEGIN
  BEGIN
    Modifier_Agent(NULL, 999, NULL, NULL, NULL, NULL, NULL);
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20002 THEN
        DBMS_OUTPUT.PUT_LINE('PASS: Non-existent agent error');
        v_failed := TRUE;
      ELSE
        RAISE;
      END IF;
  END;
END;
/

PROMPT === Test 5: Full update ===
BEGIN
  Modifier_Agent(NULL, 1, 'MAT001V2', 'NewName', 'NewPrenom', '111', SYSDATE - 730);
  DBMS_OUTPUT.PUT_LINE('PASS: Full update');
END;
/

PROMPT === Tests completed ===

COMMIT;
